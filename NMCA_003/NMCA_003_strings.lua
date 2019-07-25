--[[
Mission Description:
    Briefing:
        In a nearby sector, one of your ships attempting to find safe territory is shot down, and the fleet commander instructs your commander to rescue the crew before they are killed off by the enemy (Aeon) forces on planet.
        You arrive there and discover that much of the planet is already in ruin; the UEF forces that were in the region are being killed off, and the Aeon are obliterating them in swath of merciless destruction.

    Mission 1:
        Intro:
            Cinematics start at small Aeon base, dialogue that the ship has to be somewhere close. The signal from the crashed ship is coming from the north. Camera moves to the north where the crashed ship is.
            You are sent there to defend the ship.

        Primary:
            First objectives are to defend the ship against the Aeon attack and destroy the Aeon base to the south.

            Few minutes later ally engineers fly in on the transports to scan and repair the ship. Soon you'll find out you will need to get specific crystals to repair the ship. There are 2 in this part,
            one close to the player's base, second behind the Aeon base.

            Reclaiming the crystals triggers the map expansion (since more crystals are needed to repair the ship) if player is fast, else there is a random Aeon attack (either Naval or Air attack) from the west,
            and few minutes after that the map expands to the second part.
                +-20 min on hard difficulty for the map to expand to the second part on it's own.
                Different dialogues when the map expands on it's own and when player manages to reclaim the crystals.

        Secondary:
            There's a small civilian settlement next to the Aeon base, objective to capture one of the buildings to get additional intel. This is assigned once the player scouts the settlement
                This will be used in the second part of the mission to get a free intel on (some defenses/factories, TBD)

        Bonus:
            Capture Aeon factory or engineer
            Build a shield over the crashed ship.
            All ally engineers repairing the ship survive.

        Unlocked Tech:
            T2 Static Shield - 3 minutes into the mission

    Mission 2:
        Intro:
            Cinematics start at player's ACU, "scanning area aroud for more crystals". Player is assigned to move to the west (that's where the attack came from) to reclaim 3 more crystals that are located there,
            and to deal with the Aeon bases before they are significant threat.

        Primary:
            Reclaim 3 more crystals to repair more ship's systems.

            After some minutes, cinematics to the off map at gating Aeon ACU.
                The ACU will keep building the base, so finishing the objectives faster will lead to less developed base in the next part of the mission.

            When player reclaims the crystals or several minutes later, Aeon counter attack coming from the north. This will expand the map to the north/main Aeon base.

        Secondary:
            Destroy 2 Aeon bases. This is no longer a primary objective.

        Bonus:
            Destroy over X Submarine Hunters (exact number in the script)
            Shoot down engineer drop from south base (this will cause one less enemy base in the final part)

        Unlocked Tech:
            Railgun boat - 2 minutes into the mission
            T2 Arty - 11 min into the mission

    Mission 3:
        Intro:
            Cinematics at the incoming attack from the main base (north-west).

            Frist research building will be on the north island.

        Primary:
            Defend the Aeon counter attack.

            After a momnet another primary objective to locate the research building is assigned.

            When both counter attack and research building is located the map will expand to the last part.

        Secondary:
            Defeat the enemy ACU, once player scouts it.

        Unlocked Tech:
            RAS - 2 min into the mission

    Mission 4:
        Primary:
            Destroy 4 research stations locations.
            North one has a base with the tempest, South one is spawned depending on if the engineer drop in M2 was shot down or not.

        Secondary:
            Destroy the Tempest.
            There's a Tempest being built in the North research base.

        Bonus:
            Destroy the Tempest before it's completed.

        Unlocked Tech:
            TMD/TML - 1 min into the mission
            Field Engineer - 7 min into the mission
    
    Outro:
        Cinematics at the ship leaving the planet.
--]]



OPERATION_NAME = 'Frosty Winds'
OPERATION_DESCRIPTION = 'Your long range communications have picked up an emergency signal from a ship which was set to establish a beacon as part of a critical operation to determine Earth\'s coordinates. You\'ve been unable to raise communications with the apparently downed vessel. Your mission is to head to the coordinates received from the ship\'s emergency locator transmitter, and retrieve the ship and any survivors. The ship holds vital data regarding our current operations, the locations of our fleets, and most importantly, the Nomad homeworld. Do not let it fall into enemy hands!'



-------------
-- Debriefing
-------------
-- Showed on the score screen if player wins
Debriefing_Win = {
    {
        text = 'You win', faction = 'Nomads'
    },
}

-- Showed on the score screen if player loses
Debriefing_Lose = {
    {
        text = 'You lose', faction = 'Nomads'
    },
}



-------------
-- Win / Lose
-------------
-- When the ship dies
ShipDestroyed = {
    {
        text = '[Benson]: We\'ve lost it, sir! The ship has been destroyed.',
        vid = 'N03_ShipDestroyed_1.sfd', bank = 'N03_VO', cue = 'ShipDestroyed_1', faction = 'Nomads'
    },
    {
        text = '[Nichols]: We\'ve failed, Captain. Command will need to be informed.',
        vid = 'N03_ShipDestroyed_2.sfd', bank = 'N03_VO', cue = 'ShipDestroyed_2', faction = 'Nomads'
    },
}

-- Player dies (myself)
PlayerDies1 = {
    {
        text = '[Nichols]: Your armour is breached! That command unit is going critical! Get out if you can! Captain! He\'s gone...',
        vid = 'N03_PlayerDies1.sfd', bank = 'N03_VO', cue = 'PlayerDies1', faction = 'Nomads'
    },
}

