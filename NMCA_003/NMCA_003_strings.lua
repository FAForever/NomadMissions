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

            Frist orbital cannon will be on the north island.

        Primary:
            Defend the Aeon counter attack.

            After a momnet another primary objective to locate the orbital cannons is assigned.

            When both counter attack and orbital cannon is located the map will expand to the last part.

        Secondary:
            Defeat the enemy ACU, once player scouts it.

        Unlocked Tech:
            RAS - 2 min into the mission

    Mission 4:
        Primary:
            Destroy 4 Orbital cannon bases.
            North one has a base with the tempest, South one is spawned depending on if the engineer drop in M2 was shot down or not.

        Secondary:
            Destroy the Tempest.
            There's a Tempest being built in the North Orbital base.

        Bonus:
            Destroy the Tempest before it's completed.

        Unlocked Tech:
            TMD/TML - 1 min into the mission
            Field Engineer - 7 min into the mission
    
    Outro:
        Cinematics at the ship leaving the planet.
--]]



OPERATION_NAME = 'Frosty Winds'
OPERATION_DESCRIPTION = 'Long range communications picked up an emergency signal from a nearby supply fleet that was on it\'s way to meet with your expedition group. Head to the coordinates the of the emergency signal and try to retrieve the ships and their crew. Don\'t let it fall into enemy hands, vital informations like the coordinates of the nomad home world may still be in the data core of the ship.' -- TODO: Proper mission description



-------------
-- Debriefing
-------------
-- Showed on the score screen if player wins
Debriefing_Win = {
    {text = 'You win', faction = 'UEF'},
}

-- Showed on the score screen if player loses
Debriefing_Lose = {
    {text = 'You lose', faction = 'UEF'},
}



-------------
-- Win / Lose
-------------
-- When the ship dies
ShipDestroyed = {
    {text = '[Benson]: The ships reactor is unstable, the cores shield is failing. It\'s going to explode!', vid = 'N03_ShipDestroyed_1.sfd', bank = 'N03_VO', cue = 'ShipDestroyed_1', faction = 'UEF'},
    {text = '[Nichols]: Sir, the ship has been destroyed, the mission has failed.', vid = 'N03_ShipDestroyed_2.sfd', bank = 'N03_VO', cue = 'ShipDestroyed_2', faction = 'UEF'},
}

-- Player dies (myself)
PlayerDies1 = {
    {text = '[Nichols]: The armor of the command unit is critical, get out of there! Oh no!', vid = 'N03_PlayerDies1.sfd', bank = 'N03_VO', cue = 'PlayerDies1', faction = 'UEF'},
}

-- Player dies (other player), using the same video for both to avoid desync, Not used
-- PlayerDies2 = {
--     {text = '[Nichols]: Reactor core of a deployed ground operative becomes critical. You\'re on your own now!', vid = 'N03_PlayerDies1.sfd', bank = 'N03_VO', cue = 'PlayerDies2', faction = 'UEF'},
-- }

-- 
PlayerWin1 = {
    {text = '[Nichols]: Area secured, all orbital cannons are offline.', vid = 'N03_PlayerWin1.sfd', bank = 'N03_VO', cue = 'PlayerWin1', faction = 'UEF'},
    {text = '[Benson]: All systems of the ship are functional, powering up the engines.', vid = 'N03_PlayerWin2.sfd', bank = 'N03_VO', cue = 'PlayerWin2', faction = 'UEF'},
    {text = '[Nichols]: The ship is ready to leave.', vid = 'N03_PlayerWin3.sfd', bank = 'N03_VO', cue = 'PlayerWin3', faction = 'UEF'},
}



------------
-- Mission 1
------------
-- Look at the Aeon base
M1Intro1 = {
    {text = '[Nichols]: We\'ve entered the atmosphere and are beginning our search for the crashed ship.', vid = 'N03_M1Intro1.sfd', bank = 'N03_VO', cue = 'M1Intro1', faction = 'UEF'},
    --{text = '[Nichols]: Recieving scrabled communications. We\'re not alone here. All stealth systems are working, we\'re undetected for now.', vid = 'N03_M1Intro1.sfd', bank = 'N03_VO', cue = 'M1Intro1', faction = 'UEF'},
}

-- Move cam to the crashed ship
M1Intro2 = {
    {text = '[Benson]: We\'re picking up the ship\'s beacon somewhere from this position.', vid = 'N03_M1Intro2.sfd', bank = 'N03_VO', cue = 'M1Intro2', faction = 'UEF'},
}

-- Spawn ACU and move cam to it
M1Intro3 = {
    {text = '[Nichols]: There\'s the ship. We have no time to waste! Sending you in, Commander.', vid = 'N03_M1Intro3.sfd', bank = 'N03_VO', cue = 'M1Intro3', faction = 'UEF'},
}



