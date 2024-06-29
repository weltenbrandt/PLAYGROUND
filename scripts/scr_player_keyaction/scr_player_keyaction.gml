// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_player_keyaction()
{
	if (key[id_key_shoulder_left] == true)
	{
		player_skill_focus = max(player_skill_focus-1,0);
	}
	else if (key[id_key_shoulder_right] == true)
	{
		player_skill_focus = min(player_skill_focus+1,2);
	}
}