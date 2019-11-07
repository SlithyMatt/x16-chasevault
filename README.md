# x16-chasevault
Chase Vault: A new game for the Commander X16 retrocomputer.

As seen on YouTube: https://youtu.be/bLf6OZcqwIY

![](cv4.gif)

Too build PRG file, run **build.sh** in bash (Git bash is recommended for Windows).

Build requirements: gcc, cc65

Please note at this time that the game is not yet fully
playable. It is under active development, so the master branch is not stable.

Last working demo commit: https://github.com/SlithyMatt/x16-chasevault/tree/2446ba9ee20b11ceb3e81735c2d453d3eb14feda
This build will allow you to move the player around, eat pellets, and die if touched by an enemy unless still vulnerable after the player eats a power pellet. Enemies at this time only execute a "scatter" AI and pay no attention to the player position.