-- Assign primary objectives, protect ship, kill aeon base
M1PostIntro = {
    {text = '[Nichols]: Commander, there are unidentified units closing in on your position. Secure the area and defend the ship.', vid = 'N03_M1PostIntro_1.sfd', bank = 'N03_VO', cue = 'M1PostIntro_1', faction = 'UEF'},
    {text = '[Nichols]: Establish a base and send a platoon south to destroy the hostile base.', vid = 'N03_M1PostIntro_2.sfd', bank = 'N03_VO', cue = 'M1PostIntro_2', faction = 'UEF'},
}

-- Player kills the first Aeon base
M1AeonBaseDestroyed = {
    {text = '[Nichols]: The Aeon base has been destroyed, good job.', vid = 'N03_M1AeonBaseDestroyed.sfd', bank = 'N03_VO', cue = 'M1AeonBaseDestroyed', faction = 'UEF'},
}

-- Reminder #1 to kill Aeon base
M1AeonBaseReminder1 = {
    {text = '[Nichols]: The hostile\'s base is still a threat, destroy it.', vid = 'N03_M1AeonBaseReminder1.sfd', bank = 'N03_VO', cue = 'M1AeonBaseReminder1', faction = 'UEF'},
}

-- Reminder #2 to kill Aeon base
M1AeonBaseReminder2 = {
    {text = '[Nichols]: The base won\'t kill itself, Commander.', vid = 'N03_M1AeonBaseReminder2.sfd', bank = 'N03_VO', cue = 'M1AeonBaseReminder2', faction = 'UEF'},
}



-- When the ship gets damaged
M1ShipDamaged = {
    {text = '[Benson]: Commander, the ship is under attack! Protect it!', vid = 'N03_M1ShipDamaged.sfd', bank = 'N03_VO', cue = 'M1ShipDamaged', faction = 'UEF'},
}

-- When the ship drops to half HP
M1ShipHalfDead = {
    {text = '[Benson]: The ship is taking damage!', vid = 'N03_M1ShipHalfDead.sfd', bank = 'N03_VO', cue = 'M1ShipHalfDead', faction = 'UEF'},
}

-- When the ship is nearly destroyed
M1ShipAlmostDead = {
    {text = '[Benson]: The hull of the ship is in a critical state! It might explode if it takes further damage!', vid = 'N03_M1ShipAlmostDead.sfd', bank = 'N03_VO', cue = 'M1ShipAlmostDead', faction = 'UEF'},
}



-- Player captures Aeon construction unit
M1AeonUnitCaptured = {
    {text = '[Benson]: Good job capturing that unit sir! We can learn a lot by studying their technology.', vid = 'N03_M1AeonUnitCaptured.sfd', bank = 'N03_VO', cue = 'M1AeonUnitCaptured', faction = 'UEF'},
}



-- First Aeon units close the the player
M1AeonAttackWarning = {
    {text = '[Nichols]: It looks like your landing didn\'t go unnoticed. Hostile units are closing in on your position, get ready to fight!', vid = 'N03_M1AeonAttackWarning.sfd', bank = 'N03_VO', cue = 'M1AeonAttackWarning', faction = 'UEF'},
}



-- Player sees the dead UEF Base
M1UEFBaseDialogue = {
    {text = '[Nichols]: Those structures are definitely UEF. Looks like one hell of a fight took place. We need to be careful if those hostiles we encountered are the ones responsible for wiping that base out.', vid = 'N03_M1UEFBaseDialogue.sfd', bank = 'N03_VO', cue = 'M1UEFBaseDialogue', faction = 'UEF'},
}



-- Once player scouts the civilian city, add objective to capture one building
M1SecondaryObjective = {
    {text = '[Benson]: We\'ve located a small civilian settlement south of your position. We need to gather more intel on this area, so might be worth checking out.', vid = 'N03_M1SecondaryObjective_1.sfd', bank = 'N03_VO', cue = 'M1SecondaryObjective_1', faction = 'UEF'},
    {text = '[Nichols]: Capture the markred structure Commander.', vid = 'N03_M1SecondaryObjective_2.sfd', bank = 'N03_VO', cue = 'M1SecondaryObjective_2', faction = 'UEF'},
}

-- When player captured the building
M1SecondaryDone = {
    {text = '[Benson]: Building captured...', vid = 'N03_M1SecondaryDone.sfd', bank = 'N03_VO', cue = 'M1SecondaryDone', faction = 'UEF'},
}

-- When the civ building dies
M1SecondaryFailed = {
    {text = '[Benson]: The building has been destroyed. No measurable electromagnetic activity from the city anymore. We cant extract information from there now.', vid = 'N03_M1SecondaryFailed.sfd', bank = 'N03_VO', cue = 'M1SecondaryFailed', faction = 'UEF'},
}

