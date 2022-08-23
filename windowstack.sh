#!/usr/bin/env bash
set -o pipefail

[[ -z "${WINDOWSTACK2_ERRCOLOR}" ]] && ERRCOLOR="NONE" || ERRCOLOR="\033[${WINDOWSTACK2_ERRCOLOR}m"
set -u

VERSION="1.3.1"

if [ $# -gt 0 ]; then
	if [[ "$1" == "-v" || "$1" == "--version" ]]; then
		echo "windowstack2 $VERSION"
		exit 0
	fi
	echo "unknown arg: $1"
	exit 1
fi

SLEEP_INTERVAL=""
LAST_PMSET_CHECK_S=$SECONDS

do_pmset_check() {
	if [[ $(pmset -g ps | head -1) =~ "AC Power" ]]; then
		SLEEP_INTERVAL=1
	else
		SLEEP_INTERVAL=3
	fi
	LAST_PMSET_CHECK_S=$SECONDS
}
do_pmset_check

LAST_TITLE=""

RED='\033[0;31m'
NC='\033[0m'

finder_selection() {
	osascript 2> /dev/null <<EOF
set output to ""
tell application "Finder" to set the_selection to selection
set item_count to count the_selection
repeat with item_index from 1 to count the_selection
	if item_index is less than item_count then set the_delimiter to "\n"
	if item_index is item_count then set the_delimiter to ""
	set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
end repeat
EOF
}

while true; do
	CURRENT_TITLE="$(osascript -e '
global frontApp, frontAppName, windowTitle
set windowTitle to ""
delay 2
tell application "System Events"
	set frontApp to first application process whose frontmost is true
	set frontAppName to name of frontApp
	tell process frontAppName
		if (count of windows) > 0 then
			tell (1st window)
				set windowTitle to value of attribute "AXTitle"
			end tell
		end if
	end tell
end tell
return frontAppName & ":  " & windowTitle
' 2>&1)"

	if [ $? -eq 0 ]; then
		if [ "$CURRENT_TITLE" == "Finder:  Quick Look" ]; then
			SELECTION="$(finder_selection)"
			CURRENT_TITLE="Quick Look:  $SELECTION"
		fi
		if [[ "$CURRENT_TITLE" == *":  " && "$CURRENT_TITLE" != "zoom.us:"* ]]; then
			# ignore if window title is missing
			# unless it's zoom, which misbehaves
			CURRENT_TITLE="$LAST_TITLE"
		fi
		if [ "$LAST_TITLE" != "$CURRENT_TITLE" ]; then
			echo "$(date +%T)""   ""$CURRENT_TITLE"
			LAST_TITLE="$CURRENT_TITLE"
		fi
	elif [[ "$CURRENT_TITLE" =~ "-25211" ]]; then
		echo -e "${RED}Your terminal application must be allowed Accessibility permissions. Please set that now, in the Security & Privacy preference pane.${NC}"
		open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
		exit 1
	# Handle/ignore any other error depending on config:
	elif [[ "$ERRCOLOR" != "NONE" ]] ; then
		echo -e "${ERRCOLOR}$(date +%T)   $CURRENT_TITLE${NC}"
	fi

	if [ $(( SECONDS - LAST_PMSET_CHECK_S )) -gt 29 ]; then
		do_pmset_check
	fi
	sleep $SLEEP_INTERVAL
done
