var _width = 1920/5;
var _height = 1080/5;



image_xscale = _width/sprite_width;
image_yscale = _height/sprite_height;
Trace("sprite_width: "+string(sprite_width));
Trace("sprite_height: "+string(sprite_height));

update_camera = function(){
    live_name="update_camera";
    if(live_call()) return live_result;

    Trace("Update camera");
    var _scale = 3;
    surface_resize(application_surface, sprite_width, sprite_height);
    camera_set_view_size(view_camera[0], sprite_width, sprite_height);
    window_set_size(sprite_width * _scale, sprite_height * _scale);
}
update_camera();




display_width  = display_get_width();
display_height = display_get_height();
aspect_ratio   = display_width/display_height;
ideal_height   = 216;
ideal_width    = round(ideal_height*aspect_ratio);
if(display_width % ideal_width != 0){
    ideal_width = display_width/round(display_width/ideal_width);
}
if(display_height % ideal_height != 0){
    ideal_height = display_height/round(display_height/ideal_height);
}
if(ideal_width & 1)  ideal_width++;
if(ideal_height & 1) ideal_height++;