-- Remind to capture the building
M1SecondaryReminder = {
    {text = '[Benson]: Capture the Aeon building to gather extra intel.', vid = 'N03_M1SecondaryReminder.sfd', bank = 'N03_VO', cue = 'M1SecondaryReminder', faction = 'UEF'},
}



-- Unlock T2 static shield
M1ShieldUnlock = {
    {text = '[Benson]: Commander, I\'ve uploaded the Tech 2 Shield Generator schematic into your ACU.', vid = 'N03_M1ShieldUnlock.sfd', bank = 'N03_VO', cue = 'M1ShieldUnlock', faction = 'UEF'},
}

-- Bonus ojd done, construct shield over the ship
M1ShieldConstructed = {
    {text = '[Benson]: The shield should make sure that the ship survives longer.', vid = 'N03_M1ShieldConstructed.sfd', bank = 'N03_VO', cue = 'M1ShieldConstructed', faction = 'UEF'},
}



-- Tell the player we're sending engineers
M1Enginners1 = {
    {text = '[Benson]: Commander, we\'re dispatching a group of engineers to your location to investigate the ship\'s damage. They\'ll arive shortly.', vid = 'N03_M1Enginners1.sfd', bank = 'N03_VO', cue = 'M1Enginners1', faction = 'UEF'},
}

-- When the transports appear at the map
M1Enginners2 = {
    {text = '[Benson]: The transports are inbound.', vid = 'N03_M1Enginners2.sfd', bank = 'N03_VO', cue = 'M1Enginners2', faction = 'UEF'},
}

-- Engineers start repairing the ship
M1Enginners3 = {
    {text = '[Benson]: Scanning the ship for damage.', vid = 'N03_M1Enginners3.sfd', bank = 'N03_VO', cue = 'M1Enginners3', faction = 'UEF'},
}

-- Few seconds after, assign objective to reclaim crystal
M1CrystalsObjective = {
    {text = '[Benson]: Ship is heavily damaged, to repair it we must obtain some Dilithium and Neutronium. We have located resource deposits of these materials close by. Reclaim the marked crystals.', vid = 'N03_M1CrystalsObjective.sfd', bank = 'N03_VO', cue = 'M1CrystalsObjective', faction = 'UEF'},
}

-- Remind player to reclaim the crystals
CrystalsReminder1 = {
    {text = '[Nichols]: Sir, the ship is still heavily damaged, the engineers are waiting for you to collect more resources.', vid = 'N03_CrystalsReminder1.sfd', bank = 'N03_VO', cue = 'CrystalsReminder1', faction = 'UEF'},
}

-- Remind player to reclaim the crystals
CrystalsReminder2 = {
    {text = '[Nichols]: Sir, we really need those crystals, reclaim them ASAP.', vid = 'N03_CrystalsReminder2.sfd', bank = 'N03_VO', cue = 'CrystalsReminder2', faction = 'UEF'},
}

-- Remind player to reclaim the crystals
CrystalsReminder3 = {
    {text = '[Nichols]: Sir, we really need those crystals, reclaim them ASAP.', vid = 'N03_CrystalsReminder3.sfd', bank = 'N03_VO', cue = 'CrystalsReminder3', faction = 'UEF'},
}

