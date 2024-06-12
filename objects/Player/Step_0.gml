if(live_call()) return live_result;
fsm.step();
GuiTrace("INPUT.dirl: ",INPUT.dirl);
GuiTrace("INPUT.disl: ",INPUT.distl);

GuiTrace("State: ",fsm.get_current_state());

GuiTrace("sprite_index: "+sprite_get_name(sprite_index));

GuiTrace("step_sfx_timer.time: ",step_sfx_timer.time);
