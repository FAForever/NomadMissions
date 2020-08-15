
--M1

--Dropping into middle of warzone
M1_Intro_CDR_Dropped_Dialogue = {
    {text = "[Nichols]: [To Do] Looks like the drop was successful captain. Now we just need to..", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] holdup picking up enemy transmissions.", vid = '', bank = '', cue = '', faction = 'UEF'},
    }
--Cybran/UEF drama queens fighting it out
M1_Intro_Fight_Dialogue = {
    {text = '<LOC C03_M01_020_010>[{i Berry}]: I\'m going to take that town, Cybran, and there\'s nothing you can do about it.', vid = 'C03_Berry_M01_0426.sfd', bank = 'C03_VO', cue = 'C03_Berry_M01_0426', faction = 'UEF'},
    {text = '[Jerrax]: [To Do] I will never let you have them. This is our planet, you filth!', vid = '', bank = '', cue = '', faction = 'Cybran'},
}
-- Drama queens being Drama Queens
M1_Berry_Cybran_Interaction = {
    {text = '<LOC C03_M01_040_010>[{i Berry}]: I\'m not done with you, Cybran.', vid = 'C03_Berry_M01_0428.sfd', bank = 'C03_VO', cue = 'C03_Berry_M01_0428', faction = 'UEF'},
    {text = '[Jerrax]: Damn it another UEF commander? I\'ll take you both on!', vid = '', bank = '', cue = '', faction = 'Cybran'},
}

-- Readjustment of objectives/realization your sorrounded.
M1_Intro_CDR_Dropped_Dialogue_2 = {
    {text = "[Nichols]:[To Do] Looks like you dropped into the thick of it Captain. I would suggest giving that ACU a test drive.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] Clear out both UEF and Cybran forces in the Area, and we will go from there.", vid = '', bank = '', cue = '', faction = 'UEF'},
    }
--Explains testing firepower with added upgrade at end
M1_ACUTest_Dialogue_Start = {
    {text = "[Benson]:[To Do] Captain if you can test out the main weapon systems of the ACU, I might be able to create an upgrade for you.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Benson]:[To Do] Just destroy enough enemy units and i will collect the data.", vid = '', bank = '', cue = '', faction = 'UEF'},
    }
--tells player about upgrade
M1_ACUTest_Dialogue_Complete = {
    {text = "[Benson]:[To Do] With the data collected from the weapons test, we found a way to increase your firepower. Just need to upgrade the weapon. Give it a try.", vid = '', bank = '', cue = '', faction = 'UEF'},
    
    }