-- Player dies (other player), using the same video for both to avoid desync, Not used
-- PlayerDies2 = {
--     {
--         text = '[Nichols]: We\'ve lost all contact with the support unit, sir. Looks like you\'re on your own from here!',
--         vid = 'N03_PlayerDies1.sfd', bank = 'N03_VO', cue = 'PlayerDies2', faction = 'Nomads'
--     },
-- }

-- 
PlayerWin1 = {
    {
        text = '[Nichols]: Excellent job, sir. The area has been secured, and all orbital cannons are reading as offline.',
        vid = 'N03_PlayerWin1.sfd', bank = 'N03_VO', cue = 'PlayerWin1', faction = 'Nomads'
    },
    {
        text = '[Benson]: System checks are complete. The ship is fully operational, and engines are powering up now.',
        vid = 'N03_PlayerWin2.sfd', bank = 'N03_VO', cue = 'PlayerWin2', faction = 'Nomads'
    },
    {
        text = '[Nichols]: Running at 100% across the board - the ship is ready to leave at your command, Captain, but sooner rather than later would be an excellent choice.',
        vid = 'N03_PlayerWin3.sfd', bank = 'N03_VO', cue = 'PlayerWin3', faction = 'Nomads'
    },
}



------------
-- Mission 1
------------
-- Look at the Aeon base
M1Intro1 = {
    {
        text = '[Nichols]: We\'re entering the planet\'s atmosphere and beginning our scans for the ship\'s transmitter now, Captain. They picked one hell of a place to set up that beacon - this place looks like a frozen wasteland.',
        vid = 'N03_M1Intro1.sfd', bank = 'N03_VO', cue = 'M1Intro1', faction = 'Nomads'
    },
}

-- Move cam to the crashed ship
M1Intro2 = {
    {
        text = '[Benson]: Got a lock on the emergency transmitter. It\'s close! Relaying the coordinates now.',
        vid = 'N03_M1Intro2.sfd', bank = 'N03_VO', cue = 'M1Intro2', faction = 'Nomads'
    },
}

-- Spawn ACU and move cam to it
M1Intro3 = {
    {
        text = '[Nichols]: There it is, Captain! No time to waste - get out there and assess the damage to that ship. We need to get it repaired and get the hell off this block of ice.',
        vid = 'N03_M1Intro3.sfd', bank = 'N03_VO', cue = 'M1Intro3', faction = 'Nomads'
    },
}



-- Assign primary objectives, protect ship, kill aeon base
M1PostIntro = {
    {
        text = '[Nichols]: It doesn\'t look like we\'re alone here, Captain. We\'re picking up scrambled communications from multiple sources. They\'re originating from a number of unidentified units closing in on your position. Secure the area, and defend that ship!',
        vid = 'N03_M1PostIntro_1.sfd', bank = 'N03_VO', cue = 'M1PostIntro_1', faction = 'Nomads'
    },
    {
        text = '[Nichols]: Your strongest move now is to establish a base and send forces to the south to destroy the threat.',
        vid = 'N03_M1PostIntro_2.sfd', bank = 'N03_VO', cue = 'M1PostIntro_2', faction = 'Nomads'
    },
}

-- Player kills the first Aeon base
M1AeonBaseDestroyed = {
    {
        text = '[Nichols]: Hostiles destroyed, sir. Nice job. Gonna make a Commodore of you yet.',
        vid = 'N03_M1AeonBaseDestroyed.sfd', bank = 'N03_VO', cue = 'M1AeonBaseDestroyed', faction = 'Nomads'
    },
}

-- Reminder #1 to kill Aeon base
M1AeonBaseReminder1 = {
    {
        text = '[Nichols]: That hostile base is still a threat, Captain. Destroy it now.',
        vid = 'N03_M1AeonBaseReminder1.sfd', bank = 'N03_VO', cue = 'M1AeonBaseReminder1', faction = 'Nomads'
    },
}

-- Reminder #2 to kill Aeon base
M1AeonBaseReminder2 = {
    {
        text = '[Nichols]: What are you waiting for? Unconditional surrender? Finish them, Captain!',
        vid = 'N03_M1AeonBaseReminder2.sfd', bank = 'N03_VO', cue = 'M1AeonBaseReminder2', faction = 'Nomads'
    },
}



-- When the ship gets damaged
M1ShipDamaged = {
    {
        text = '[Benson]: Hostiles are opening fire! Protect the ship!',
        vid = 'N03_M1ShipDamaged.sfd', bank = 'N03_VO', cue = 'M1ShipDamaged', faction = 'Nomads'
    },
}

-- When the ship drops to half HP
M1ShipHalfDead = {
    {
        text = '[Benson]: The ship is sustaining significant damage, Captain!',
        vid = 'N03_M1ShipHalfDead.sfd', bank = 'N03_VO', cue = 'M1ShipHalfDead', faction = 'Nomads'
    },
}

-- When the ship is nearly destroyed
M1ShipAlmostDead = {
    {
        text = '[Benson]: The ship\'s hull is breached! We\'ll lose it if it takes any further damage!',
        vid = 'N03_M1ShipAlmostDead.sfd', bank = 'N03_VO', cue = 'M1ShipAlmostDead', faction = 'Nomads'
    },
}



