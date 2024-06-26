// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_handleinput()
{
	// Keyboard input
	key[id_key_left] = keyboard_check(key_left);
	key[id_key_right] = keyboard_check(key_right);
	key[id_key_up] = keyboard_check(key_up);
	key[id_key_down] = keyboard_check(key_down);
	
	key[id_key_interact] = keyboard_check_pressed(key_interact);
	key[id_key_cancel] = keyboard_check_pressed(key_cancel);
	key[id_key_inventory] = keyboard_check_pressed(key_inventory);
	key[id_key_assign] = keyboard_check_pressed(key_assign);
	key[id_key_shoulder_left] = keyboard_check_pressed(key_shoulder_left);
	key[id_key_shoulder_right] = keyboard_check_pressed(key_shoulder_right);
	key[id_key_assign] = keyboard_check_pressed(key_assign);
	
	key[id_key_menu_left] = keyboard_check_pressed(key_left);
	key[id_key_menu_right] = keyboard_check_pressed(key_right);
	key[id_key_menu_up] = keyboard_check_pressed(key_up);
	key[id_key_menu_down] = keyboard_check_pressed(key_down);
	
	if (keyboard_check(key_interact_hold) == true && alarm[0] == -1)
	{
		key[id_key_interact_hold] = true;
		alarm[0] = 2;
	}
	else
	{
		key[id_key_interact_hold] = false;
	}
	// Gamepad input
	var gp_num = gamepad_get_device_count();
	for (var i = 0; i < gp_num; i++) 
	{
	    if (gamepad_is_connected(i)) 
		{
			gamepad_set_axis_deadzone(i, key_stick_tilt_deadzone);
			
			if (gamepad_button_check(i, keygp_pad_left) == true
			|| gamepad_axis_value(i, keygp_left) < -0.5)
			{
	            key[id_key_left] = true;
	        }
			else { key[id_key_left] = false; }
			if (gamepad_button_check(i, keygp_pad_right) == true
			|| gamepad_axis_value(i, keygp_right) > 0.5)
			{
	            key[id_key_right] = true;
	        }
			else { key[id_key_right] = false; }
			if (gamepad_button_check(i, keygp_pad_up) == true
			|| gamepad_axis_value(i, keygp_up) < -0.5)
			{
	            key[id_key_up] = true;
			}
	        else { key[id_key_up] = false; }
			if (gamepad_button_check(i, keygp_pad_down) == true
			|| gamepad_axis_value(i, keygp_down) > 0.5)
			{
	            key[id_key_down] = true;
			}
	        else { key[id_key_down] = false; }
			
			if ( gamepad_axis_value(i, keygp_left) >= key_stick_tilt_run_threshold || gamepad_axis_value(i, keygp_left) <= -key_stick_tilt_run_threshold ||
				 gamepad_axis_value(i, keygp_up) >= key_stick_tilt_run_threshold || gamepad_axis_value(i, keygp_up) <= -key_stick_tilt_run_threshold )
				 {
					 key_stick_tilt_run = true;
				 }
				 else
				 {
					 key_stick_tilt_run = false;
				 }
			
			// Constants for smoothing
			var smoothing_factor = 0.2; // Adjust the smoothing factor as needed
			var previous_tilt_magnitude = 0;

			// Set a reasonable dead zone
			gamepad_set_axis_deadzone(i, 0.2);

			// Read the horizontal and vertical axis values for the left stick of gamepad slot 0
			var haxis = gamepad_axis_value(i, gp_axislh);
			var vaxis = gamepad_axis_value(i, gp_axislv);

			// Calculate the magnitude of the tilt (distance from the origin)
			var tilt_magnitude = point_distance(0, 0, haxis, vaxis);

			// Smooth the tilt magnitude using a weighted average
			tilt_magnitude = lerp(previous_tilt_magnitude, tilt_magnitude, smoothing_factor);
			previous_tilt_magnitude = tilt_magnitude;

			// Define a threshold for maximum tilt magnitude
			var max_tilt_threshold = 1.1; // Adjust as needed

			// Check if the tilt exceeds the maximum threshold
			if (tilt_magnitude > max_tilt_threshold) {
			    // Clamp the tilt magnitude to the maximum threshold
			    tilt_magnitude = max_tilt_threshold;
			}

			// Calculate the direction of the tilt
			var tilt_direction = point_direction(0, 0, haxis, vaxis);
			
			
			
	        key[id_key_interact] = gamepad_button_check_pressed(i, keygp_interact);
	        key[id_key_cancel] = gamepad_button_check_pressed(i, keygp_cancel);
	        key[id_key_inventory] = gamepad_button_check_pressed(i, keygp_inventory);
			key[id_key_assign] = gamepad_button_check_pressed(i, keygp_assign);
			key[id_key_shoulder_left] = gamepad_button_check_pressed(i, keygp_shoulder_left);
			key[id_key_shoulder_right] = gamepad_button_check_pressed(i, keygp_shoulder_right);
			
			if (gamepad_button_check(i,keygp_interact_hold) == true && alarm[0] == -1)
			{
				key[id_key_interact_hold] = true;
				alarm[0] = 10;
			}
			else
			{
				key[id_key_interact_hold] = false;
			}
			
			if ((gamepad_button_check_pressed(i, keygp_pad_left) == true) ||
			((gamepad_axis_value(i, keygp_left) < -0.9) && alarm[0] == -1))
			{
				key[id_key_menu_left] = true;
				alarm[0] = 10;
			}
			else { key[id_key_menu_left] = false;}
			if ((gamepad_button_check_pressed(i, keygp_pad_right) == true) ||
			((gamepad_axis_value(i, keygp_right) > 0.9) && alarm[0] == -1))
			{
				key[id_key_menu_right] = true;
				alarm[0] = 10;
			}
			else { key[id_key_menu_right] = false;}
			if ((gamepad_button_check_pressed(i, keygp_pad_up) == true) ||
			((gamepad_axis_value(i, keygp_up) < -0.9) && alarm[0] == -1))
			{
				key[id_key_menu_up] = true;
				alarm[0] = 10;
			}
			else { key[id_key_menu_up] = false;}
			if ((gamepad_button_check_pressed(i, keygp_pad_down) == true) ||
			((gamepad_axis_value(i, keygp_down) > 0.9) && alarm[0] == -1))
			{
				key[id_key_menu_down] = true;
				alarm[0] = 10;
			}
			else { key[id_key_menu_down] = false;}
			
	        break;
	    }
	}
}