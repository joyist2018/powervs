// dmgControl.nut
//---------------
// Base damage tables

/*
ScriptedDamageInfo <-
{
	Attacker = null              // handle of the entity that attacked
	Victim = null                // handle of the entity that was hit
	DamageDone = 0               // how much damage done
	DamageType = -1              // of what type
	Location = Vector(0,0,0)     // where
	Weapon = null                // by what - often Null (say if attacker was a common)
}
*/
function AllowTakeDamage( damageTable )
{	
	if( damageTable.Victim.IsPlayer() && damageTable.Attacker.IsPlayer() )
		if( damageTable.Victim.IsSurvivor() && !damageTable.Attacker.IsSurvivor() )
		{
			local zombieType = damageTable.Attacker.GetZombieType();
			switch( zombieType )
			{										
				case ZType.CHARGER :
								damageTable.DamageDone *= 0.8;
								return true;
										
				case ZType.SPITTER :
								// 263168 = spit, 128 = claw
								damageTable.DamageDone *= ( damageTable.DamageType == 263168 )
									? ((damageTable.Victim.IsIncapacitated())
										? ((IsPlayerABot(damageTable.Victim)) ? 2.0 : 1.0)
										: ((!IsPlayerABot(damageTable.Victim)) ? 0.75 : 1.5))
									: ((damageTable.Victim.IsIncapacitated()) ? 1.0 : 0.25);
								
								//Say( null, "dmgDone = " + damageTable.DamageDone.tostring(), false );
								return true;
								
				case ZType.TANK : 
								damageTable.DamageDone = 20.0;
								return true;
										
				default : return true;
			}
		}
	return true;
}

/*
Name: 	player_hurt
Structure: 	

short 	userid 			user ID who was hurt
short 	attacker 		user id who attacked
long 		attackerentid 	entity id who attacked, if attacker not a player, and userid therefore invalid
short 	health 			remaining health points
byte 		armor 			remaining armor points
string 	weapon 			weapon name attacker used, if not the world
short 	dmg_health 		damage done to health
byte 		dmg_armor 		damage done to armor
byte 		hitgroup 		hitgroup that was damaged
long 		type 				damage type 
*/
function OnGameEvent_player_hurt(params)
{
	local attacker = GetPlayerFromUserID( params.attacker );
	local victim = GetPlayerFromUserID( params.userid );

	if( attacker != null && victim != null )
		if( victim.IsPlayer() && attacker.IsPlayer() )
			if ( victim.IsSurvivor() && !attacker.IsSurvivor() )	
				switch( params.weapon )
				{
					case "boomer_claw":	  StaggerClaw( attacker, victim );					return;
					case "hunter_claw":	  HealingClaw( attacker, params.dmg_health );	return;
					case "charger_claw":	  CrippleClaw( victim );								return;
					case "spitter_claw":	  StaggerClaw( attacker, victim );					return;
					case "tank_claw":		  DisarmClaw( victim );									return;
					default:	return;
				}
}

// handle attacker, handle victim
function StaggerClaw( attacker, victim )
{
	foreach( surv in Survivors )
		if( victim == surv.handle && !surv.isGrabbed )
			victim.Stagger( attacker.GetOrigin() );
}

// handle attacker 
function HealingClaw( attacker, dmgDone )
{
	local newHealth = attacker.GetHealth() + dmgDone;
	attacker.SetHealth( newHealth );
}

function CrippleClaw( victim )
{
	ChangeSpeed( victim, 0.2 );
}

function DisarmClaw( victim )
{
	try
	{
		if( !victim.IsSurvivor() )
			return;
	
		local inventory = {};
		GetInvTable( victim, inventory );
		local currentWep = victim.GetActiveWeapon();
		local currentWepName = currentWep.GetClassname();
		
		local i_slots = 0;
		local switchIdx = "";
		if( currentWepName != "weapon_pistol" )
		{
			foreach( idx, slot in inventory )
			{
				//Say( null, idx.tostring() + ": " + slot.tostring(), false );
				
				if( slot == currentWep )
				{
					local switchWeapon = "";
					switchIdx = idx.tostring();
					switch( switchIdx )
					{
						case "slot0": switchWeapon = (currentWepName != "weapon_smg") 
											? "weapon_smg" 
											: "weapon_pumpshotgun"; 
											break;
											
						case "slot1": switchWeapon = "weapon_pistol"; 
											break;
											
						case "slot2": switchWeapon = (currentWepName != "weapon_pipe_bomb") 
											? "weapon_pipe_bomb" 
											: "weapon_molotov";
											break;
											
						case "slot4": switchWeapon = (currentWepName != "weapon_adrenaline") 
											? "weapon_adrenaline" 
											: "weapon_pain_pills";
											break;
											
						default: return;
					}
					victim.GiveItem( switchWeapon );
				}
				++i_slots;
			}
		
			GetInvTable( victim, inventory );
			local slotNum = "";
			foreach( idx, slot in inventory )
			{
				slotNum = idx.tostring();
				if( slotNum == switchIdx )
					if( slotNum != "slot1" )
					{
						//Say( null, "removing " + slot.tostring(), false );
						inventory[idx].Kill();
					}
			}
					
			if( i_slots != 0 )
				return;
		}
		throw no_wep;;
	}
	catch( no_wep )
	{
		//Say( null, "no more slots", false );
		return;
	}
}