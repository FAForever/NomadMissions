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

Be sure to visit our discord server [here](https://discord.gg/Tqar3cu) where you can help out, comment or simply keep up with progress on the mod. Everyone is welcome!

## How do I play the missions online?
----------------------------
These missions are designed to be run on top of the mod, so we need to change how FAF loads the coop mod, so you can then play them. You can play with other people, but every person in the game needs to have followed these instructions to prevent desyncs.

### Mission file installation:
Before installing, we must first download the mod files using the FAF client. Do the following:
1. Host a game of Nomads on FAF. You can quit in the game lobby as soon as the patch has finished downloading
1. Host a game of Coop on FAF. You can quit in the game lobby as soon as the patch has finished downloading, just like before.

To make things easier for you, we include an installer for the Nomads campaign. It includes the following:
- The mission maps
- Voice & Video files for the narration
- Special files to enable coop play
- A shortcut for offline play

Get the latest installer from the releases page on this repo, here: https://github.com/FAForever/NomadMissions/releases

1. Follow the on-screen instructions. 
1. Once that is done, you should be able to launch offline play! Use the shortcut to start the game, it will put you into the main menu. 
1. Select skirmish. If everything went correctly, you should see Nomads as a faction option, and for the map to be set to a coop map, just as Black Day. 
1. Switch maps to a Nomads mission of your choice, press the ready button and launch the game!

### Enabling Online Play:
To play with your friends, you need to tell the FAF client to run the game with Nomads files loaded:

1. In the client, click on `Settings`, then on `Forged Alliance Forever`. Under the `Advanced` section, put ```C:\ProgramData\FAForever\bin\ForgedAlliance.exe /init init_NomadsCoop.lua``` into the `Command line format for executable` field, deleting entirely anything that was there before.
  * Note: Do not include any quotation marks around the contents you put into this field.
1. Host a coop mission on any map, switch maps to a map from the Nomads campaign, and enjoy!
1. It is important to note that you need to disable these changes if you want to play _any_ game without nomads later! To do this, replace the entire contents of the field with `"%s"` (including the quotation marks), reversing step 5. The file can stay in your folder and wont be active unless you do step 5 again.


## Manual file installation:
You should be using the installer above since its easier, but if something is wrong you can follow the instructions below to place all the files manually.

You need to download all the files that the missions need to work, and then enable the missions by following either the Official client instructions, or the legacy client instructions. Also make sure to read the instructions to the very end, as you will need to disable the changes after playing!

1. You need to have the Nomads mod downloaded onto your computer. Simply host a game with Nomads in FAF by double clicking on it in the featured mod list. This will download the files you need. Once in the lobby you can close the game. You only need to perform this step once per Nomads release, simply to keep the files updated.
1. Make sure you have also downloaded the latest coop mod. Similar to above, host a coop game to let the client download the files. You can then close the game without starting.
1. Download the maps in this repository, and place them into your maps folder, in the same way as you would install the regular maps. Click on the green `Clone or download` button near the top of this page, and choose download as zip. Then unpack the maps into your maps folder. Hang onto the zip file. You will some files from it later when enabling the missions.
1. These missions have custom sounds and videos. You can grab them from this folder here: https://mega.nz/#F!YhBhlaiR!BsgJziQalzs5ZJtU6iqXfQ
  * Each mission has two files, sound and video. The sound files are `N0x_VO.nx2` while the video files have `Movies_UnPackMe` at the end of their name.
  * Place the ```N0x_VO.nx2``` file into ```C:\ProgramData\FAForever\gamedata\``` note: NOT program files, and do not unpack the file.
     * Note: ProgramData is a hidden folder. if you cant see it, copy and paste the above url into the explorer address bar, or turn on hidden folder visibility in the control panel. Putting files into Program Files wont work.
  * Unpack the Movies file into: ```C:\ProgramData\FAForever\movies```  note: NOT program files, you must unpack the file, which will contain a set of `.sfd` files.

You are all set to enable the missions! Follow either the official (downlords) client instructions, or the legacy client instructions to enable the missions.

### Official client instructions:

1. If you haven't already during the file installation, download the ```init_NomadsCoop.lua``` from this repository. You will be using this to run the game in a different way.
1. Place the ```init_NomadsCoop.lua``` file into ```C:\ProgramData\FAForever\bin\``` note: NOT program files
1. In the client, click on `Settings`, then on `Forged Alliance Forever`. Under the `Advanced` section, put ```C:\ProgramData\FAForever\bin\ForgedAlliance.exe /init init_NomadsCoop.lua``` into the `Command line format for executable` field, deleting entirely anything that was there before.
  * Note: Do not include any quotation marks around the contents you put into this field.
1. Host a coop mission on any map, switch maps to a map from the Nomads campaign, and enjoy!
1. It is important to note that you need to disable these changes if you want to play _any_ game without nomads later! To do this, replace the entire contents of the field with `"%s"` (including the quotation marks), reversing step 5. The file can stay in your folder and wont be active unless you do step 5 again.

### Legacy client instructions:
1. If you haven't already during the file installation, download the ```init_NomadsCoop.lua``` from this repository. You will be replacing another file with this one.
1. Open ```C:\ProgramData\FAForever\bin\```. There you will find a file called ```init_coop.lua```. If it is not there, host a game of coop on FAF to download the files.
1. Rename the ```init_NomadsCoop.lua.lua``` that you have just downloaded to ```init_coop.lua``` and place it into the folder, replacing the file already there.
1. Set the file to read only. To do this, right-click on it, and select 'properties'. Then check the read-only box. This will prevent FAF from resetting your modified file.
1. Host a coop game through FAF on any map. If everything was done correctly, you _should_ get two errors when hosting the game saying that a file could not be patched. The nomads should appear as a faction choice in the lobby.
1. Switch maps to a map from the Nomads campaign, and enjoy!
1. It is important to note that you need to disable these changes if you want to play coop missions without nomads later! To do this, simply uncheck the read only option from your ```init_coop.lua``` or delete it and it will be patched next time you run coop. You are can play non-coop games normally without disabling these changes, so if you only play Nomads coop missions then you dont need to do anything. Additionally, running coop with Downlords client will not work while you have this file set to read-only!

## How do i test the missions with the development version of Nomads?
----------------------------
You can also play these missions offline against the github repository of nomads, which lets you test them with future nomads patches. 
1. To do this, you first must set up your nomads so you can launch that offline. Follow the instructions on the main repository [here](https://github.com/FAForever/nomads#how-do-i-start-contributing) and continue once you have successfully launched an offline game of nomads. The remaining steps are analogous to what you did with the main repository.
1. Download the ```init_DevNomadsCoop.lua``` from this repository. Place it inside ```C:\ProgramData\FAForever\bin\```, which is a folder you should already be familiar with as it was a required step to set up Development Nomads.
1. Open the ```init_DevNomadsCoop.lua``` and change your first two lines to correspond to your repository locations, just as you have done for the nomads init file previously.
The lines are at the start of the file, so you can't miss them.
   - *( Make sure you don't edit the original file, to avoid problems later )*
   - Make sure you pay attention to the double slashes in the file paths, and put them into the paths or they will not work!
   - `dev_path = 'E:\\GITS\\fa'` corresponds to the path to the FA repository
   - `dev_pathnomads = 'E:\\GITS\\nomads'` corresponds to the path to the Nomads repository

1. Inside the same folder, ```C:\ProgramData\FAForever\bin\```, you'll find `ForgedAlliance.exe`
1. As before for Nomads, make a shortcut for it either by right clicking on the file and putting it in an easily accessable place or right clicking in the folder you want the shortcut to be in and making a new shortcut there. *(For example your desktop)*
1. As before, go into its properties (right click) and change the target:
```
C:\ProgramData\FAForever\bin\ForgedAlliance.exe /init init_DevNomadsCoop.lua /EnableDiskWatch /showlog /log C:\ProgramData\FAForever\logs\speed2coop.log
```
1. Launch the game. If you did everything correctly you should be able to switch to a coop map in the skirmish menu.