-- Player captures Aeon construction unit
M1AeonUnitCaptured = {
    {
        text = '[Benson]: We\'re accessing the data from the captured unit. Looks like we\'ve managed to get some good intel on the technology they\'re using.',
        vid = 'N03_M1AeonUnitCaptured.sfd', bank = 'N03_VO', cue = 'M1AeonUnitCaptured', faction = 'Nomads'
    },
}



-- First Aeon units close the the player
M1AeonAttackWarning = {
    {
        text = '[Nichols]: We\'ve got readings on what look like more hostiles heading your way, Captain. Prepare to engage!',
        vid = 'N03_M1AeonAttackWarning.sfd', bank = 'N03_VO', cue = 'M1AeonAttackWarning', faction = 'Nomads'
    },
}



-- Player sees the dead UEF Base
M1UEFBaseDialogue = {
    {
        text = '[Nichols]: It seems like we\'re not the first ones to have encountered those hostiles; those structures are definitely UEF, and itlooks like one hell of a fight took place here. Be careful, sir, they must have a sizeable base in operation if they\'re responsible for this.',
        vid = 'N03_M1UEFBaseDialogue.sfd', bank = 'N03_VO', cue = 'M1UEFBaseDialogue', faction = 'Nomads'
    },
}



-- Once player scouts the civilian city, add objective to capture one building
M1SecondaryObjective = {
    {
        text = '[Benson]: There appears to be a small civilian settlement south of your position. If we can capture one of their buildings and access their database, there might be some valuable intel we can gather on this area and what we\'re dealing with here.',
        vid = 'N03_M1SecondaryObjective_1.sfd', bank = 'N03_VO', cue = 'M1SecondaryObjective_1', faction = 'Nomads'
    },
    {
        text = '[Nichols]: We\'re sending you the location of the structure now, Captain. Capture that building.',
        vid = 'N03_M1SecondaryObjective_2.sfd', bank = 'N03_VO', cue = 'M1SecondaryObjective_2', faction = 'Nomads'
    },
}

-- When player captured the building
M1SecondaryDone = {
    {
        text = '[Benson]: Building is captured, sir. Let\'s see what we\'ve got.',
        vid = 'N03_M1SecondaryDone.sfd', bank = 'N03_VO', cue = 'M1SecondaryDone', faction = 'Nomads'
    },
}

-- When the civ building dies
M1SecondaryFailed = {
    {
        text = '[Benson]: We\'ve lost the energy readings from that building - looks like it\'s been destroyed, Captain. Data extraction is no longer viable.',
        vid = 'N03_M1SecondaryFailed.sfd', bank = 'N03_VO', cue = 'M1SecondaryFailed', faction = 'Nomads'
    },
}

-- Remind to capture the building
M1SecondaryReminder = {
    {
        text = '[Benson]: We\'re standing by to extract intel from that building, sir. Capture it now, or we\'re flying blind here.',
        vid = 'N03_M1SecondaryReminder.sfd', bank = 'N03_VO', cue = 'M1SecondaryReminder', faction = 'Nomads'
    },
}



-- Unlock T2 static shield
M1ShieldUnlock = {
    {
        text = '[Benson]: Captain, Tech 2 Shield Generator schematic is ready. Uploading  to your ACU now.',
        vid = 'N03_M1ShieldUnlock.sfd', bank = 'N03_VO', cue = 'M1ShieldUnlock', faction = 'Nomads'
    },
}

-- Bonus ojd done, construct shield over the ship
M1ShieldConstructed = {
    {
        text = '[Benson]: The Tech 2 shield should assist in protecting the ship.',
        vid = 'N03_M1ShieldConstructed.sfd', bank = 'N03_VO', cue = 'M1ShieldConstructed', faction = 'Nomads'
    },
}



-- Tell the player we're sending engineers
M1Enginners1 = {
    {
        text = '[Benson]: Engineers have been dispatched  to your location to investigate the damage to the ship. They\'ll arrive shortly, sir.',
        vid = 'N03_M1Enginners1.sfd', bank = 'N03_VO', cue = 'M1Enginners1', faction = 'Nomads'
    },
}

-- When the transports appear at the map
M1Enginners2 = {
    {
        text = '[Benson]: Transports are inbound, Captain. Keep an eye out for them; they\'ll be arriving in from the north.',
        vid = 'N03_M1Enginners2.sfd', bank = 'N03_VO', cue = 'M1Enginners2', faction = 'Nomads'
    },
}

-- Engineers start repairing the ship
M1Enginners3 = {
    {
        text = '[Benson]: Engineers are assessing the damage now. We can\'t say for certain, but the initial analysis is that it was shot down.',
        vid = 'N03_M1Enginners3.sfd', bank = 'N03_VO', cue = 'M1Enginners3', faction = 'Nomads'
    },
}

-- Few seconds after, assign objective to reclaim crystal
M1CrystalsObjective = {
    {
        text = '[Benson]: The damage is extensive, sir. It looks like several sections were either torn, or blown off when it was brought down. We don\'t have the materials onboard to make the necessary repairs, but scans of the area indicate that there are sections of the ship close by. I\'m sending you the coordinates now. Reclaim the marked sections.',
        vid = 'N03_M1CrystalsObjective.sfd', bank = 'N03_VO', cue = 'M1CrystalsObjective', faction = 'Nomads'
    },
}

-- Remind player to reclaim the crystals
CrystalsReminder1 = {
    {
        text = '[Nichols]: Sir, I don\'t mean to interrupt your little holiday, but our engineers are still waiting for you to reclaim those sections.',
        vid = 'N03_CrystalsReminder1.sfd', bank = 'N03_VO', cue = 'CrystalsReminder1', faction = 'Nomads'
    },
}

