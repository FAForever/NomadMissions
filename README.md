# Official Nomad Campaign

This repository contains the missions for the Nomads campaign, which require the Nomads mod to be played. See the setup instructions on how to play them online, offline, or with the development environment, and remember to have fun!

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

## How do I play the missions online?
----------------------------
These missions are designed to be run on top of the mod, so we need to change how FAF loads the coop mod, so you can then play them. You can play with other people, but every person in the game needs to have followed these instructions to prevent desyncs.

### Official client instructions:
1.You need to have the Nomads mod downloaded onto your computer. Simply host a game with Nomads in FAF by double clicking on it in the featured mod list. This will download the files you need. Once in the lobby you can close the game. You only need to perform this step once per Nomads release, simply to keep the files updated.

2.Download the maps in this repository, and place them into your maps folder, in the same way as you would install the regular maps.

3.Download the ```init_NomadsCoop.lua``` from this repository. You will be using this to run the game in a different way.

4.Place the ```init_NomadsCoop.lua``` file into ```C:\ProgramData\FAForever\bin\``` note: NOT program files

5.In the client, click on `Settings`, then on `Forged Alliance Forever`. Under the `Advanced` section, put ```C:\ProgramData\FAForever\bin\ForgedAlliance.exe /init init_NomadsCoop.lua``` into the `Command line format for executable` field, deleting entirely anything that was there before.

6.It is important to note that you need to disable these changes if you want to play any game without nomads later! To do this, replace the entire contents of the field with `"%s"` (including the quotation marks), reversing step 5. The file can stay in your folder and wont be active unless you do step 5 again.

### Legacy client instructions:
1.You need to have the Nomads mod downloaded onto your computer. Simply host a game with Nomads in FAF by double clicking on it in the featured mod list. This will download the files you need. Once in the lobby you can close the game. You only need to perform this step once per Nomads release, simply to keep the files updated.

2.Download the maps in this repository, and place them into your maps folder, in the same way as you would install the regular maps.

3.Download the ```init_coop.lua``` from this repository. You will be replacing another file with this one.

4.Open ```C:\ProgramData\FAForever\bin\```. There you will find a file called ```init_coop.lua```. If it is not there, host a game of coop on FAF to download the files.

5.Place the ```init_coop.lua``` that you have just downloaded into the folder, replacing the file already there.

6.Set the file to read only. To do this, right-click on it, and select 'properties'. Then check the read-only box.

7.Host a coop game through FAF on any map. If everything was done correctly, you _should_ get two errors when hosting the game saying that a file could not be patched. The nomads should appear as a faction choice in the lobby.

8.Switch maps to a map from the Nomads campaign, and enjoy!

9.It is important to note that you need to disable these changes if you want to play coop missions without nomads later! To do this, simply uncheck the read only option from your ```init_coop.lua``` or delete it and it will be patched next time you run coop. You are can play non-coop games normally without disabling these changes, so if you only play Nomads coop missions then you dont need to do anything.