-- Some units to help the Naval problem and explains why
M1_ReinforcementsCalled = {
    {text = "[Nichols]: [To Do] Captain, we have another Nomad commander onplanet. She has her own assigment, but will be able to offer some reinforcements periodicly.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] For right now, Shes able to spare some naval units, should help clear out that island. Try not to waste them.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] You are also recieve blueprints for T2 hovertanks, should help take the island as well.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

--M1 offmap attack

-- hey dude look out big attack coming
M1_OffMapAttack_Dialogue_Start = {
    {text = "[Nichols]:[To Do] Captain we are reading several attack groups heading your way.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] looks like UEF is coming from the North and Cybran forces aproaching from the East.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] Hold your ground Captain.", vid = '', bank = '', cue = '', faction = 'UEF'},
   }

-- wow dude that attack almost killed you, better not do that again
M1_OffMapAttack_Dialogue_End = {
    {text = "[Nichols]:[To Do] Good job Captain, looks like the enemy is back against eachother again.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] We can not afford to attack and agravate both of these Commanders at the same time. That attack nearly crushed you.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] You/'re going to have to focus down one of the Enemies, maybe we can influnce the battle in our favor.", vid = '', bank = '', cue = '', faction = 'UEF'},
   }

--M2

-- UEF and Cybran are backhanding eachother across the battlefield
M2_P2_Cutscene_Intro = {
    {text = "[Nichols]:[To Do] Looks like both Commanders have a sizable presence in the Region.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] The UEF has a Naval base on the fringe of his operations, that may be exploitable.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] The Cybran is attempting to defend a Civilian City to the East, its cut off from his mainforces.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]:[To Do] Killing Civilians is not my favorite option, but it could cause the Cybran to lashout recklessly.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2_P2_Cutscene_Dialogue = {
    {text = '[Nichols]:[To Do] Our analysts are determining weakeness with potential expoits for both Cybran and UEF positions.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] However, your going to have to chose who\'s the greater threat. UEF or Cybran?', vid = '', bank = '', cue = '', faction = 'UEF'},
    
    }

M2_P2_ChoiceUEFProgress = {
    {text = '[Nichols]:[To Do] Good choice Captain, The UEF Commander has two Bases in the area.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] We believe if you target and destroy his frontline naval base, he will lack a secure flank to protect any assault he may launch.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] We also have several secondary targets on Cybran poistions that may lure the UEF into wasting resources on attacks.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] However, we must be quick, while we focus the UEF, the Cybran commander will be strenghting his position.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2_P2_ChoiceCybranProgress = {
    {text = '[Nichols]:[To Do] Wise desision Captain, The Cybran commander is trying to protect a City to the East.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] If the City is attack, we expect the Cybran commander to recklessly attmept to save it.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] weakness with UEF defenses may give the Cybran windows of Attack further weakening his forces.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] However, we must be quick, while we focus the Cybran, the UEF commander will be strenghting his position.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2ChoiceReminder = {
    {text = '[Nichols]:[To Do] Make a decision Captain or Fleet Command will make one for you.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2ForceChoice = {
    {text = '[Nichols]:[To Do] You took to long, Fleet Command wants us to go after the Cybran. He\'s trying to defeat a city to the east.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] If the city is attack, we expect the Cybran commander to recklessly attmept to save it.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] weakness with UEF defenses may give the Cybran windows of Attack further weakening his forces.', vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = '[Nichols]:[To Do] However, we must be quick, while we focus the Cybran, the UEF commander will be strenghting his position.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

-- Secondary Objectives Endings for UEF choice
M2_P2_SecondaryObjUEF1 = {

{text = '[Nichols]:[To Do]  With the stealth field down, the UEF commander seems to be reacting to the base\'s presence. A large air group is being diverted to destroy it.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2_P2_SecondaryObjUEF2 = {

{text = '[Nichols]:[To Do]  Great work With the outer City defenses. We are already detecting a large UEF land force moving into to finish the job.', vid = '', bank = '', cue = '', faction = 'UEF'},
}
-- Secondary Objectives Endings for Cybran choice
M2_P2_SecondaryObjCybran1 = {

{text = '[Nichols]: [To Do]  The Cybran is already sending a fleet with the torpedo defenses down around the UEF base.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2_P2_SecondaryObjCybran2 = {

{text = '[Nichols]: [To Do]  Most of the Flak defenses are destroyed. The door is wide open for the Cybran to launch an attack on that UEF base, all we need do is wait.', vid = '', bank = '', cue = '', faction = 'UEF'},
}

-- M2 reinforcements

M2_IntroReinforcements = {
    {text = "[Nichols]: [To Do] Captain, our ally in the east has freed up some advance units to support you. She will be able to send some more destroyers every few minutes. ", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Benson]: [To Do] Captain I have managed to covert some of our stronger space drones into Atmopshere fighters and Gunships. Both of them have several functions and will make up the backbone of your T2 air force, along with some new land units and structures.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M2_ReinforcementsCalled = {
    {text = "[Benson]: [To Do]  Reinforcements are inbound.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

--M3

M3_IntroUEF_Dialogue = {
    {text = "[Nichols]: [To Do] The UEF commander has taken advantage of the Cybran\'s assault.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Several of the Cybran positions have been wiped and the Cybran is on the back foot.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] However, the UEF commander is now turning his attention on you Captain.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M3_IntroCybran_Dialogue = {
    {text = "[Nichols]: [To Do] The Cybran commander has taken advantage of the UEF\'s assault.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Several of the UEF positions have been wiped and the UEF is on the back foot.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] However, the Cybran commander is now turning his attention on you Captain.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M3_Intro_Dialogue2 = {
    {text = "[Nichols]: [To Do] Defeat both enemy commanders to secure this planet.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Once your objectives are complete we can prepare for addtional strikes on Cybran targets.", vid = '', bank = '', cue = '', faction = 'UEF'},

}

M3_Assault_DialogueCybran = {
    {text = "[Nichols]: [To Do] We seem to have done it, Captain. A massive Cybran force is on it way to your location.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] The UEF commander is already reacting and sending forces to abuse the gaps in the Cybran's defenses.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Defeat the Cybran assault.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M3_Assault_DialogueUEF = {
    {text = "[Nichols]: [To Do] We seem to have done it, Captain. A massive UEF force is on it way to your location.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] The Cybran commander is already reacting and sending forces to abuse the gaps in the UEF\'s defenses.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Defeat the UEF assault.", vid = '', bank = '', cue = '', faction = 'UEF'},

}

M3_Assault_DialogueEnd = {
    {text = "[Nichols]: [To Do] Good work the assault is over.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

--No more Reinforcements Sad face :(

M3_TechIntel = {
    {text = "[Benson]: [To Do] Captain, you are receving your last patch of Reinforcements from our allied Commander, however you now have access to their blueprints. Construct them at your discresion.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

--Listening post Obj

M3_ListeningPost= {
    {text = "[Nichols]: [To Do] Captain, There\'s some sort of Nomad listening post to the north.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] looks like another Fleet has been spying on our two combatants here, Fleet Commands going to have a field day over this.", vid = '', bank = '', cue = '', faction = 'UEF'},
    {text = "[Nichols]: [To Do] Either Destroy it or capture it. Fleet command will handle the fallout.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M3_ListeningPostEnd = {
    {text = "[Nichols]: [To Do] Good work Captain, looks like [Fleet A] was behind that listening post. Fleet commands going to have a blast with them over that.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

M3_UEFDeath = {
{text = '<LOC C03_M03_050_010>[{i Berry}]: No, I can\'t aaaaaaaaaargh!', vid = 'C03_Berry_M03_0457.sfd', bank = 'C03_VO', cue = 'C03_Berry_M03_0457', faction = 'UEF'},
}

M3_CybranDeath = {
    {text = '[Jerrax]: But.. but I had every advantage!!', vid = '', bank = '', cue = '', faction = 'Cybran'},
}

M3_Victory = {
    {text = "[Nichols]: [To Do] Good work Captain, all your objectives have been completed.", vid = '', bank = '', cue = '', faction = 'UEF'},
}

PlayerDies1 = {
    {text = "[Nichols]: [To Do] Captain! Captain do you read me?!.", vid = '', bank = '', cue = '', faction = 'UEF'},
}


-- M1 Berry Misc Taunts
TAUNT1 = {
    {text = '<LOC C03_T01_040_010>[{i Berry}]: You will die on this day.', vid = 'C03_Berry_T01_0420.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0420', faction = 'UEF'},
}

TAUNT2 = {
    {text = '<LOC C03_T01_050_010>[{i Berry}]: There is no stopping us. We will restore the Empire.', vid = 'C03_Berry_T01_0421.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0421', faction = 'UEF'},
}

TAUNT3 = {
    {text = '<LOC C03_T01_070_010>[{i Berry}]: You cannot defeat me!', vid = 'C03_Berry_T01_0423.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0423', faction = 'UEF'},
}

TAUNT4 = {
    {text = '<LOC C03_T01_060_010>[{i Berry}]: I think you underestimate me.', vid = 'C03_Berry_T01_0422.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0422', faction = 'UEF'},
}

TAUNT5 = {
    {text = '<LOC C03_T01_080_010>[{i Berry}]: The UEF will bring order to the galaxy.', vid = 'C03_Berry_T01_0424.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0424', faction = 'UEF'},
}

TAUNT6 = {
    {text = '<LOC C03_T01_020_010>[{i Berry}]: It is time to pay for your crimes against humanity.', vid = 'C03_Berry_T01_0418.sfd', bank = 'C03_VO', cue = 'C03_Berry_T01_0418', faction = 'UEF'},
}


M2ChoiceTitle = 'Who do you want to focus on first?'
M2ChoiceKill = 'Cybran'
M2ChoiceCapture = 'UEF'