-- Remind player to reclaim the crystals
CrystalsReminder2 = {
    {
        text = '[Nichols]: Captain, a sense of urgency would be quite appropriate roundabout now. We need the materials for the repairs ASAP.',
        vid = 'N03_CrystalsReminder2.sfd', bank = 'N03_VO', cue = 'CrystalsReminder2', faction = 'Nomads'
    },
}

-- Remind player to reclaim the crystals
CrystalsReminder3 = {
    {
        text = '[Nichols]: You are cutting it very fine here, Captain. Reclaim those ship sections now!',
        vid = 'N03_CrystalsReminder3.sfd', bank = 'N03_VO', cue = 'CrystalsReminder3', faction = 'Nomads'
    },
}

-- When the first crystal is reclaimed
FirstCrystalReclaimed = {
    {
        text = '[Nichols]: Excellent, sir. The first section of the ship has been reclaimed.',
        vid = 'N03_FirstCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'FirstCrystalReclaimed_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: The engineers are  incorporating the materials now. Repairs to the ship are moving along nicely.',
        vid = 'N03_FirstCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'FirstCrystalReclaimed_2', faction = 'Nomads'
    },
}

-- Second crystal reclaimed, resource bonus, map expands to the second part
SecondCrystalReclaimed1 = {
    {
        text = '[Benson]: Captain, fabrication systems on the crashed ship are coming online. We can divert their resource generation to you now.',
        vid = 'N03_SecondCrystalReclaimed1_1.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed1_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: Our engineers are reporting that they\'ll  need more materials  to fully repair the ship. I\'m scanning the area for more sections now, sir.',
        vid = 'N03_SecondCrystalReclaimed1_2.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed1_2', faction = 'Nomads', delay = 5},
}

-- Second crystal reclaimed, resource bonus, map doesn't expand
SecondCrystalReclaimed2 = {
    {
        text = '[Benson]: Support systems are also now online, sir. Diverting more resources to you.',
        vid = 'N03_SecondCrystalReclaimed2.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed2', faction = 'Nomads'
    },
}



-- Warn player about incoming naval attack
M1AirAttack = {
    {
        text = '[Nichols]: Captain, we have intel on enemy air units incoming from the west.',
        vid = 'N03_M1AirAttack.sfd', bank = 'N03_VO', cue = 'M1AirAttack', faction = 'Nomads'
    },
}

-- Warn player about incoming land attack, Not used
-- M1LandAttack = {
--     {
--         text = '[Nichols]: Radar is picking up land units incoming from the west, Captain.',
--         vid = 'N03_M1LandAttack.sfd', bank = 'N03_VO', cue = 'M1LandAttack', faction = 'Nomads'
--     },
-- }

-- Warn player about incoming naval attack
M1NavalAttack = {
    {
        text = '[Nichols]: Our sonar is detecting enemy craft in the water, sir. They\'re approaching from the west.',
        vid = 'N03_M1NavalAttack.sfd', bank = 'N03_VO', cue = 'M1NavalAttack', faction = 'Nomads'
    },
}

-- Map expands by the timer, this dialogue is followed by cinematics intro of M2
M1MapExpansion = {
    {
        text = '[Benson]: Sir, my calculations are showing that we will need more materials to fully repair the ship. I\'m scanning the area for more ship sections now.',
        vid = 'N03_M1MapExpansion.sfd', bank = 'N03_VO', cue = 'M1MapExpansion', faction = 'Nomads', delay = 5},
}



-- Primary Objective
M1P1Title = 'Protect the crashed ship'
M1P1Description = 'Ensure that the crashed ship survives. Hostile forces will try to destroy it.'

-- Primary Objective
M1P2Title = 'Destroy the southern hostile base'
M1P2Description = 'Hostile forces are moving in from this position. Neutralise the enemy base to your south.'

-- Primary Objective
M1P3Title = 'Recover the sections of the downed ship'
M1P3Description = 'Reclaim the sections of the crashed ship in order to make the necessary repairs, and get its systems back online.'

-- Secondary Objective
M1S1Title = 'Capture the Enemy civilian centre'
M1S1Description = 'Capture the civilian building. We may be able to gather intel from itl.'

-- Bonus Objective
M1B1Title = 'Technology Study'
M1B1Description = 'You captured an enemy construction unit.'

-- Bonus Objective
M1B2Title = 'Bubble Protection'
M1B2Description = 'You constructed a T2 shield over the ship.'

-- Bonus Objective
M1B3Title = 'Full Build Power'
M1B3Description = 'All engineers repairing the ship survived.'



------------
-- Mission 2
------------
-- Look at the player's ACU
M2Intro1 = {
    {
        text = '[Benson]: Scanning complete. We\'ve found more ship sections near your location.',
        vid = 'N03_M2Intro1.sfd', bank = 'N03_VO', cue = 'M2Intro1', faction = 'Nomads'
    },
}

-- Move camera to the middle ship part
M2Intro2 = {
    {
        text = '[Benson]: There are 3 sizeable sections west of your position.',
        vid = 'N03_M2Intro2.sfd', bank = 'N03_VO', cue = 'M2Intro2', faction = 'Nomads'
    },
}

-- Look at the north Aeon base
M2Intro3 = {
    {
        text = '[Nichols]: Intel indicates that hostile activity is high in that area. If you don\'t deal with the operation there soon, they may launch a more severe attack and prevent us from getting to those sections. Don\'t let those bases develop any further, Captain.',
        vid = 'N03_M2Intro3.sfd', bank = 'N03_VO', cue = 'M2Intro3', faction = 'Nomads'
    },
}



