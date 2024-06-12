function PopulateSpriteList(_array, _name){
    for(var i=1;i<9;i++){
        array_push(_array, asset_get_index("spr_" + _name + string(i)));
    }
}
function Timer(_time, _auto_reset = true) constructor{
    time_reset = _time;
    auto_reset = _auto_reset;

    time = time_reset;
    static countdown = function(){
        //time=Approach(time,-1,1);
        if(time < 0){
            time =- 1;
            if(auto_reset) reset();
            return true;
        }else{
            time--;
            return false;
        }
    }
    static reset = function(_time = time_reset){
        time = _time;
    }
}

function sprite_is_on_frame(_frame){
    /// @description sprite_is_on_frame(frame)
    /// @param frame
    /// Returns true on the first step the desired frame is displayed.
    /// Jon didn't make it don't let him take credit.
    var _ret = (image_index - sprite_get_speed(sprite_index)/(sprite_get_speed_type(sprite_index)==spritespeed_framespergameframe?1:room_speed)*image_speed<(_frame)) && floor(image_index+math_get_epsilon()) == _frame;
    return _ret;
}

function SfxPlay(_sfx, _random_pitch = true){
    if(audio_is_playing(_sfx)) audio_stop_sound(_sfx);
    var _index = audio_play_sound(_sfx, 0, false);
    if(_random_pitch) audio_sound_pitch(_index, irandom_range(0.8, 1.2));
}
