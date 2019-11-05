# x16-chasevault
Chase Vault: A new game for the Commander X16 retrocomputer.

As seen on YouTube: https://youtu.be/bLf6OZcqwIY

![](cv3.gif)

Too build PRG file, run **build.sh** in bash (Git bash is recommended for Windows).

Build requirements: gcc, cc65

Please note at this time that the game is not yet fully
playable. It is under active development, so the master branch is not stable.

Last working demo commit: https://github.com/SlithyMatt/x16-chasevault/commit/0dddb0ce8caa404423f93fbbbcd53b303e8ab85d
This build will allow you to move the player around, eat pellets, and die if touched by an enemy unless still vulnerable after the player eats a power pellet. Enemies at this time do not move.