-- Some extra talk, assign objective
M2PostIntro = {
    {
        text = '[Benson]: Sir, don\'t forget that the ship sections are the priority here. The faster we can get to them and reclaim the materials we need, the faster we can repair the ship and remove any evidence of Nomads activity.',
        vid = 'N03_M2PostIntro_1.sfd', bank = 'N03_VO', cue = 'M2PostIntro_1', faction = 'Nomads'
    },
    {
        text = '[Nichols]: Two more enemy bases detected north west and south west of your position, Captain. Don\'t hesitate to engage if they get in your way!',
        vid = 'N03_M2PostIntro_2.sfd', bank = 'N03_VO', cue = 'M2PostIntro_2', faction = 'Nomads'
    },
}



-- Third crystal is reclaimed
ThirdCrystalReclaimed = {
    {
        text = '[Nichols]: Another section reclaimed, sir. Keep up the good work.',
        vid = 'N03_ThirdCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'ThirdCrystalReclaimed_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: Our engineers are continuing with the repairs.',
        vid = 'N03_ThirdCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'ThirdCrystalReclaimed_2', faction = 'Nomads'
    },
}

-- Fourth crystal is reclaimed, arty satellite
FourthCrystalReclaimed = {
    {
        text = '[Benson]: The fourth section has been reclaimed. Tracking and targeting systems , are coming online again. Engineers are confirming orbital support satellite functionality is now available, sir.',
        vid = 'N03_FourthCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'FourthCrystalReclaimed_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: The satellite\'s long range weapons are active. Identify a target to launch an orbital strike.',
        vid = 'N03_FourthCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'FourthCrystalReclaimed_2', faction = 'Nomads'
    }, 
}

-- All 5 ship parts reclaimed, objective completed (map didnt expand yet)
AllCrystalReclaimed1 = {
    {
        text = '[Nichols]: All ship sections are now reclaimed, Captain. Well done.',
        vid = 'N03_AllCrystalReclaimed1_1.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_1', faction = 'UEF'},
    {
        text = '[Benson]: All ship systems are tested and operational, and fully capable of space flight, as well as FTL travel. We\'re clear to leave the planet, sir.',
        vid = 'N03_AllCrystalReclaimed1_2.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_2', faction = 'UEF'},
    {
        text = '[Nichols]: Captain, we\'ll need to deal with those orbital cannons first before we can go anywhere.',
        vid = 'N03_AllCrystalReclaimed1_3.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_3', faction = 'UEF'},
    {
        text = '[Nichols]: We\'re picking up a lot of enemy signatures incoming from the north-west. Regroup your units and defend the ship.',
        vid = 'N03_AllCrystalReclaimed1_4.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_4', faction = 'UEF'},
}


-- All 5 crystals reclaimed, objective completed (map has already expanded)
AllCrystalReclaimed2 = {
    {
        text = '[Nichols]: That\'s all of them, Captain. Excellent work out there.',
        vid = 'N03_AllCrystalReclaimed2_1.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed2_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: All systems are go, sir. Ready to leave on your command.',
        vid = 'N03_AllCrystalReclaimed2_2.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed2_2', faction = 'Nomads'
    },
}



-- One Aeon Bases destroyed
M2OneBaseDestroyed = {
    {
        text = '[Nichols]: Yes! First enemy base in the west has been destroyed.',
        vid = 'N03_M2OneBaseDestroyed.sfd', bank = 'N03_VO', cue = 'M2OneBaseDestroyed', faction = 'Nomads'
    },
}

-- Both Aeon Bases destroyed, secondary obj done
M2BasesDestroyed = {
    {
        text = '[Nichols]: That\'s two for two with those enemy bases in the west, Captain. Just what I like to see.',
        vid = 'N03_M2AeonBasesDestroyed.sfd', bank = 'N03_VO', cue = 'M2AeonBasesDestroyed', faction = 'Nomads'
    },
}



-- Unlock Rail Boat
M2RailBoatUnlock = {
    {
        text = '[Benson]: Sonar readings indicate that there are significant numbers of enemy submarines operating in the area. We\'ve developed a new type of naval craft to counter them. They should prove very efficient against these submarines.',
        vid = 'N03_M2RailBoatUnlock.sfd', bank = 'N03_VO', cue = 'M2RailBoatUnlock', faction = 'Nomads'
    },
}

-- Unlock T2 Arty
M2T2ArtyUnlock = {
    {
        text = '[Benson]: YUse T2 Static Artillery to defend your shores against those enemy Destroyers, sir. We\'re uploading the blueprint for you now.',
        vid = 'N03_M2T2ArtyUnlock.sfd', bank = 'N03_VO', cue = 'M2T2ArtyUnlock', faction = 'Nomads'
    },
}



-- Dialogue after 6 min
M2Dialogue = {
    {
        text = '[Benson]: We\'re detecting an increase in  enemy activity, Captain. You need to speed things up or our engineers won\'t get the repairs done before they launch another attack.',
        vid = 'N03_M2Dialogue.sfd', bank = 'N03_VO', cue = 'M2Dialogue', faction = 'Nomads'
    },
}

-- Before the enemy ACU is shown
M2ACUNIS1 = {
    {
        text = '[Benson]: Sir,  our scans are picking up an unusual energy reading  from the north.',
        vid = 'N03_M2ACUNIS1.sfd', bank = 'N03_VO', cue = 'M2ACUNIS1', faction = 'Nomads'
    },
}

