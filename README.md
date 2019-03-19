# NomadMissions

This repository contains the missions for the Nomads campaign, and require the Nomads mod to be played. See the setup instructions on how to play them online, offline, or with the development environment, and remember to have fun!

We can use all the help we can get both with these missions and the parent mod:
- coding
- modelling
- texturing
- effects improving
- testing
- mission making
- giving feedback
- and much more!

Be sure to visit our discord server [here](http://wiki.faforever.com/index.php?title=FAF_Dev_School_Git) where you can help out, comment or simply keep up with progress on the mod. Everyone is welcome!

How do I play the missions online?
----------------------------
These missions are designed to be run on top of the mod, so we need to change how FAF loads the coop mod, so you can then play them. You can play with other people, but every person in the game needs to have followed these instructions to prevent desyncs.

1.You need to have the nomads mod downloaded onto your computer. Simply host a game with Nomads in FAF by double clicking on it in the featured mod list. This will download the files you need. Once in the lobby you can close the game.
2.Download the maps in this repository, and place them into your maps folder, in the same way as you would install the regular maps.
3.Download the ```init_coop.lua``` from this repository. You will be replacing another file with this one.
4.Open ```C:\ProgramData\FAForever\bin\```. There you will find a file called ```init_coop.lua```. If it is not there, host a game of coop on FAF to download the files.
5.Place the ```init_coop.lua``` that you have just downloaded into the folder, replacing the file already there.
6.Set the file to read only. To do this, right-click on it, and select 'properties'. Then check the read-only box.
7.Host a coop game through FAF on any map. If everything was done correctly, you _should_ get two errors when hosting the game saying that a file could not be patched. The nomads should appear as a faction choice in the lobby.
8.Switch maps to a map from the Nomads campaign, and enjoy!