-- When the first crystal is reclaimed
FirstCrystalReclaimed = {
    {text = '[Nichols]: First crystal is reclaimed sir.', vid = 'N03_FirstCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'FirstCrystalReclaimed_1', faction = 'UEF'},
    {text = '[Benson]: We\'re incorporating the materials into the ship structure now.', vid = 'N03_FirstCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'FirstCrystalReclaimed_2', faction = 'UEF'},
}

-- Second crystal reclaimed, resource bonus, map expands to the second part
SecondCrystalReclaimed1 = {
    {text = '[Benson]: More systems on the ship are coming online sir. The ship is now able to produce more resources, they are transfered to you.', vid = 'N03_SecondCrystalReclaimed1_1.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed1_1', faction = 'UEF'},
    {text = '[Benson]: But we will need more minerals to fully repair the ship. I\'m scanning the area for more deposits.', vid = 'N03_SecondCrystalReclaimed1_2.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed1_2', faction = 'UEF', delay = 5},
}

-- Second crystal reclaimed, resource bonus, map doesn't expand
SecondCrystalReclaimed2 = {
    {text = '[Benson]: More systems on the ship are coming online sir. The ship is now able to produce more resources, they are transfered to you.', vid = 'N03_SecondCrystalReclaimed2.sfd', bank = 'N03_VO', cue = 'SecondCrystalReclaimed2', faction = 'UEF'},
}



-- Warn player about incoming naval attack
M1AirAttack = {
    {text = '[Nichols]: Commander, we\'re picking up air units incoming from the west.', vid = 'N03_M1AirAttack.sfd', bank = 'N03_VO', cue = 'M1AirAttack', faction = 'UEF'},
}

-- Warn player about incoming land attack, Not used
-- M1LandAttack = {
--     {text = '[Nichols]: Commander, we\'re picking up land units incoming from the west.', vid = 'N03_M1LandAttack.sfd', bank = 'N03_VO', cue = 'M1LandAttack', faction = 'UEF'},
-- }

-- Warn player about incoming naval attack
M1NavalAttack = {
    {text = '[Nichols]: Commander, we\'re picking up a group of naval units approaching from the west.', vid = 'N03_M1NavalAttack.sfd', bank = 'N03_VO', cue = 'M1NavalAttack', faction = 'UEF'},
}

-- Map expands by the timer, this dialogue is followed by cinematics intro of M2
M1MapExpansion = {
    {text = '[Benson]: Sir, my calculations are showing that we will need more minerals to fully repair the ship. I\'m scanning the area for more deposits.', vid = 'N03_M1MapExpansion.sfd', bank = 'N03_VO', cue = 'M1MapExpansion', faction = 'UEF', delay = 5},
}



-- Primary Objective
M1P1Title = 'Protect the crashed ship'
M1P1Description = 'Ensure that the crashed ship survives. The hostile forces will try to take it out.'

-- Primary Objective
M1P2Title = 'Destroy the southern hostile base'
M1P2Description = 'The enemy units are sending attacks from this position. Destroy the base.'

-- Primary Objective
M1P3Title = 'Collect resource deposits'
M1P3Description = 'Reclaim the resource rich crystals to obtain the Dilithium and Neutronium need to get the ships systems online again.'

-- Secondary Objective
M1S1Title = 'Capture the Aeon administrative centre'
M1S1Description = 'Capture the Aeon administrative centre to recieve additional intel.'

-- Bonus Objective
M1B1Title = 'Technology Study'
M1B1Description = 'You captured an Aeon construction unit.'

-- Bonus Objective
M1B2Title = 'Buble Protection'
M1B2Description = 'You constructed a T2 shield over the ship.'

-- Bonus Objective
M1B3Title = 'Full Build Power'
M1B3Description = 'All engineers repairing the ship survived.'



------------
-- Mission 2
------------
-- Look at the player's ACU
M2Intro1 = {
    {text = '[Benson]: The scan is complete. We\'ve found more crystal deposits around your position.', vid = 'N03_M2Intro1.sfd', bank = 'N03_VO', cue = 'M2Intro1', faction = 'UEF'},
}

-- Move camera to the middle crystal
M2Intro2 = {
    {text = '[Benson]: Start by going to the west. There are 3 additional crystals in this area that we need.', vid = 'N03_M2Intro2.sfd', bank = 'N03_VO', cue = 'M2Intro2', faction = 'UEF'},
}

-- Look at the north Aeon base
M2Intro3 = {
    {text = '[Nichols]: The Aeon activity is high here, that\'s why you\'ll start there. Don\'t let those bases develop too much to cause you problems.', vid = 'N03_M2Intro3.sfd', bank = 'N03_VO', cue = 'M2Intro3', faction = 'UEF'},
}



-- Some extra talk, assign objective
M2PostIntro = {
    {text = '[Benson]: Remember the crystals are the priority, get them as fast as you can so we can leave this planet.', vid = 'N03_M2PostIntro_1.sfd', bank = 'N03_VO', cue = 'M2PostIntro_1', faction = 'UEF'},
    {text = '[Nichols]: We\'re detecting two more enemy bases, one is to the north-west and the other to the south-west. If they get into your way, destroy them.', vid = 'N03_M2PostIntro_2.sfd', bank = 'N03_VO', cue = 'M2PostIntro_2', faction = 'UEF'},
}



-- Third crystal is reclaimed
ThirdCrystalReclaimed = {
    {text = '[Nichols]: Another crystal reclaimed, keep up the good work sir.', vid = 'N03_ThirdCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'ThirdCrystalReclaimed_1', faction = 'UEF'},
    {text = '[Benson]: The work on ship\'s hull and engines continues.', vid = 'N03_ThirdCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'ThirdCrystalReclaimed_2', faction = 'UEF'},
}

-- Fourth crystal is reclaimed, arty satellite
FourthCrystalReclaimed = {
    {text = '[Benson]: Fourth crystal reclaimed, the ballistic computers and target relays of the ship are coming online again. It can now control an orbital support statellite.', vid = 'N03_FourthCrystalReclaimed_1.sfd', bank = 'N03_VO', cue = 'FourthCrystalReclaimed_1', faction = 'UEF'},
    {text = '[Benson]: The satellite is equipped with long range weapons. Pinpoint a target to launch an orbital strike.', vid = 'N03_FourthCrystalReclaimed_2.sfd', bank = 'N03_VO', cue = 'FourthCrystalReclaimed_2', faction = 'UEF'},    
}

-- All 5 crystals reclaimed, objective completed (map didnt expand yet)
AllCrystalReclaimed1 = {
    {text = '[Nichols]: All mineral deposits are reclaimed, well done.', vid = 'N03_AllCrystalReclaimed1_1.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_1', faction = 'UEF'},
    {text = '[Benson]: The ship\'s systems are working and it\'s ready to leave the planet.', vid = 'N03_AllCrystalReclaimed1_2.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_2', faction = 'UEF'},
    {text = '[Nichols]: We will have to deal with the orbital cannons now so we can lea...', vid = 'N03_AllCrystalReclaimed1_3.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_3', faction = 'UEF'},
    {text = '[Nichols]: Sir, we\'re picking up a lot of enemy signatures incoming from the north-west. Regroup your units and defend the ship.', vid = 'N03_AllCrystalReclaimed1_4.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed1_4', faction = 'UEF'},
}

-- All 5 crystals reclaimed, objective completed (map has already expanded)
AllCrystalReclaimed2 = {
    {text = '[Nichols]: That\'s all of them, well done sir.', vid = 'N03_AllCrystalReclaimed2_1.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed2_1', faction = 'UEF'},
    {text = '[Benson]: All systems green, the ship is ready to leave the planet.', vid = 'N03_AllCrystalReclaimed2_2.sfd', bank = 'N03_VO', cue = 'AllCrystalReclaimed2_2', faction = 'UEF'},
}



-- One Aeon Bases destroyed
M2OneBaseDestroyed = {
    {text = '[Nichols]: First base on the west is destroyed.', vid = 'N03_M2OneBaseDestroyed.sfd', bank = 'N03_VO', cue = 'M2OneBaseDestroyed', faction = 'UEF'},
}

-- Both Aeon Bases destroyed, secondary obj done
M2BasesDestroyed = {
    {text = '[Nichols]: Thats both of the bases to the west.', vid = 'N03_M2AeonBasesDestroyed.sfd', bank = 'N03_VO', cue = 'M2AeonBasesDestroyed', faction = 'UEF'},
}



-- Unlock Rail Boat
M2RailBoatUnlock = {
    {text = '[Benson]: Sonar surveillance shows that the Aeon deploy significant submarine forces in the area, we\'ve developed a new boat for you to counter them: The Rail boat, it\'s great against these submarines.', vid = 'N03_M2RailBoatUnlock.sfd', bank = 'N03_VO', cue = 'M2RailBoatUnlock', faction = 'UEF'},
}

-- Unlock T2 Arty
M2T2ArtyUnlock = {
    {text = '[Benson]: You can use T2 Static Artillery to defend your shores against enemy Destroyers, we\'re uploading the blueprint into your ACU right now.', vid = 'N03_M2T2ArtyUnlock.sfd', bank = 'N03_VO', cue = 'M2T2ArtyUnlock', faction = 'UEF'},
}



-- Dialogue after 6 min
M2Dialogue = {
    {text = '[Benson]: We\'re detecting increasing enemy activity, we don\'t know what they are up to but you better hurry.', vid = 'N03_M2Dialogue.sfd', bank = 'N03_VO', cue = 'M2Dialogue', faction = 'UEF'},
}

-- Before the enemy ACU is shown
M2ACUNIS1 = {
    {text = '[Benson]: Commander, we\'re picking up some signal from the north.', vid = 'N03_M2ACUNIS1.sfd', bank = 'N03_VO', cue = 'M2ACUNIS1', faction = 'UEF'},
}

-- Look at the ACU
M2ACUNIS2 = {
    {text = '[Benson]: Enemy ACU just gated in. Hurry up before it gets ugly in here...', vid = 'N03_M2ACUNIS2.sfd', bank = 'N03_VO', cue = 'M2ACUNIS2', faction = 'UEF'},
}



-- Bonus obj done, engineer drop killed
M2EngieDropKilled = {
    {text = '[Nichols]: Enemy transport is down. Good catch commander.', vid = 'N03_M2EngieDropKilled.sfd', bank = 'N03_VO', cue = 'M2EngieDropKilled', faction = 'UEF'},
}



-- Artillery gun ready again
ArtilleryGunReady = {
    {text = '[Nichols]: Sir, the artillery is ready again.', vid = 'N03_ArtilleryGunReady.sfd', bank = 'N03_VO', cue = 'ArtilleryGunReady', faction = 'UEF'},
}



-- Warn player about attack coming form the north/main base
M2AttackWarning = {
    {text = '[Benson]: Massive attack incoming from the north...', vid = 'N03_M2AttackWarning.sfd', bank = 'N03_VO', cue = 'M2AttackWarning', faction = 'UEF'},
}



-- Secondary Objective
M2S1Title = 'Destroy the Aeon Bases to the west'
M2S1Description = 'Eliminate the enemy bases before they develop into a problem. Dont leave them unchecked for too long.'

-- Bonus Objective
M2B1Title = 'Kill T2 Subs'
M2B1Description = 'You\'ve sunk over %s enemy Submarine Hunters.'

-- Bonus Objective
M2B2Title = 'Supreme Attention'
M2B2Description = 'You\'ve shot down engineers drop before they could establish a base.'

-- Artillery Gun
ArtilleryGunTitle = 'Artillery Strike'
ArtilleryGunDescription = 'Mark an area for the orbital artillery strike. The strike will be available again after a short cooldown.'



------------
-- Mission 3
------------
-- 
M3Intro1 = {
    {text = '[Nichols]: Sir! There is high activity coming from the north. Significant forces are approaching.', vid = 'N03_M3Intro1.sfd', bank = 'N03_VO', cue = 'M3Intro1', faction = 'UEF'},
}

M3Intro2 = {
    {text = '[Nichols]: Defend your position and keep the ship alive!', vid = 'N03_M3Intro2.sfd', bank = 'N03_VO', cue = 'M3Intro2', faction = 'UEF'},  --TODO improve the text
}

M3PostIntro = {
    {text = '[Nichols]: Defeat the incoming units and protect the ship, commander.', vid = 'N03_M3PostIntro.sfd', bank = 'N03_VO', cue = 'M3PostIntro', faction = 'UEF'},
}

-- All attacking units dead
M3CounterAttackDefeated = {
    {text = '[Nichols]: Enemy forces defeated. Proceed with the mission.', vid = 'N03_M3CounterAttackDefeated.sfd', bank = 'N03_VO', cue = 'M3CounterAttackDefeated', faction = 'UEF'},
}



-- Obj to locate orbital cannons
M3LocateOrbitalCannons = {
    {text = '[Nichols]: Commander, you need to find the orbital cannons that shot down the ship. We will need to destroy they them before we can leave the planet', vid = 'N03_M3LocateOrbitalCannons.sfd', bank = 'N03_VO', cue = 'M3LocateOrbitalCannons', faction = 'UEF'},
}

-- Player sees orbital cannon
M3OrbitalCannonSpotted = {
    {text = '[Nichols]: There\'s the orbital cannon that shot down the ship.', vid = 'N03_M3OrbitalCannonSpotted.sfd', bank = 'N03_VO', cue = 'M3OrbitalCannonSpotted', faction = 'UEF'},
}

-- Remind player to locate the cannons
M3LocateCannonsReminder = {
    {text = '[Nichols]: Commander, you need to locate the orbital cannons.', vid = 'N03_M3LocateCannonsReminder.sfd', bank = 'N03_VO', cue = 'M3LocateCannonsReminder', faction = 'UEF'},
}



-- Just before map expands to the last part with more Orbital Cannons
M3MapExpansion = {
    {text = '[Nichols]: Sir, this isn\'t the only orbital cannon in the area. We\'re picking up more to the east.', vid = 'N03_M3MapExpansion.sfd', bank = 'N03_VO', cue = 'M3MapExpansion', faction = 'UEF'},
}



-- Unlock RAS
M3RASUnlock = {
    {text = '[Benson]: Uploading blueprint for RAS.', vid = 'N03_M3RASUnlock.sfd', bank = 'N03_VO', cue = 'M3RASUnlock', faction = 'UEF'},
}



-- Secondary obj, kill Aeon ACU
M3Secondary = {
    {text = '[Nichols]: The Aeon ACU is located in the island to your north west.', vid = 'N03_M3Secondary.sfd', bank = 'N03_VO', cue = 'M3Secondary', faction = 'UEF'},
}

-- ACU killed, obj done
M3SecondaryDone = {
    {text = '[Nichols]: The enemy ACU is gone. The base on the north west ceased all operations.', vid = 'N03_M3SecondaryDone.sfd', bank = 'N03_VO', cue = 'M3SecondaryDone', faction = 'UEF'},
}



-- Primary Objective
M3P1Title = 'Survive Aeon Counter Attack'
M3P1Description = 'Aeon forces just launched a major attack at your position. Defeat all incoming units and continue with the operation.'

-- Primary Objective
M3P2Title = 'Locate Orbital Cannons'
M3P2Description = 'The orbital cannons need to be someewhere in this area. Send scouts to find them.'

-- Secondary Objective
M3S1Title = 'Defeat Aeon ACU'
M3S1Description = 'Eliminate the Aeon commander to secure the north west part of the operation area.'



------------
-- Mission 4
------------
-- Assign obj to kill orbital cannons
M4DestroyCannons = {
    {text = '[Nichols]: Sir, our scans revealed that there are 4 outposts with orbital cannons, you will have to destroy them all so we can leave this planet.', vid = 'N03_M4DestroyCannons_1.sfd', bank = 'N03_VO', cue = 'M4DestroyCannons_1', faction = 'UEF'},
    {text = '[Benson]: I\'ve marked the outposts\' location on the map for you sir.', vid = 'N03_M4DestroyCannons_2.sfd', bank = 'N03_VO', cue = 'M4DestroyCannons_2', faction = 'UEF'},
}

-- First orbital cannon position destroyed
M4OrbicalCannonDestroyed1 = {
    {text = '[Nichols]: First orbital cannon emplacement destroyed.', vid = 'N03_M4OrbicalCannonDestroyed1.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed1', faction = 'UEF'},
}

-- Second orbital cannon position destroyed
M4OrbicalCannonDestroyed2 = {
    {text = '[Nichols]: Another orbital cannon battery has been destroyed, keep up the good work sir.', vid = 'N03_M4OrbicalCannonDestroyed2.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed2', faction = 'UEF'},
}

-- Third orbital cannon position destroyed
M4OrbicalCannonDestroyed3 = {
    {text = '[Nichols]: Third orbital cannon emplacement is down, just one more to go.', vid = 'N03_M4OrbicalCannonDestroyed3.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed3', faction = 'UEF'},
}

-- All orbital cannon positions destroyed
M4OrbicalCannonDestroyed4 = {
    {text = '[Nichols]: That\'s all of them, good job sir.', vid = 'N03_M4OrbicalCannonDestroyed4.sfd', bank = 'N03_VO', cue = 'M4OrbicalCannonDestroyed4', faction = 'UEF'},
}

-- Reminder 1 to destroy the cannons
M4OrbitalCannonsReminder1 = {
    {text = '[Nichols]: Sir, the orbital cannons are blocking us from escaping the planet, destroy them as soon as possible.', vid = 'N03_M4M4OrbitalCannonsReminder1.sfd', bank = 'N03_VO', cue = 'M4M4OrbitalCannonsReminder1', faction = 'UEF'},
}

-- Reminder 2 to destroy the cannons
M4OrbitalCannonsReminder2 = {
    {text = '[Nichols]: Sir, destroy the orbital cannons so we can leave this planet.', vid = 'N03_M4M4OrbitalCannonsReminder2.sfd', bank = 'N03_VO', cue = 'M4M4OrbitalCannonsReminder2', faction = 'UEF'},
}



-- Assign Secondary objective to kill the tempest, spotted unfinished
M4TempestSpottedUnfinished = {
    {text = '[Nichols]: Sir, the Aeon commander is building a very large unit in the north east base. By the size it looks like it can deal huge amounts of damage. Destroy it as soon as you can.', vid = 'N03_M4TempestSpottedUnfinished.sfd', bank = 'N03_VO', cue = 'M4TempestSpottedUnfinished', faction = 'UEF'},
}

-- Assign Secondary objective to kill the tempest, the tempest is finished already
M4TempestBuilt = {
    {text = '[Nichols]: Sir, we\'re detecting a very large unit closing to your base. Destroy it before it can deal significant damage.', vid = 'N03_M4TempestBuilt.sfd', bank = 'N03_VO', cue = 'M4TempestBuilt', faction = 'UEF'},
}

-- Tempest killed after it ws completed, only secondary objective done
M4TempestKilled = {
    {text = '[Nichols]: The unit is destroyed, great job!', vid = 'N03_M4TempestKilled.sfd', bank = 'N03_VO', cue = 'M4TempestKilled', faction = 'UEF'},
}

-- Tempest killed before completed, both bonus and secondary objective done
M4TempestKilledUnfinished = {
    {text = '[Nichols]: Good job sir, if the unit was completed it could be very dangerous.', vid = 'N03_M4TempestKilledUnfinished.sfd', bank = 'N03_VO', cue = 'M4TempestKilledUnfinished', faction = 'UEF'},
}

-- Tempest 25% Completed
M4Tempest25PercentDone = {
    {text = '[Nichols]: Sir, the Aeon unit is 25% built.', vid = 'N03_M4Tempest25PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest25PercentDone', faction = 'UEF'},
}

-- Tempest 50% Completed
M4Tempest50PercentDone = {
    {text = '[Nichols]: Sir, the Aeon unit is half way done.', vid = 'N03_M4Tempest50PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest50PercentDone', faction = 'UEF'},
}

-- Tempest 75% Completed
M4Tempest75PercentDone = {
    {text = '[Nichols]: Sir, the Aeon unit is 75% built.', vid = 'N03_M4Tempest75PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest75PercentDone', faction = 'UEF'},
}

-- Tempest 90% Completed
M4Tempest90PercentDone = {
    {text = '[Nichols]: Sir, the Aeon unit is almost finished, destroy it fast!', vid = 'N03_M4Tempest90PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest90PercentDone', faction = 'UEF'},
}

-- Tempest 100% Completed
M4Tempest100PercentDone = {
    {text = '[Nichols]: Sir, the Aeon unit finished and it\'s moving towards your base, destroy it!', vid = 'N03_M4Tempest100PercentDone.sfd', bank = 'N03_VO', cue = 'M4Tempest100PercentDone', faction = 'UEF'},
}




-- TML/TMD Unlocked, warning about enemy TMLs
M4TechUnlock1 = {
    {text = '[Benson]: We\'re detecting enemy missile launchers in the area, get some missile defences online commander!', vid = 'N03_M4TechUnlock1.sfd', bank = 'N03_VO', cue = 'M4TechUnlock1', faction = 'UEF'},
}

-- TML/TMD Unlocked, without warning
M4TechUnlock2 = {
    {text = '[Nichols]: The enemy base seems to be vulnerable to mid range cruise missiles.', vid = 'N03_M4TechUnlock2_1.sfd', bank = 'N03_VO', cue = 'M4TechUnlock2_1', faction = 'UEF'},
    {text = '[Benson]: The Bowcaster can launch missiles with the required range in short succession. It is now available.', vid = 'N03_M4TechUnlock2_2.sfd', bank = 'N03_VO', cue = 'M4TechUnlock2_2', faction = 'UEF'},
}

-- Field Engie Unlocked
M4FieldEngieUnlock = {
    {text = '[Benson]: The field engineer blueprint is now available. It can constuct tactical missile defences and is equipped with a light version of it as well.', vid = 'N03_M4FieldEngieUnlock.sfd', bank = 'N03_VO', cue = 'M4FieldEngieUnlock', faction = 'UEF'},
}



-- Primary Objective
M4P1Title = 'Destroy All Orbital Cannons'
M4P1Description = 'Locate and destroy all Aeon orbital cannons that are blocking us from escaping the planet.'

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
    {text = '[Aeon]: I will cleanse you.', vid = 'N03_TAUNT1.sfd', bank = 'N03_VO', cue = 'TAUNT1', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT2 = {
    {text = '[Aeon]: In the name of the princess, you will be destroyed!', vid = 'N03_TAUNT2.sfd', bank = 'N03_VO', cue = 'TAUNT2', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT3 = {
    {text = '[Aeon]: Your pathetic spaceship wont help you... my orbital cannons will blow it out of the orbit.', vid = 'N03_TAUNT3_1.sfd', bank = 'N03_VO', cue = 'TAUNT3_1', faction = 'Aeon'},
    {text = '[Nichols]: Sir, the Aeon started active radar scans of the upper atmosphere. Destroy him before he can track the ship!', vid = 'N03_TAUNT3_2.sfd', bank = 'N03_VO', cue = 'TAUNT3_2', faction = 'UEF'},
}

-- Aeon taunt
TAUNT4 = {
    {text = '[Aeon]: Surrender now, the way will prevail despite of your efforts.', vid = 'N03_TAUNT4.sfd', bank = 'N03_VO', cue = 'TAUNT4', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT5 = {
    {text = '[Aeon]: You will be crushed by the forces of the Aeon Illuminate.', vid = 'N03_TAUNT5.sfd', bank = 'N03_VO', cue = 'TAUNT5', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT6 = {
    {text = '[Aeon]: Your futile attempts to resist the truth wont help you much longer.', vid = 'N03_TAUNT6.sfd', bank = 'N03_VO', cue = 'TAUNT6', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT7 = {
    {text = '[Aeon]: I figured that we had to hunt you down through the galaxy, but you will die here and now.', vid = 'N03_TAUNT7.sfd', bank = 'N03_VO', cue = 'TAUNT7', faction = 'Aeon'},
}
--[[
-- Aeon taunt
TAUNT = {
    {text = '[Aeon]: Much taunt here.', vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT = {
    {text = '[Aeon]: Much taunt here.', vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'},
}

-- Aeon taunt
TAUNT = {
    {text = '[Aeon]: Much taunt here.', vid = 'N03_TAUNT.sfd', bank = 'N03_VO', cue = 'TAUNT', faction = 'Aeon'},
}
--]]