-- Look at the ACU
M2ACUNIS2 = {
    {
        text = '[Nichols]: An enemy ACU just gated in! While this frozen rock could stand to be a bit warmer, I don\'t think this is the heat we\'re looking for right now. Move it, Captain.',
        vid = 'N03_M2ACUNIS2.sfd', bank = 'N03_VO', cue = 'M2ACUNIS2', faction = 'Nomads'
    },
}



-- Bonus obj done, engineer drop killed
M2EngieDropKilled = {
    {
        text = '[Nichols]: Enemy transport is down. Good catch, Captain.',
        vid = 'N03_M2EngieDropKilled.sfd', bank = 'N03_VO', cue = 'M2EngieDropKilled', faction = 'Nomads'
    },
}



-- Artillery gun ready again
ArtilleryGunReady = {
    {
        text = '[Nichols]: The artillery is online again, and ready to fire.',
        vid = 'N03_ArtilleryGunReady.sfd', bank = 'N03_VO', cue = 'ArtilleryGunReady', faction = 'Nomads'
    },
}



-- Warn player about attack coming form the north/main base
M2AttackWarning = {
    {
        text = '[Benson]: Captain, our radar is picking up a large number of enemy units coming in from the north.',
        vid = 'N03_M2AttackWarning.sfd', bank = 'N03_VO', cue = 'M2AttackWarning', faction = 'Nomads'
    },
}



-- Secondary Objective
M2S1Title = 'Destroy the Enemy bases to the west'
M2S1Description = 'Eliminate the enemy bases before they overwhelm your forces. Don\'t leave them unchecked for too long.'

-- Bonus Objective
M2B1Title = 'Kill T2 Subs'
M2B1Description = 'You\'ve sunk over %s enemy Submarine Hunters.'

-- Bonus Objective
M2B2Title = 'Supreme attention'
M2B2Description = 'You shot down a transport drop of enemy engineers before they could establish a base.'

-- Artillery Gun
ArtilleryGunTitle = 'Artillery strike'
ArtilleryGunDescription = 'Mark an area on the map for the orbital artillery strike. The strike will be available again after a short cooldown.'



------------
-- Mission 3
------------
-- 
M3Intro1 = {
    {
        text = '[Nichols]: There is a large increase in enemy activity to your north, Captain. Significant enemy forces inbound!',
        vid = 'N03_M3Intro1.sfd', bank = 'N03_VO', cue = 'M3Intro1', faction = 'Nomads'
    },
}

-- 
M3Intro2 = {
    {
        text = '[Nichols]: Defend your position and keep the ship alive!',
        vid = 'N03_M3Intro2.sfd', bank = 'N03_VO', cue = 'M3Intro2', faction = 'Nomads'
    },
}



-- All attacking units dead
M3PostIntro = {
    {
        text = '[Nichols]: Defeat the incoming units and protect the ship, commander.',
        vid = 'N03_M3PostIntro.sfd', bank = 'N03_VO', cue = 'M3PostIntro', faction = 'Nomads'
    },
}

-- All attacking units dead
M3CounterAttackDefeated = {
    {
        text = '[Nichols]: Enemy forces defeated. Proceed with the mission.',
        vid = 'N03_M3CounterAttackDefeated.sfd', bank = 'N03_VO', cue = 'M3CounterAttackDefeated', faction = 'Nomads'
    },
}



-- Obj to locate research buildings
M3LocateOrbitalCannons = {
    {
        text = '[Nichols]: Commander, you need to find the orbital cannons that shot down the ship. We will need to destroy they them before we can leave the planet',
        vid = 'N03_M3LocateOrbitalCannons.sfd', bank = 'N03_VO', cue = 'M3LocateOrbitalCannons', faction = 'Nomads'
    },
}

-- Player sees research buildings
M3OrbitalCannonSpotted = {
    {
        text = '[Nichols]: There\'s the orbital cannon that shot down the ship.',
        vid = 'N03_M3OrbitalCannonSpotted.sfd', bank = 'N03_VO', cue = 'M3OrbitalCannonSpotted', faction = 'Nomads'
    },
}

-- Remind player to locate the research buildings
M3LocateCannonsReminder = {
    {
        text = '[Nichols]: Commander, you need to locate the orbital cannons.',
        vid = 'N03_M3LocateCannonsReminder.sfd', bank = 'N03_VO', cue = 'M3LocateCannonsReminder', faction = 'Nomads'
    },
}



-- Just before map expands to the last part with more research buildings
M3MapExpansion = {
    {
        text = '[Nichols]: Sir, this isn\'t the only orbital cannon in the area. We\'re picking up more to the east.',
        vid = 'N03_M3MapExpansion.sfd', bank = 'N03_VO', cue = 'M3MapExpansion', faction = 'Nomads'
    },
}



-- Unlock RAS
M3RASUnlock = {
    {
        text = '[Benson]: Uploading blueprint for RAS.',
        vid = 'N03_M3RASUnlock.sfd', bank = 'N03_VO', cue = 'M3RASUnlock', faction = 'Nomads'
    },
}



-- Secondary obj, kill Aeon ACU
M3Secondary = {
    {
        text = '[Nichols]: The Aeon ACU is located in the island to your north west.',
        vid = 'N03_M3Secondary.sfd', bank = 'N03_VO', cue = 'M3Secondary', faction = 'Nomads'
    },
}

