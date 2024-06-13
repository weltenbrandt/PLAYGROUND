if(live_call()) return live_result;

var _skill_x = 32;
var _skill_y = guiHeight * 0.85;
var _skill_gap = 48;

var _skill1 = noone;
var _skill2 = noone;
var _skill3 = noone;
with(Player){
    _skill1 = skill1.icon;
    _skill2 = skill2.icon;
    _skill3 = skill3.icon;
    var _chosen_skill = chosen_skill;
}

if(sprite_exists(_skill1)){
    var c = _chosen_skill.icon == _skill1 ? c_yellow : c_white;
    draw_sprite_ext(spr_skill_slot, 0, _skill_x, _skill_y, 1, 1, 0, c, 1);
    draw_sprite_ext(_skill1, 0, _skill_x, _skill_y, 1, 1, 0, c_white, 1);
    _skill_x += _skill_gap;
}
if(sprite_exists(_skill2)){
    var c = _chosen_skill.icon == _skill2 ? c_yellow : c_white;
    draw_sprite_ext(spr_skill_slot, 0, _skill_x, _skill_y, 1, 1, 0, c, 1);
    draw_sprite_ext(_skill2, 0, _skill_x, _skill_y, 1, 1, 0, c_white, 1);
    _skill_x += _skill_gap;
}
if(sprite_exists(_skill3)){
    var c = _chosen_skill.icon == _skill3 ? c_yellow : c_white;
    draw_sprite_ext(spr_skill_slot, 0, _skill_x, _skill_y, 1, 1, 0, c, 1);
    draw_sprite_ext(_skill3, 0, _skill_x, _skill_y, 1, 1, 0, c_white, 1);
}
