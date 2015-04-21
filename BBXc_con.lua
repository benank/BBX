--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("teleport")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;


function ScriptPostLoad()

human44 = nil
OnCharacterSpawn(function(character)
  if IsCharacterHuman(character) then
    human44 = GetCharacterUnit(character)
  end
end)

OnObjectKill(function(object,killer)
  if object ~= human44 then
    DeactivateObject(object)
  end
end)

MapHideCommandPosts()
		ForceHumansOntoTeam1()
		cp1 = CommandPost:New{name = "cp1"}
		conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
		conquest:AddCommandPost(cp1)
		AddAIGoal(2, "deathmatch", 1000)
		EnableSPHeroRules()
		
		------TELEPORTS-----------------
	x = 1
	
	AddDeathRegion("nope")
	destination = GetPathNodeDestination( "boss", x-1 )
	ActivateRegion( "boss" )
   bosstp = OnEnterRegion(
    function(region, character)
		if x == 1 then
			destination = GetPathNodeDestination( "boss", x-1 ) -- x-1 orig 0
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, destination)
		end
		if x == 2 then
			destination = GetPathNodeDestination( "boss", x-1 ) -- x-1 orig 0
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, destination)
		end
		if x == 3 then
			destination = GetPathNodeDestination( "boss", x-1 ) -- x-1 orig 0
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, destination)
		end
		if x == 4 then
			destination = GetPathNodeDestination( "boss", x-1 ) -- x-1 orig 0
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, destination)
		end
    end,
    "boss"
    )
	
	-----------------------------------------------create enemies
	boss1 = GetTeamMember(2,0)
	SelectCharacterClass(boss1,"cis_inf_rifleman")

	boss2 = GetTeamMember(2,1)
	SelectCharacterClass(boss2,"cis_inf_rifleman")

	boss3 = GetTeamMember(2,2)
	SelectCharacterClass(boss3,"cis_inf_rifleman")

	boss4 = GetTeamMember(2,3)
	SelectCharacterClass(boss4,"cis_inf_rifleman")

	boss5 = GetTeamMember(2,4)
	SelectCharacterClass(boss5,"cis_inf_engineer")

	player = GetTeamMember(1,0)