-- ACU killed, obj done, TODO: Add either scream when dying or something like "I will live on in the way" depending on the character we pick for the Aeon ACU
M3SecondaryDone = {
    {
        text = '[Aeon]: Smth.',
        vid = 'N03_M3SecondaryDone_1.sfd', bank = 'N03_VO', cue = 'M3SecondaryDone_1', faction = 'Aeon'
    },
    {
        text = '[Nichols]: The enemy ACU is gone. The base on the north west ceased all operations.',
        vid = 'N03_M3SecondaryDone_2.sfd', bank = 'N03_VO', cue = 'M3SecondaryDone_2', faction = 'Nomads'
    },
}



-- Primary Objective
M3P1Title = 'Survive Aeon Counter Attack'
M3P1Description = 'Aeon forces just launched a major attack at your position. Defeat all incoming units and continue with the operation.'

-- Primary Objective
M3P2Title = 'Locate orbital cannons'
M3P2Description = 'The orbital cannons need to be somewhere in this area. Send scouts to find them.'

-- Secondary Objective
M3S1Title = 'Defeat Aeon ACU'
M3S1Description = 'Eliminate the Aeon commander to secure the north west part of the operation area.'



------------
-- Mission 4
------------
-- Assign obj to kill research buildings
M4DestroyCannons = {
    {
        text = '[Nichols]: Sir, our scans revealed that there are 4 outposts with orbital cannons, you will have to destroy them all so we can leave this planet.',
        vid = 'N03_M4DestroyCannons_1.sfd', bank = 'N03_VO', cue = 'M4DestroyCannons_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: I\'ve marked the outposts\' location on the map for you sir.',
        vid = 'N03_M4DestroyCannons_2.sfd', bank = 'N03_VO', cue = 'M4DestroyCannons_2', faction = 'Nomads'
    },
}

-- First research location destroyed
M4OrbicalCannonDestroyed1 = {
    {
        text = '[Nichols]: First orbital cannon emplacement destroyed.',
        vid = 'N03_M4OrbicalCannonDestroyed1.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed1', faction = 'Nomads'
    },
}

-- Second research location destroyed
M4OrbicalCannonDestroyed2 = {
    {
        text = '[Nichols]: Another orbital cannon battery has been destroyed, keep up the good work sir.',
        vid = 'N03_M4OrbicalCannonDestroyed2.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed2', faction = 'Nomads'
    },
}

-- Third research location destroyed
M4OrbicalCannonDestroyed3 = {
    {
        text = '[Nichols]: Third orbital cannon emplacement is down, just one more to go.',
        vid = 'N03_M4OrbicalCannonDestroyed3.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed3', faction = 'Nomads'
    },
}

-- All research locations destroyed
M4OrbicalCannonDestroyed4 = {
    {
        text = '[Nichols]: That\'s all of them, good job sir.',
        vid = 'N03_M4OrbicalCannonDestroyed4.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed4', faction = 'Nomads'
    },
}

-- Reminder 1 to destroy the research building
M4OrbitalCannonsReminder1 = {
    {
        text = '[Nichols]: Sir, the orbital cannons are blocking us from escaping the planet, destroy them as soon as possible.',
        vid = 'N03_M4M4OrbitalCannonsReminder1.sfd', bank = 'N03_VO', cue = 'M4M4OrbitalCannonsReminder1', faction = 'Nomads'
    },
}

-- Reminder 2 to destroy the research building
M4OrbitalCannonsReminder2 = {
    {
        text = '[Nichols]: Sir, destroy the orbital cannons so we can leave this planet.',
        vid = 'N03_M4M4OrbitalCannonsReminder2.sfd', bank = 'N03_VO', cue = 'M4M4OrbitalCannonsReminder2', faction = 'Nomads'
    },
}



-- Assign Secondary objective to kill the tempest, spotted unfinished
M4TempestSpottedUnfinished = {
    {
        text = '[Nichols]: Sir, the Aeon commander is building a very large unit in the north east base. By the size it looks like it can deal huge amounts of damage. Destroy it as soon as you can.',
        vid = 'N03_M4TempestSpottedUnfinished.sfd', bank = 'N03_VO', cue = 'M4TempestSpottedUnfinished', faction = 'Nomads'
    },
}

-- Assign Secondary objective to kill the tempest, the tempest is finished already
M4TempestBuilt = {
    {
        text = '[Nichols]: Sir, we\'re detecting a very large unit closing to your base. Destroy it before it can deal significant damage.',
        vid = 'N03_M4TempestBuilt.sfd', bank = 'N03_VO', cue = 'M4TempestBuilt', faction = 'Nomads'
    },
}

-- Tempest killed after it ws completed, only secondary objective done
M4TempestKilled = {
    {
        text = '[Nichols]: The unit is destroyed, great job!',
        vid = 'N03_M4TempestKilled.sfd', bank = 'N03_VO', cue = 'M4TempestKilled', faction = 'Nomads'
    },
}

-- Tempest killed before completed, both bonus and secondary objective done
M4TempestKilledUnfinished = {
    {
        text = '[Nichols]: Good job sir, if the unit was completed it could be very dangerous.',
        vid = 'N03_M4TempestKilledUnfinished.sfd', bank = 'N03_VO', cue = 'M4TempestKilledUnfinished', faction = 'Nomads'
    },
}

-- Tempest 25% Completed
M4Tempest25PercentDone = {
    {
        text = '[Nichols]: Sir, the Aeon unit is 25% built.',
        vid = 'N03_M4Tempest25PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest25PercentDone', faction = 'Nomads'
    },
}

