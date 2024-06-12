if(live_call()) return live_result;
if(!instance_exists(Player)) exit;

x = Player.x - sprite_width/2;
y = Player.y - sprite_height/2;

x = clamp(x, 0, room_width - sprite_width);
y = clamp(y, 0, room_height - sprite_height);


camera_set_view_pos(view_camera[0],x,y);
