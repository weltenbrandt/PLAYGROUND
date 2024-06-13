if(live_call()) return live_result;
fsm.step();
GuiTrace("INPUT.dirl: ",INPUT.dirl);
GuiTrace("INPUT.disl: ",INPUT.distl);

GuiTrace("State: ",fsm.get_current_state());

GuiTrace("sprite_index: "+sprite_get_name(sprite_index));

GuiTrace("step_sfx_timer.time: ",step_sfx_timer.time);

if(INPUT.change_skill){
    if(chosen_skill == skill1){
        chosen_skill = skill2;
    }else if(chosen_skill == skill2){
        chosen_skill = skill3;
    }else if(chosen_skill == skill3){
        chosen_skill = skill1;
    }
}
