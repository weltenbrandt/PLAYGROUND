spr_struct = {
    idle: [],
    walk: [],
    run : [],
    roll: [],
}
PopulateSpriteList(spr_struct.idle, "player_idle");
PopulateSpriteList(spr_struct.walk, "player_walk");
PopulateSpriteList(spr_struct.run,  "player_run");
PopulateSpriteList(spr_struct.roll, "player_roll");
Trace("spr_struct: "+string(spr_struct));


fsm = new SnowState("idle");

fsm.add("idle",{
    enter: function(){
        sprite_list = spr_struct.idle;
    },
    leave: function(){
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        //Move
        var _spd = move();
        if(_spd == walk_speed){
            fsm.change("walk");
            exit;
        }else if(_spd > walk_speed){
            fsm.change("run");
            exit;
        }
    },
    draw: function(){
        draw_self();
    },
});

fsm.add("walk",{
    enter: function(){
        sprite_list = spr_struct.walk;
    },
    leave: function(){
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        try{
            sprite_index = sprite_list[_spr_dir];
        }catch(e){
            Trace("_spr_dir: "+string(_spr_dir));
            TraceException(e);
        }

        //Move
        var _spd = move();
        if(_spd == 0){
            fsm.change("idle");
            exit;
        }else if(_spd > walk_speed){
            fsm.change("run");
            exit;
        }

        //Roll
        if(INPUT.roll){
            fsm.change("roll");
            exit;
        }
    },
    draw: function(){
        draw_self();
    }
});

fsm.add("run",{
    enter: function(){
        sprite_list = spr_struct.run;
    },
    leave: function(){
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        //Move
        var _spd = move();
        if(_spd == 0){
            fsm.change("idle");
            exit;
        }else if(_spd == walk_speed){
            fsm.change("walk");
            exit;
        }

        //Roll
        if(INPUT.roll){
            fsm.change("roll");
            exit;
        }
    },
    draw: function(){
        draw_self();
    },
});


fsm.add("roll",{
    enter: function(){
        image_index = 0;
        sprite_list = spr_struct.roll;
    },
    leave: function(){
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];
    },
    draw: function(){
        draw_self();
    },
    animation_end: function(){
        fsm.change("idle");
    }
});

get_sprite_dir = function(){
    var _max_dir = 8;
    return (round(direction / (360/_max_dir)) % _max_dir);
}

walk_speed = 2;
move = function(){
    speed = 0;
    if(!is_undefined(INPUT.dirl)){
        //Player movement input
        direction = INPUT.dirl
        speed = walk_speed;
        if(INPUT.run){
            speed *= 2;
        }
    }
    return speed;
}

