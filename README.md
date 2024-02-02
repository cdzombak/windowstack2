# windowstack2

Keep a log of frontmost macOS window titles in your terminal, for when you get distracted and need to remember, “what was I doing?”

## Installation via Homebrew

```shell
brew install cdzombak/oss/windowstack2
```

## Usage

```shell
windowstack2
```

### Accessibility Permissions

Your terminal app needs to be allowed Accessibility permission, in the Security & Privacy pane of the System Preferences app.

### Background Job

It is possible to run windowstack2 in the background, constantly writing a log of window titles. This doesn't always work reliably due to macOS's privacy controls, and this mode is not well supported. To install the background job, after installing the program via Homebrew, run:

```shell
wget -P "$HOME/Library/LaunchAgents" https://raw.githubusercontent.com/cdzombak/windowstack2/main/com.dzombak.windowstack2.plist
```

Customize the plist file as desired. In particular, you may wish to adjust the `StandardOutPath`, which sets the logfile location:

```shell
open -a TextEdit "$HOME/Library/LaunchAgents/com.dzombak.windowstack2.plist"
```

Finally, load the launch agent:

```shell
launchctl load "$HOME/Library/LaunchAgents/com.dzombak.windowstack2.plist"
```

## Configuration

### `WINDOWSTACK2_ERRCOLOR`

If this environment variable is set, when the program encounters an error fetching the current window title, the program will print the error as returned from `osascript` using the specified color.

If this variable is not set, these errors are ignored (since typically they can be ignored).

Colors are as follows:

```text
Black        0;30     Dark Gray     1;30
Red          0;31     Light Red     1;31
Green        0;32     Light Green   1;32
Brown/Orange 0;33     Yellow        1;33
Blue         0;34     Light Blue    1;34
Purple       0;35     Light Purple  1;35
Cyan         0;36     Light Cyan    1;36
Light Gray   0;37     White         1;37
```

Example: `WINDOWSTACK2_ERRCOLOR="1;33" ./windowstack.sh`

## Why windowstack*2*?

[WindowStack 1](https://github.com/cdzombak/WindowStack) was an overly complex, initial attempt to implement this in Objective-C. IIRC I ran into issues trying to use the runloop in a CLI app.

This implementation is simpler and actually works.

## About

- GitHub: [cdzombak/windowstack2](https://github.com/cdzombak/windowstack2)
- Author: [Chris Dzombak](https://www.dzombak.com)

## License

LGPLv3; see `LICENSE` in this repository.
