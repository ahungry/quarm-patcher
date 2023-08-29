# Quarm Patcher

This patcher (see releases) may help some windows users confirm they
have the right game setup (as well as pull in the Quarm specific files).

If you are using GNU/Linux, you may consider using the custom Lutris
build script instead:

https://gist.github.com/ahungry/b6427ebe04dc6dfbfb0e2122bad0cdab


# Building

Requires a working copy of nim (2.0+).
Then add a few deps:

```
nimble install zip
nimble install nigui
nimble install checksums
```

For GNU/Linux: `make`

For Windows (built under GNU/Linux): `make quarm_patcher.exe`
(requires mingw packages to be installed).

To build the releases: `make release`

# Copyright
Copyright Matthew Carter <m@ahungry.com>

# License
GPLv3 or later
