function PopulateSpriteList(_array, _name){
    for(var i=1;i<9;i++){
        array_push(_array, asset_get_index("spr_" + _name + string(i)));
    }
}