-- Tempest 50% Completed
M4Tempest50PercentDone = {
    {
        text = '[Nichols]: Sir, the Aeon unit is half way done.',
        vid = 'N03_M4Tempest50PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest50PercentDone', faction = 'Nomads'
    },
}

-- Tempest 75% Completed
M4Tempest75PercentDone = {
    {
        text = '[Nichols]: Sir, the Aeon unit is 75% built.',
        vid = 'N03_M4Tempest75PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest75PercentDone', faction = 'Nomads'
    },
}

-- Tempest 90% Completed
M4Tempest90PercentDone = {
    {
        text = '[Nichols]: Sir, the Aeon unit is almost finished, destroy it fast!',
        vid = 'N03_M4Tempest90PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest90PercentDone', faction = 'Nomads'
    },
}

-- Tempest 100% Completed
M4Tempest100PercentDone = {
    {
        text = '[Nichols]: Sir, the Aeon unit finished and it\'s moving towards your base, destroy it!',
        vid = 'N03_M4Tempest100PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest100PercentDone', faction = 'Nomads'
    },
}



-- TML/TMD Unlocked, warning about enemy TMLs
M4TechUnlock1 = {
    {
        text = '[Benson]: We\'re detecting enemy missile launchers in the area, get some missile defences online commander!',
        vid = 'N03_M4TechUnlock1.sfd', bank = 'N03_VO', cue = 'M4TechUnlock1', faction = 'Nomads'
    },
}

-- TML/TMD Unlocked, without warning
M4TechUnlock2 = {
    {
        text = '[Nichols]: The enemy base seems to be vulnerable to mid range cruise missiles.',
        vid = 'N03_M4TechUnlock2_1.sfd', bank = 'N03_VO', cue = 'M4TechUnlock2_1', faction = 'Nomads'
    },
    {
        text = '[Benson]: The Bowcaster can launch missiles with the required range in short succession. It is now available.',
        vid = 'N03_M4TechUnlock2_2.sfd', bank = 'N03_VO', cue = 'M4TechUnlock2_2', faction = 'Nomads'
    },
}

-- Field Engie Unlocked
M4FieldEngieUnlock = {
    {
        text = '[Benson]: The field engineer blueprint is now available. It can constuct tactical missile defences and is equipped with a light version of it as well.',
        vid = 'N03_M4FieldEngieUnlock.sfd', bank = 'N03_VO', cue = 'M4FieldEngieUnlock', faction = 'Nomads'
    },
}



-- Primary Objective
M4P1Title = 'Destroy all Aeon research buildings'
M4P1Description = 'Locate and destroy all Aeon research buildings.'

-- Secondary Objective
M4S1Title = 'Destroy Aeon Experimental Unit'
M4S1Description1 = 'The Aeon commander is building a large unit in the north east best. Make sure it won\'t stand in our way.'
M4S1Description2 = 'The Aeon commander has built a large unit and it\'s moving towards your base, destroy it before it can deal significant damage.'

-- Bonus Objective
M4B1Title = 'Swift Strike'
M4B1Description = 'You\'ve destroyed the Tempest before it was completed.'



---------
-- Taunts
---------

-- Aeon taunt
TAUNT1 = {
    {
        text = '[Aeon]: I will cleanse you.',
        vid = 'N03_TAUNT1.sfd', bank = 'N03_VO', cue = 'TAUNT1', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT2 = {
    {
        text = '[Aeon]: In the name of the princess, you will be destroyed!',
        vid = 'N03_TAUNT2.sfd', bank = 'N03_VO', cue = 'TAUNT2', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT3 = {
    {
        text = '[Aeon]: Your pathetic spaceship wont help you... my orbital cannons will blow it out of the orbit.',
        vid = 'N03_TAUNT3_1.sfd', bank = 'N03_VO', cue = 'TAUNT3_1', faction = 'Aeon'
    },
    {
        text = '[Nichols]: Sir, the Aeon started active radar scans of the upper atmosphere. Destroy him before he can track the ship!',
        vid = 'N03_TAUNT3_2.sfd', bank = 'N03_VO', cue = 'TAUNT3_2', faction = 'Nomads'
    },
}

-- Aeon taunt
TAUNT4 = {
    {
        text = '[Aeon]: Surrender now, the way will prevail despite of your efforts.',
        vid = 'N03_TAUNT4.sfd', bank = 'N03_VO', cue = 'TAUNT4', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT5 = {
    {
        text = '[Aeon]: You will be crushed by the forces of the Aeon Illuminate.',
        vid = 'N03_TAUNT5.sfd', bank = 'N03_VO', cue = 'TAUNT5', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT6 = {
    {
        text = '[Aeon]: Your futile attempts to resist the truth wont help you much longer.',
        vid = 'N03_TAUNT6.sfd', bank = 'N03_VO', cue = 'TAUNT6', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT7 = {
    {
        text = '[Aeon]: I figured that we had to hunt you down through the galaxy, but you will die here and now.',
        vid = 'N03_TAUNT7.sfd', bank = 'N03_VO', cue = 'TAUNT7', faction = 'Aeon'
    },
}
--[[
-- Aeon taunt
TAUNT = {
    {
        text = '[Aeon]: Much taunt here.',
        vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT = {
    {
        text = '[Aeon]: Much taunt here.',
        vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'
    },
}

-- Aeon taunt
TAUNT = {
    {
        text = '[Aeon]: Much taunt here.',
        vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'
    },
}
--]]

