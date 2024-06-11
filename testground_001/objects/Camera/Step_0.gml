if(live_call()) return live_result;
if(!instance_exists(Player)) exit;

x = Player.x - sprite_width/2;
y = Player.y - sprite_height/2;

x = clamp(x, 0, room_width - sprite_width/2);
y = clamp(y, 0, room_height - sprite_height/2);


camera_set_view_pos(view_camera[0],x,y);

if(keyboard_check_pressed(ord("P"))){
    update_camera();
}
