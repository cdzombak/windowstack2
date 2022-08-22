#!/usr/bin/env bash
set -o pipefail

[[ -z "${WINDOWSTACK2_ERRCOLOR}" ]] && ERRCOLOR="NONE" || ERRCOLOR="\033[${WINDOWSTACK2_ERRCOLOR}m"
set -u

VERSION="1.1.0"

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
			tell (1st window whose value of attribute "AXMain" is true)
				set windowTitle to value of attribute "AXTitle"
			end tell
		end if
	end tell
end tell
return frontAppName & ":  " & windowTitle
' 2>&1)"

	if [ $? -eq 0 ]; then
		if [ "$LAST_TITLE" != "$CURRENT_TITLE" ]; then
			echo "$(date +%T)""   ""$CURRENT_TITLE"
			LAST_TITLE="$CURRENT_TITLE"
		fi
	elif [[ "$CURRENT_TITLE" =~ "-25211" ]]; then
		echo -e "${RED}Your terminal application must be allowed Accessibility permissions. Please set that now, in the Security & Privacy preference pane.${NC}"
		open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
		exit 1
	elif [[ "$ERRCOLOR" != "NONE" ]] ; then
		echo -e "$(date +%T)""   ""${ERRCOLOR}$CURRENT_TITLE${NC}"
	fi

	if [ $(( SECONDS - LAST_PMSET_CHECK_S )) -gt 29 ]; then
		do_pmset_check
	fi
	sleep $SLEEP_INTERVAL
done
