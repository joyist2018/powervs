// survivorUpgrade.nut
//----------------------
// Keep track of bots and survivors

function ConstructSurvivorStats()
{
	foreach( mdl in SMdls )
	{
		local stat = clone SurvivorStats;
		
		stat.handle = Entities.FindByModel( null, mdl );
		stat.name = GetCharacterDisplayName( stat.handle );
		stat.isBot = IsPlayerABot( stat.handle );
		stat.id = stat.handle.GetPlayerUserId();
		
		//Say( stat.handle, "Adding " + stat.name + " id = " + stat.id.tostring() + " speed = " + stat.speed.tostring() + " isBot = " + stat.isBot.tostring(), false );
		switch( stat.name )
		{
			case "Coach": 		Survivors.Coach = stat;			break;
			case "Rochelle": 	Survivors.Rochelle = stat;		break;
			case "Ellis": 		Survivors.Ellis = stat;			break;
			case "Nick": 		Survivors.Nick = stat;			break;
		}
	}
}

function TransferStats()
{
	if( allow_transfers )
		foreach( mdl in SMdls )
		{
			local stat = clone SurvivorStats;
			
			stat.handle = Entities.FindByModel( null, mdl );
			stat.name = GetCharacterDisplayName( stat.handle );
			stat.isBot = IsPlayerABot( stat.handle );
			stat.id = stat.handle.GetPlayerUserId();
			
			//Say( stat.handle, "Transferring " + stat.name + "...", false );
			switch( stat.name )
			{
				case "Coach": 
							Survivors.Coach.handle = stat.handle;
							Survivors.Coach.isBot = stat.isBot;
							Survivors.Coach.id = stat.id;
							ResetSpeed( stat.handle, Survivors.Coach.speed );
							break;
				case "Rochelle": 	
							Survivors.Rochelle.handle = stat.handle;
							Survivors.Rochelle.isBot = stat.isBot;
							Survivors.Rochelle.id = stat.id;
							ResetSpeed( stat.handle, Survivors.Rochelle.speed );
							break;
				case "Ellis":
							Survivors.Ellis.handle = stat.handle;
							Survivors.Ellis.isBot = stat.isBot;
							Survivors.Ellis.id = stat.id;
							ResetSpeed( stat.handle, Survivors.Ellis.speed );
							break;
				case "Nick":
							Survivors.Nick.handle = stat.handle;
							Survivors.Nick.isBot = stat.isBot;
							Survivors.Nick.id = stat.id;
							ResetSpeed( stat.handle, Survivors.Nick.speed );
							break;
			}
		}
}

function DisplaySurvivorStats()
{
	if( allow_transfers )
		foreach( stat in Survivors )
			Say( stat.handle, "name = " + stat.name + " id = " + stat.id + " speed = " + stat.speed.tostring() + " isBot = " + stat.isBot.tostring(), false );
}

function OnGameEvent_pills_used( params )
{
	if( allow_transfers )
	{
		local user = GetPlayerFromUserID( params.subject );
		SetSpeed( user, 1.0 );
	}
}

function OnGameEvent_adrenaline_used( params )
{
	if( allow_transfers )
	{
		local user = GetPlayerFromUserID( params.userid );
		SetSpeed( user, 1.0 );
	}
}

// increases speed if addAmount is negative
function ChangeSpeed( survivor, addAmount )
{
	foreach( surv in Survivors )
		if( survivor == surv.handle )
		{
			local newSpeed = surv.speed + addAmount;
			if( newSpeed > 0 )
				surv.speed = newSpeed;
			else
				Say( null, "cannot increase speed farther", false );
			
			survivor.SetFriction( newSpeed );
			//Say( surv.handle, surv.name + " speed = " + surv.speed.tostring(), false );
		}
}

function SetSpeed( survivor, setAmount )
{
	foreach( surv in Survivors )
		if( survivor == surv.handle )
		{
			surv.speed = setAmount;
			survivor.SetFriction( surv.speed );
			//Say( surv.handle, surv.name + " speed = " + surv.speed.tostring(), false );
		}
}

function ResetSpeed( survivor, setAmount )
{
	survivor.SetFriction( setAmount );
	//Say( survivor, survivor.tostring() + " speed = " + GetFriction( survivor ).tostring(), false );
}

function OnGameEvent_player_bot_replace( params )
{
	TransferStats();
	//DisplaySurvivorStats();
}

function OnGameEvent_bot_player_replace( params )
{
	TransferStats();
	//DisplaySurvivorStats();
}

//function OnGameEvent_player_jump( params )
//{
//	local player = GetPlayerFromUserID( params.userid );
	//if( !IsPlayerABot( player ) )
		//DisarmClaw( player );
		//DisplaySurvivorStats();
//}

allow_transfers <- false;
function ClearSurvivors()
{
	foreach( surv in Survivors )
		surv.clear();
		
	allow_transfers = false;
}

function OnGameEvent_round_end( params )
{
	ClearSurvivors();
}

function OnGameEvent_mission_lost( params )
{
	ClearSurvivors();
}