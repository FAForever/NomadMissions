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

### Mission file installation:
You need to download all the files that the missions need to work, and then enable the missions by following either the Official client instructions, or the legacy client instructions. Also make sure to read the instructions to the very end, as you will need to disable the changes after playing!

1. You need to have the Nomads mod downloaded onto your computer. Simply host a game with Nomads in FAF by double clicking on it in the featured mod list. This will download the files you need. Once in the lobby you can close the game. You only need to perform this step once per Nomads release, simply to keep the files updated.
2. Make sure you have also downloaded the latest coop mod. Similar to above, host a coop game to let the client download the files. You can then close the game without starting.
3. Download the maps in this repository, and place them into your maps folder, in the same way as you would install the regular maps. Click on the green `Clone or download` button near the top of this page, and choose download as zip. Then unpack the maps into your maps folder. Hang onto the zip file. You will some files from it later when enabling the missions.
4. These missions have custom sounds and videos. You can grab them from this folder here: https://mega.nz/#F!YhBhlaiR!BsgJziQalzs5ZJtU6iqXfQ
..* Each mission has two files, sound and video. The sound files are `N0x_VO.nx2` while the video files have `Movies_UnPackMe` at the end of their name.
..* Place the ```N0x_VO.nx2``` file into ```C:\ProgramData\FAForever\gamdata\``` note: NOT program files, and do not unpack the file.
..* Unpack the Movies file into: ```C:\ProgramData\FAForever\movies```  note: NOT program files, you must unpack the file, which will contain a set of `.sfd` files.

You are all set to enable the missions! Follow either the official (downlords) client instructions, or the legacy client instructions to enable the missions.

### Official client instructions:

1. If you haven't already during the file installation, download the ```init_NomadsCoop.lua``` from this repository. You will be using this to run the game in a different way.
2. Place the ```init_NomadsCoop.lua``` file into ```C:\ProgramData\FAForever\bin\``` note: NOT program files
3. In the client, click on `Settings`, then on `Forged Alliance Forever`. Under the `Advanced` section, put ```C:\ProgramData\FAForever\bin\ForgedAlliance.exe /init init_NomadsCoop.lua``` into the `Command line format for executable` field, deleting entirely anything that was there before.
..* Note: Do not include any quotation marks around the contents you put into this field.
4. Host a coop mission on any map, switch maps to a map from the Nomads campaign, and enjoy!
5. It is important to note that you need to disable these changes if you want to play any game without nomads later! To do this, replace the entire contents of the field with `"%s"` (including the quotation marks), reversing step 5. The file can stay in your folder and wont be active unless you do step 5 again.

### Legacy client instructions:
1. If you haven't already during the file installation, download the ```init_coop.lua``` from this repository. You will be replacing another file with this one.
2. Open ```C:\ProgramData\FAForever\bin\```. There you will find a file called ```init_coop.lua```. If it is not there, host a game of coop on FAF to download the files.
3. Place the ```init_coop.lua``` that you have just downloaded into the folder, replacing the file already there.
4. Set the file to read only. To do this, right-click on it, and select 'properties'. Then check the read-only box.
5. Host a coop game through FAF on any map. If everything was done correctly, you _should_ get two errors when hosting the game saying that a file could not be patched. The nomads should appear as a faction choice in the lobby.
6. Switch maps to a map from the Nomads campaign, and enjoy!
7. It is important to note that you need to disable these changes if you want to play coop missions without nomads later! To do this, simply uncheck the read only option from your ```init_coop.lua``` or delete it and it will be patched next time you run coop. You are can play non-coop games normally without disabling these changes, so if you only play Nomads coop missions then you dont need to do anything. Additionally, running coop with Downlords client will not work while you have this file set to read-only!
