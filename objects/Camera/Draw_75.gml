var _scale=.25*window_scale;

var _text=scribble(DEBUG.text);
_text.blend(c_black).scale(_scale).align(fa_left,fa_top).wrap(display_get_gui_width());


var _x=1;var _y=-17;
_text.draw(_x+1,_y);
_text.draw(_x-1,_y);
_text.draw(_x  ,_y+1);
_text.draw(_x  ,_y-1);
_text.blend(c_white).draw(_x,_y);

DEBUG.text="";