--------------------------------------------------create timers
	bosstimer = CreateTimer("bosstimer")
	SetTimerValue(bosstimer, 5)
	
	disktimer = CreateTimer("disktimer")
	SetTimerValue(disktimer, 300)
	
	model = 0
	DisableSmallMapMiniMap()
	checker = nil
	inChallenge = false ----------------------sees if they are doing a challenge
	hub = GetPathNodeDestination( "cp1_spawn",0)
	modeldes = GetPathNodeDestination( "model",0)
	dead = GetPathNodeDestination( "dead",0)
	des1 = GetPathNodeDestination( "evil",0)
	des2 = GetPathNodeDestination( "evil",1)
	des3 = GetPathNodeDestination( "evil",2)
	des4 = GetPathNodeDestination( "evil",3)
	des5 = GetPathNodeDestination( "evil",4)
	des6 = GetPathNodeDestination( "evil",5)
	des7 = GetPathNodeDestination( "evil",6)
	des8 = GetPathNodeDestination( "evil",7)
	
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
            	ReleaseCharacterSpawn(onfirstspawn)
				ShowObjectiveTextPopup("level.BBX.info")
				onfirstspawn = nil
            end
        end
        )
		-----------------CHARACTER CHANGER
		hp = 0
	changer = OnEnterRegion(
    function(region, character)
		--SetProperty(character, "CurHealth", 0)
		hp = GetObjectHealth(GetCharacterUnit(character))
		SetEntityMatrix(GetCharacterUnit(character), dead)
		KillObject(GetCharacterUnit(character))
		SelectCharacterClass(character,"cis_inf_sniper")
		SpawnCharacter(character, modeldes)
		SetProperty(character, "CurHealth", hp)
		--ShowMessageText("level.BBX.model")
    end,
    "model"
    )
	
	ActivateRegion( "model" )
	----------------check to see if the enemies or the player died
		checker = OnCharacterDeath(function(character, killer)
			if GetNumTeamMembersAlive(2) == 0 then
				if x == 1 then
					x = x + 1
					inChallenge = false
					player = GetCharacterUnit(killer)
					SetEntityMatrix(player, hub)
					ShowMessageText("level.BBX.complete")
					BroadcastVoiceOver("common_objComplete", 1)
				end
				if x == 3 then
					x = x + 1
					inChallenge = false
					player = GetCharacterUnit(killer)
					SetEntityMatrix(player, hub)
					ShowMessageText("level.BBX.complete")
					BroadcastVoiceOver("common_objComplete", 1)
				end
			end
			if GetNumTeamMembersAlive(1) == 0 then
				MissionDefeat(1)
			end
		end)
	
		--------------------------------start the countdown to the challenge when they enter the boss region
   boss = OnEnterRegion(
    function(region, character)
		ShowMessageText("level.BBX.started")
		if x == 1 then
			StartTimer(bosstimer)
			ShowTimer(bosstimer)
			InChallenge = true
			ShowObjectiveTextPopup("level.BBX.c1")
		end
		if x == 2 then
			StartTimer(disktimer)
			ShowTimer(disktimer)
			ActivateRegion("disk1r")
			ActivateRegion("disk2r")
			ActivateRegion("disk3r")
			ActivateRegion("disk4r")
			ActivateRegion("disk5r")
			ActivateRegion("disk6r")
			ActivateRegion("disk7r")
			ActivateRegion("disk8r")
			ActivateRegion("disk9r")
			ActivateRegion("disk10r")
			RespawnObject("disk1")
			RespawnObject("disk2")
			RespawnObject("disk3")
			RespawnObject("disk4")
			RespawnObject("disk5")
			RespawnObject("disk6")
			RespawnObject("disk7")
			RespawnObject("disk8")
			RespawnObject("disk9")
			RespawnObject("disk10")
			InChallenge = true
			ShowObjectiveTextPopup("level.BBX.c2")
		end
		if x == 3 then
			StartTimer(bosstimer)
			ShowTimer(bosstimer)
			InChallenge = true
			ShowObjectiveTextPopup("level.BBX.c1")
		end
		if x == 4 then
			ActivateRegion("race1")
			KillObject("race1c2")
			AttachEffectToObject(CreateEffect("racering"), "race1c")
			CreateEntity("rep_hover_fightertank", GetPathNodeDestination( "landv", 0 ) "v1")
			CreateEntity("rep_hover_barcspeeder", GetPathNodeDestination( "landv", 1 ) "v2")
			CreateEntity("cis_hover_aat", GetPathNodeDestination( "landv", 2 ) "v3")
			InChallenge = true
			ShowObjectiveTextPopup("level.BBX.c3")
		end
		
    end,
    "boss"
    )
	
	------------------------------------BEGIN THE FUN
	--first challenge stuff
	OnTimerElapse(
	  function(timer)
		if x == 1 then
			SpawnCharacter(boss1, des1)
			SpawnCharacter(boss2, des2)
			SpawnCharacter(boss3, des3)
			SpawnCharacter(boss4, des4)
			SpawnCharacter(boss5, des1)
			--Ambush(destination, 1, fromTeam, aiDamageThreshold)
			--SetObjectTeam(GetCharacterUnit(character),2)
			MapAddEntityMarker(GetCharacterUnit(boss1), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss2), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss3), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss4), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss5), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
		end
		if x == 3 then
			SelectCharacterClass(boss1,"cis_inf_officer")
			SelectCharacterClass(boss2,"cis_inf_officer")
			SelectCharacterClass(boss3,"cis_inf_sniper")
			SelectCharacterClass(boss4,"cis_inf_sniper")
			SelectCharacterClass(boss5,"cis_inf_sniper")
			SpawnCharacter(boss1, des7)
			SpawnCharacter(boss2, des8)
			SpawnCharacter(boss3, des6)
			SpawnCharacter(boss4, des6)
			SpawnCharacter(boss5, des6)
			MapAddEntityMarker(GetCharacterUnit(boss1), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss2), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss3), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss4), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
			MapAddEntityMarker(GetCharacterUnit(boss5), "hud_objective_icon1", 4.0, 1, "RED", true, true, true)
		end
		ShowTimer(nil)
		SetTimerValue(bosstimer, 5)
	  end,
	bosstimer
	)
	
	KillObject("disk1")
	KillObject("disk2")
	KillObject("disk3")
	KillObject("disk4")
	KillObject("disk5")
	KillObject("disk6")
	KillObject("disk7")
	KillObject("disk8")
	KillObject("disk9")
	KillObject("disk10")
	--second challenge stuff
	numdisks = 0
	OnTimerElapse(
	  function(timer)
		MissionDefeat(1)
		ShowTimer(nil)
		Destroytimer(timer)
	  end,
	disktimer
	)
	
	disk1p = OnEnterRegion(
    function(region, character)
		KillObject("disk1")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk1r")
    end,
    "disk1r"
    )
	disk2p = OnEnterRegion(
    function(region, character)
		KillObject("disk2")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk2r")
    end,
    "disk2r"
    )
	disk3p = OnEnterRegion(
    function(region, character)
		KillObject("disk3")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk3r")
    end,
    "disk3r"
    )
	disk4p = OnEnterRegion(
    function(region, character)
		KillObject("disk4")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk4r")
    end,
    "disk4r"
    )
	disk5p = OnEnterRegion(
    function(region, character)
		KillObject("disk5")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk5r")
    end,
    "disk5r"
    )
	disk6p = OnEnterRegion(
    function(region, character)
		KillObject("disk6")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk6r")
    end,
    "disk6r"
    )
	disk7p = OnEnterRegion(
    function(region, character)
		KillObject("disk7")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk7r")
    end,
    "disk7r"
    )
	disk8p = OnEnterRegion(
    function(region, character)
		KillObject("disk8")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk8r")
    end,
    "disk8r"
    )
	disk9p = OnEnterRegion(
    function(region, character)
		KillObject("disk9")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk9r")
    end,
    "disk9r"
    )
	disk10p = OnEnterRegion(
    function(region, character)
		KillObject("disk10")
		numdisks = numdisks + 1
		BroadcastVoiceOver("common_objComplete", 1)
		if numdisks == 1 then
			ShowMessageText("level.BBX.item1")
		end
		if numdisks == 2 then
			ShowMessageText("level.BBX.item2")
		end
		if numdisks == 3 then
			ShowMessageText("level.BBX.item3")
		end
		if numdisks == 4 then
			ShowMessageText("level.BBX.item4")
		end
		if numdisks == 5 then
			ShowMessageText("level.BBX.item5")
		end
		if numdisks == 6 then
			ShowMessageText("level.BBX.item6")
		end
		if numdisks == 7 then
			ShowMessageText("level.BBX.item7")
		end
		if numdisks == 8 then
			ShowMessageText("level.BBX.item8")
		end
		if numdisks == 9 then
			ShowMessageText("level.BBX.item9")
		end
		if numdisks == 10 then
			ShowMessageText("level.BBX.item10")
			player = GetCharacterUnit(character)
			SetEntityMatrix(player, hub)
			ShowMessageText("level.BBX.complete")
			InChallenge = false
			x = x + 1
			disktimer = nil
			Destroytimer(disktimer)
		end
		DeactivateRegion("disk10r")
    end,
    "disk10r"
    )
	---------------------------------------challenge 4
	
	race1r = OnEnterRegion(
    function(region, character)
		KillObject("race1c")
		AttachEffectToObject(CreateEffect("fireworks"), "race1c")
		BroadcastVoiceOver("common_objComplete", 1)
		DeactivateRegion("race1")
    end,
    "race1"
    )
	
 end


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
    
    ReadDataFile("dc:ingame.lvl")
    ReadDataFile("ingame.lvl")
    
   
    SetMaxFlyHeight(9999)
    SetMaxPlayerFlyHeight (9999)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	ReadDataFile("sound\\tat.lvl;tat2cw")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep3_jettrooper",
                             "rep_hover_fightertank",
                             "rep_hero_anakin",
                             "rep_hover_barcspeeder")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_droideka",
                             "cis_hero_darthmaul",
                             "cis_hover_aat")
                             
                                  
                             
	SetupTeams{
		rep = {
			team = REP,
			units = 10,
			reinforcements = -1,
			soldier  = { "rep_inf_ep3_rifleman",0, 0},
			sniper  = { "cis_inf_sniper",0, 0},
	        
		},
		cis = {
			team = CIS,
			units = 20,
			reinforcements = -1,
			soldier  = { "cis_inf_rifleman",9, 25},
			assault  = { "cis_inf_rocketeer",1, 4},
			engineer = { "cis_inf_engineer",1, 4},
			sniper   = { "cis_inf_sniper",1, 4},
			officer = {"cis_inf_officer",1, 4},
			special = { "cis_inf_droideka",1, 4},
		}
	}
     
   

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1700)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1300)
    SetMemoryPoolSize("SoldierAnimation", 500)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
    SetMemoryPoolSize("Music", 33)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:BBX\\BBX.lvl", "BBX_conquest")
    SetDenseEnvironment("false")




    --  Sound
    
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "cor_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 

    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    -- OpenAudioStream("sound\\cor.lvl",  "cor_objective_vo_slow")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

    SetAmbientMusic(REP, 1.0, "rep_yav_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_yav_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_yav_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_yav_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_yav_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_yav_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_yav_amb_victory")
    SetDefeatMusic (REP, "rep_yav_amb_defeat")
    SetVictoryMusic(CIS, "cis_yav_amb_victory")
    SetDefeatMusic (CIS, "cis_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    --SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    --SetSoundEffect("WeaponUnableSelect",      "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--OpeningSateliteShot
    AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);

    AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
    AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
    AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
    AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
    AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
    AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
    AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
    AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
    AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);
end

