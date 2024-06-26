// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_player_movement()
{
	player_mspd = player[id_player_data_mspd];
	
	#region TIMERS
	if (player_runstop_timer > 0)
	{
		player_runstop_timer = max(player_runstop_timer - 1,0);
	}
	if (player_roll_timer > 0)
	{
		player_roll_timer = max(player_roll_timer - 1,0);
	}
	if (player_attack_timer > 0)
	{
		player_attack_timer = max(player_attack_timer - 1,0);
		if (player_attack_timer == 0)
		{
			player_attack_performing = 0;
		}
	}
	if (player_attack_timer == 0 && player_attack_punish_timer > 0)
	{
		player_attack_punish_timer = max(player_attack_punish_timer - 1,0);
	}
	#endregion
	
	#region STATUS
	var _stopping = false;
	if (player_runstop_timer > 0) {_stopping = true; }
	var _rolling = false;
	if (player_roll_timer > 0) { _rolling = true; player_mspd *= 0.5; }
	var _attacking = false;
	if (player_attack_timer > 0) { _attacking = true; player_mspd *= 0.25; }
	var _walking = false; var _running = false;
	if (_attacking == false && _rolling == false)
	{
		if (key_stick_tilt_run == false) { player_mspd *= 0.5; _walking = true; }
		else { _running = true; }
	}
	#endregion
	
	#region ACTION
	////ROLLING
	var _hmove = false;
	// Horizontal movement
	if (key[id_key_left])
	{
	    _hmove = true;
	    player[id_player_data_hsp] = max(player[id_player_data_hsp] - player[id_player_data_acel], -player_mspd);
	}
	else if (key[id_key_right])
	{
	    _hmove = true;
	    player[id_player_data_hsp] = min(player[id_player_data_hsp] + player[id_player_data_acel], player_mspd);
	}
	var _vmove = false;
	// Vertical movement
	if (key[id_key_up])
	{
	    _vmove = true;
	    player[id_player_data_vsp] = max(player[id_player_data_vsp] - player[id_player_data_acel], -player_mspd);
	}
	else if (key[id_key_down])
	{
	    _vmove = true;
	    player[id_player_data_vsp] = min(player[id_player_data_vsp] + player[id_player_data_acel], player_mspd);
	}
	
	var _friction = false;
	// Apply friction if not moving
	if (!_hmove)
	{
	    // Horizontal friction
	    if (player[id_player_data_hsp] > 0) 
	    {
	        player[id_player_data_hsp] = max(player[id_player_data_hsp] - player[id_player_data_friction], 0);
			_friction = true;
	    }
	    else if (player[id_player_data_hsp] < 0) 
	    {
	        player[id_player_data_hsp] = min(player[id_player_data_hsp] + player[id_player_data_friction], 0);
			_friction = true;
	    }
	}
	
	if (!_vmove)
	{
	    if (player[id_player_data_vsp] > 0) 
	    {
	        player[id_player_data_vsp] = max(player[id_player_data_vsp] - player[id_player_data_friction], 0);
			_friction = true;
	    }
	    else if (player[id_player_data_vsp] < 0) 
	    {
	        player[id_player_data_vsp] = min(player[id_player_data_vsp] + player[id_player_data_friction], 0);
			_friction = true;
	    }
	}
	
	var _magni = sqrt(player[id_player_data_hsp] * player[id_player_data_hsp] + player[id_player_data_vsp] * player[id_player_data_vsp]);
    if (_magni > player[id_player_data_mspd])
    {
        var _factor = player[id_player_data_mspd] / _magni;
        player[id_player_data_hsp] *= _factor;
        player[id_player_data_vsp] *= _factor;
    }
	
	///STOPPING
	if (_rolling == false && _attacking == false && _vmove == false && _hmove == false && (player[id_player_data_hsp] != 0 || player[id_player_data_vsp] != 0) && player_runstop_timer == 0) 
	{ 
		if (player_previous_movestate == 1)
		{
			player_runstop_timer = player[id_player_data_runstop_timer];
			obj_player.image_index = 0;
			var _runstop_sounds = ctl.player[id_player_data_snds_runstop];
			audio_play_sound(_runstop_sounds[irandom(array_length(_runstop_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
			show_debug_message("RUNSTOP")
		}
	}
	
	if (_rolling == false && _attacking == false && key[id_key_interact] == true)
	{
		player_roll_timer = player[id_player_data_roll_duration];
		obj_player.image_index = 0;
		scr_combat_force(0,obj_player,3,player[id_player_data_dir],player[id_player_data_friction]);
		var _roll_sounds = ctl.player[id_player_data_snds_roll];
		audio_play_sound(_roll_sounds[irandom(array_length(_roll_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
		show_debug_message("Roll")
	}
	if ( _rolling == false && key[id_key_assign] == true && player_attack_punish_timer == 0) 
	{
		 var _perform = false;
		 if (player_attack_timer > 0) 
		 {
			var _perc = 0;
			var _thresh_min = 0;
			var _thresh_max = 0;
			if (player_attack_performing == 0) 
			{ 
				_perc = 1 - (player_attack_timer / ctl.player[id_player_data_attack1_duration]);
				_thresh_min = player[id_player_data_attack1_combothreshold_min];
				_thresh_max = player[id_player_data_attack1_combothreshold_max];
			}
			else if (player_attack_performing == 1) 
			{ 
				_perc = 1 - (player_attack_timer / ctl.player[id_player_data_attack1_duration]); 
				_thresh_min = player[id_player_data_attack2_combothreshold_min];
				_thresh_max = player[id_player_data_attack2_combothreshold_max];
			}
			
			if (_perc >= _thresh_min && _perc <= _thresh_max)
			{
				show_debug_message("Within Threshold - Next ATK")
		        if (player_attack_performing == 0) 
				{
					player_attack_performing = 1;
		        } 
				else if (player_attack_performing == 1)
				{
					player_attack_performing = 0;
		        }
				_perform = true;
			}
			else
			{
				player_attack_punish_timer = player[id_player_data_attack_punish];
				show_debug_message("Punish")
			}
		} 
		else 
		{
			show_debug_message("From Scratct")
			_perform = true;
			player_attack_performing = 0;
		}	
		
		if (_perform == true)
		{
			if (player_attack_performing == 0)
			{
				player_attack_timer = ctl.player[id_player_data_attack1_duration];
				obj_player.image_index = 0;
				scr_combat_force(0, obj_player, 2, player[id_player_data_dir], player[id_player_data_friction]);
				var _attack1_sounds = ctl.player[id_player_data_snds_attack1];
				audio_play_sound(_attack1_sounds[irandom(array_length(_attack1_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
			}
			else if (player_attack_performing == 1)
			{
				player_attack_timer = ctl.player[id_player_data_attack1_duration];
				obj_player.image_index = 0;
				scr_combat_force(0, obj_player, 2, player[id_player_data_dir], player[id_player_data_friction]);
				var _attack2_sounds = ctl.player[id_player_data_snds_attack2];
				audio_play_sound(_attack2_sounds[irandom(array_length(_attack2_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
			}
		}
	}
	
	#region SET DIRECTION
	if (player[id_player_data_hsp] < 0 && player[id_player_data_vsp] < 0)
	{
		player[id_player_data_dir] = 135;
	}
	else if (player[id_player_data_hsp] > 0 && player[id_player_data_vsp] < 0)
	{
		player[id_player_data_dir] = 45;
	}
	else if (ctl.player[id_player_data_hsp] < 0 && player[id_player_data_vsp] > 0)
	{
		player[id_player_data_dir] = 225;
	}
	else if (player[id_player_data_hsp] > 0 && player[id_player_data_vsp] > 0)
	{
		player[id_player_data_dir] = 315;
	}
	else if (player[id_player_data_hsp] < 0)
	{
		player[id_player_data_dir] = 180;
	}
	else if (player[id_player_data_hsp] > 0)
	{
		player[id_player_data_dir] = 0;
	}
	else if (player[id_player_data_vsp] < 0)
	{
		player[id_player_data_dir] = 90;
	}
	else if ( player[id_player_data_vsp] > 0)
	{
		player[id_player_data_dir] = 270;
	}
	#endregion
	
	#region ANIMATION AND SOUND
	var _spr_idle = noone;
	var _spr_walk = noone;
	var _spr_run = noone;
	var _spr_stop = noone;
	var _spr_roll = noone;
	var _spr_attack1 = noone;
	var _spr_attack2 = noone;
	// Update position
	with (obj_player)
	{
	    x += ctl.player[id_player_data_hsp];
	    y += ctl.player[id_player_data_vsp];
		switch (ctl.player[id_player_data_dir])
		{
			case 0:
				_spr_stop = ctl.player[id_player_data_spr_runstop_right]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_right]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_right];
				_spr_run = ctl.player[id_player_data_spr_run_right];
				_spr_roll = ctl.player[id_player_data_spr_roll_right];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_right];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_right];
			break;
			
			case 45:
				_spr_stop = ctl.player[id_player_data_spr_runstop_upright]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_upright]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_upright];
				_spr_run = ctl.player[id_player_data_spr_run_upright];
				_spr_roll = ctl.player[id_player_data_spr_roll_upright];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_upright];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_upright];
			break;
			
			case 90:
				_spr_stop = ctl.player[id_player_data_spr_runstop_up]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_up]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_up];
				_spr_run = ctl.player[id_player_data_spr_run_up];
				_spr_roll = ctl.player[id_player_data_spr_roll_up];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_up];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_up];
			break;
			
			case 135:
				_spr_stop = ctl.player[id_player_data_spr_runstop_upleft]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_upleft]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_upleft];
				_spr_run = ctl.player[id_player_data_spr_run_upleft];
				_spr_roll = ctl.player[id_player_data_spr_roll_upleft];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_upleft];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_upleft];
			break;
			
			case 180:
				_spr_stop = ctl.player[id_player_data_spr_runstop_left]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_left]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_left];
				_spr_run = ctl.player[id_player_data_spr_run_left];
				_spr_roll = ctl.player[id_player_data_spr_roll_left];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_left];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_left];
				
			break;
			
			case 225:
				_spr_stop = ctl.player[id_player_data_spr_runstop_downleft]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_downleft]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_downleft];
				_spr_run = ctl.player[id_player_data_spr_run_downleft];
				_spr_roll = ctl.player[id_player_data_spr_roll_downleft];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_downleft];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_downleft];
			break;
			
			case 270:
				_spr_stop = ctl.player[id_player_data_spr_runstop_down]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_down]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_down];
				_spr_run = ctl.player[id_player_data_spr_run_down];
				_spr_roll = ctl.player[id_player_data_spr_roll_down];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_down];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_down];
			break;
			
			case 315:
				_spr_stop = ctl.player[id_player_data_spr_runstop_downright]; 
				_spr_idle = ctl.player[id_player_data_spr_idle_downright]; 
				_spr_walk = ctl.player[id_player_data_spr_walk_downright];
				_spr_run = ctl.player[id_player_data_spr_run_downright];
				_spr_roll = ctl.player[id_player_data_spr_roll_downright];
				_spr_attack1 = ctl.player[id_player_data_spr_attack1_downright];
				_spr_attack2 = ctl.player[id_player_data_spr_attack2_downright];
			break;
		}
		if (_attacking == true)
		{
			if (ctl.player_attack_performing == 0) { sprite_index = _spr_attack1; }
			else if (ctl.player_attack_performing == 1) { sprite_index = _spr_attack2; }
		}
		else if (_rolling == true)
		{
			sprite_index = _spr_roll;
		}
		else if (_hmove == false && _vmove == false) 
		{ 
			if (_stopping == false)
			{
				sprite_index = _spr_idle; 
			}
			else
			{
				sprite_index = _spr_stop;
			}
		}
		else 
		{ 
			if (_running == true)
			{
				sprite_index = _spr_run;
				if (game_timer mod 9 == 0)
				{
					var _step_sounds = ctl.player[id_player_data_snds_step];
					audio_play_sound(_step_sounds[irandom(array_length(_step_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
				}
			}
			else if (_walking == true)
			{
				sprite_index = _spr_walk;
				if (game_timer mod 18 == 0)
				{
					var _step_sounds = ctl.player[id_player_data_snds_step];
					audio_play_sound(_step_sounds[irandom(array_length(_step_sounds)-1)],10,false,1,0,random_range(0.8,1.2));
				}
			}
			ctl.player_runstop_timer = 0;
		}
	}
	#endregion
	
	if (_running == true) { player_previous_movestate = 1; }
	else { player_previous_movestate = 0; }
}