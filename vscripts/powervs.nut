IncludeScript("mutationUpgrades.nut");

// Set up mutation options
MutationOptions <-
{	
	CommonLimit  = 28
	MegaMobSize  = 70
//	WanderingZombieDensityModifier = 0
	MaxSpecials  = 4 
//	TankLimit    = 1 
//	WitchLimit   = 1
	BoomerLimit  = 1 
	ChargerLimit = 1
	HunterLimit  = 2
	JockeyLimit  = 1
	SpitterLimit = 1
	SmokerLimit  = 2
	
//	cm_NoSurvivorBots = true 
	cm_TempHealthOnly = 1
	
	weaponsToConvert =
	{
		weapon_first_aid_kit = "weapon_pain_pills_spawn",
		weapon_defibrillator = "weapon_adrenaline_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}

	DefaultItems =
	[
		"weapon_pistol",
		"weapon_pain_pills",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
	
//	function ConvertZombieClass( iClass )
//	{
//		return 4;
//	}
	TempHealthDecayRate = 0.02
}

SMdls <-
{
	coach = "models/survivors/survivor_coach.mdl"
	ellis = "models/survivors/survivor_mechanic.mdl"
	nick = "models/survivors/survivor_gambler.mdl"
	rochelle = "models/survivors/survivor_producer.mdl"
}
Survivors <- 
{
	Coach = {},
	Rochelle = {},
	Ellis = {},
	Nick = {}
}
SurvivorStats <-
{
	id = 0,
	handle = null,
	name = "",
	speed = 1.0,
	isBot = false,
	isGrabbed = false
}

ZType <- 
{
	COMMON = 0,
	SMOKER = 1,
	BOOMER = 2,
	HUNTER = 3,
	SPITTER = 4,
	JOCKEY = 5,
	CHARGER = 6,
	WITCH = 7,	
	TANK = 8,
	SURVIVOR = 9,
	MOB = 10,
	WITCHBRIDE = 11,
	MUDMEN = 12
}

function OnGameplayStart()
{
	Convars.SetValue("sb_stop",1);
	//Say( null, "OnGameplayStart", false );
}

function OnGameEvent_versus_round_start( params )
{
	//Say( null, "versus_round_start", false );
	ConstructSurvivorStats();
	allow_transfers = true;
	//DisplaySurvivorStats();
	Convars.SetValue("sb_stop",0);
}