// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_init()
{
	#macro ctl obj_control
	randomize();
	scr_camera_init();
	scr_player_init();

	game_gui_width = 360;
	game_gui_height = 180;
	
	display_set_gui_size(game_gui_width,game_gui_height);
	globalvar game_timer;
	game_timer = 0;
	game_savefile = "savefile.ini";
	//application_surface_draw_enable(false);
	
	
	#macro id_key_left 0
	#macro id_key_right 1
	#macro id_key_up 2
	#macro id_key_down 3
	#macro id_key_interact 4
	#macro id_key_cancel 5
	#macro id_key_inventory 6
	#macro id_key_menu_up 7
	#macro id_key_menu_down 8
	#macro id_key_menu_left 9
	#macro id_key_menu_right 10
	#macro id_key_interact_hold 11
	#macro id_key_assign 12
	#macro id_key_shoulder_left 13
	#macro id_key_shoulder_right 14
	
	// Initialize keyboard controls
	key_left = ord("A");
	key_right = ord("D");
	key_up = ord("W");
	key_down = ord("S");
	key_interact = vk_space;
	key_interact_hold = vk_space;
	key_cancel = vk_escape;
	key_inventory = ord("I");
	key_assign = ord("T");
	key_shoulder_left =  ord("Q");
	key_shoulder_right =  ord("E");
	// Initialize gamepad controls
	keygp_left = gp_axislh;
	keygp_right = gp_axislh;
	keygp_up = gp_axislv;
	keygp_down = gp_axislv;
	keygp_interact = gp_face1; // "X on PS controller"
	keygp_interact_hold = gp_face1;
	keygp_cancel = gp_face2; // "O on PS controller"
	keygp_inventory = gp_face4; // "Triangle on PS controller"
	keygp_assign = gp_face3; // Square on PS controller";
	keygp_shoulder_left = gp_shoulderl;
	keygp_shoulder_right = gp_shoulderr;
	
	
	keygp_pad_up = gp_padu;
	keygp_pad_down = gp_padd;
	keygp_pad_left = gp_padl;
	keygp_pad_right = gp_padr;
	
	key_stick_tilt = 0;
	key_stick_tilt_deadzone = 0.1;
	key_stick_tilt_run = false;
	key_stick_tilt_run_threshold = 0.99;
	
	globalvar key;
	key[id_key_left] = -1;
	key[id_key_right] = -1;
	key[id_key_up] = -1;
	key[id_key_down] = -1;
	key[id_key_interact] = -1;
	key[id_key_cancel] = -1;
	key[id_key_inventory] = -1;
	key[id_key_shoulder_left] = -1;
	key[id_key_shoulder_right] = -1;
	
	key[id_key_interact_hold] = -1
	key[id_key_assign] = -1;
	
	scr_camera_set();
}