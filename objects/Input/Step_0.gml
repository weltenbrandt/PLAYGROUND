with(INPUT){
    left    = input_check("left");
    right   = input_check("right");
    up      = input_check("up");
    down    = input_check("down");
    roll    = input_check("accept");
    run     = input_check("special");
    attack  = input_check_pressed("action");
    dirl    = input_direction(undefined, "left", "right", "up", "down");
    distl   = input_distance("left","right","up","down");
}
