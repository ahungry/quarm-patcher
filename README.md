# Quarm Patcher

Just a quick little POC to try out nim cross-platform GUI build.

If you were to use this, you'd put it in your game directory setup
via this process:

https://gist.github.com/ahungry/b6427ebe04dc6dfbfb0e2122bad0cdab

and run the included binary (see Releases), "quarm_patcher.exe" (then
click Patch or Run Game).

# Building

Requires a working copy of nim (2.0+).
Then add a few deps:

```
nimble install zip
nimble install nigui
```

For GNU/Linux: `make`

For Windows (built under GNU/Linux): `make quarm_patcher.exe`
(requires mingw packages to be installed).

# TODO

Add some releases/a logo/remove superflous alert pop up.

# Copyright
Copyright Matthew Carter <m@ahungry.com>

# License
GPLv3 or later
