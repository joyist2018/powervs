// SItracking.nut
//------------------------
// Keep track of special infected

function ToggleStaggerClaw( victimID, state )
{
	if( allow_transfers )	
		foreach( surv in Survivors )
			if( victimID == surv.id )
				surv.isGrabbed = (state == "on") ? false : true;
}

function OnGameEvent_lunge_pounce( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "off" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ lunge_pounce", false );
		return;
	}
}

function OnGameEvent_pounce_end( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "on" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ pounce_end", false );
		return;
	}
}
// OnGameEvent
function OnGameEvent_tongue_grab( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "off" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ tongue_grab", false );
		return;
	}
}

function OnGameEvent_tongue_release( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "on" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ tongue_release", false );
		return;
	}
}

function OnGameEvent_charger_pummel_start( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "off" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ charger_pummel_start", false );
		return;
	}
}

function OnGameEvent_charger_pummel_end( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "on" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ charger_pummel_end", false );
		return;
	}
}

function OnGameEvent_jockey_ride( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "off" );
		
		local victim = GetPlayerFromUserID( params.victim );
		DisarmClaw( victim );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ jockey_ride", false );
		return;
	}
}

function OnGameEvent_jockey_ride_end( params )
{
	try
	{
		ToggleStaggerClaw( params.victim, "on" );
		return;
		
		throw e;
	}
	catch( e )
	{
		//Say( null, "exception @ jockey_ride_end", false );
		return;
	}
}