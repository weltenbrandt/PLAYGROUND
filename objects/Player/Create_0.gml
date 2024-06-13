spr_struct = {
    idle: [],
    walk: [],
    run : [],
    roll: [],
    run_stop : [],
    attack1  : [],
    attack2  : [],
}
PopulateSpriteList(spr_struct.idle, "player_idle");
PopulateSpriteList(spr_struct.walk, "player_walk");
PopulateSpriteList(spr_struct.run,  "player_run");
PopulateSpriteList(spr_struct.roll, "player_roll");
PopulateSpriteList(spr_struct.run_stop, "player_runstop");
PopulateSpriteList(spr_struct.attack1, "player_attack1");
PopulateSpriteList(spr_struct.attack2, "player_attack2");
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

        move();

        if(INPUT.attack){
            fsm.change("attack1");
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
        spd_buffer = [];
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        move();

        if(INPUT.roll){
            fsm.change("roll");
            exit;
        }
        if(INPUT.attack){
            fsm.change("attack1");
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
        spd_buffer = [];
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        move();

        if(INPUT.roll){
            fsm.change("roll");
            exit;
        }
        if(INPUT.attack){
            fsm.change("attack1");
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

//Run stop state doesn't use move(), switches to idle when animation ends
fsm.add("run_stop",{
    enter: function(){
        sprite_list = spr_struct.run_stop;
    },
    leave: function(){
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        speed = lerp(speed, 0, 0.3);
    },
    animation_end: function(){
        fsm.change("idle");
    },
    draw: function(){
        draw_self();
    }
});


perform_combo = false;//Meaning player pressed the key for second hit at the correct time
block_combo   = false;//Punish player for spamming attack
fsm.add("attack1",{
    enter: function(){
        sprite_list = spr_struct.attack1;
        image_index = 0;

        speed = 3;
        friction = 0.2;
    },
    leave: function(){
        speed = 0;
        friction = 0;
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];

        if(INPUT.attack){
            if(image_index < 4){
                Trace("Combo blocked, frame: "+string(image_index));
                block_combo = true;
            }else if(!block_combo && image_index >= 4 && image_index <= 6){
                perform_combo = true;
            }
        }
    },
    animation_end: function(){
        block_combo = false;
        if(perform_combo){
            fsm.change("attack2");
            perform_combo = false;
        }else{
            fsm.change("idle");
        }
    },
    draw: function(){
        draw_self();
    }
});
fsm.add("attack2",{
    enter: function(){
        image_index = 0;
        sprite_list = spr_struct.attack2;

        speed = 2;
        friction = 0.1;
    },
    leave: function(){
        speed = 0;
        friction = 0;
    },
    step: function(){
        var _spr_dir = get_sprite_dir();
        sprite_index = sprite_list[_spr_dir];
    },
    animation_end: function(){
        fsm.change("idle");
    },
    draw: function(){
        draw_self();
    }
});

get_sprite_dir = function(){
    var _max_dir = 8;
    return (round(direction / (360/_max_dir)) % _max_dir);
}

walk_speed  = 2;
run_speed   = 4;

//Used for run-stop state switching
spd_buffer  = []; //Tracks speed per frame
buffer_size = 10; //This allows us to check speed 10 frame ago and compare, which gives us 10 frame buffer

step_sfx_timer = new Timer(10);
move = function(){
    if(!is_undefined(INPUT.dirl)){
        //Play step sounds
        if(step_sfx_timer.countdown()){
            SfxPlay(choose(sfx_step1, sfx_step2));
            Trace("Play step sfx - "+string(get_timer()));
        }
        //Player movement input
        direction = INPUT.dirl
        if(INPUT.distl >= 0.5){
            speed = lerp(speed, run_speed, 0.2);
            fsm.change("run");
        }else{
            speed = lerp(speed, walk_speed, 0.2);
            fsm.change("walk");
        }

        if(array_length(spd_buffer) == buffer_size){
            array_shift(spd_buffer);
        }
        array_push(spd_buffer, speed);
    }else{
        step_sfx_timer.reset();
        if(array_length(spd_buffer) == buffer_size && spd_buffer[4] > walk_speed){
            fsm.change("run_stop");
            spd_buffer = [];
            exit;
        }
        if(fsm.get_current_state() != "run_stop"){
            speed = lerp(speed, 0, 0.4);
            fsm.change("idle");
            spd_buffer = [];
        }
    }

    x = clamp(x, 0, room_width);
    y = clamp(y, 0, room_height);
}

skill1 = SKILL_LIST.skill1;
skill2 = SKILL_LIST.skill2;
skill3 = SKILL_LIST.skill3;
chosen_skill = skill1;
