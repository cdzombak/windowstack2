# windowstack2

Keep a log of frontmost macOS window titles in your terminal, for when you get distracted and need to remember, “what was I doing?”

## Usage

```shell
windowstack
```

## Accessibility Permissions

Your terminal app needs to be allowed Accessibility permission, in the Security & Privacy pane of the System Preferences app.

## Why windowstack2?

[WindowStack 1](https://github.com/cdzombak/WindowStack) was an overly complex, initial attempt to implement this in Objective-C. IIRC I ran into issues trying to use the runloop in a CLI app.

This implementation is simpler and works.
