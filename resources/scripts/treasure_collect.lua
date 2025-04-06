
collected = 0
need = 34

function add_treasure()
    collected = collected + 1
    local amount = collected

    if need == amount then
       entity.scripts.submarine.won = true
       find_entity("timer").scripts.timer.stop_timer = true
    end

    find_entity("treasure_label").ui_element.enabled = true
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.5, function(x)
            find_entity("treasure_label").ui_text.font_size = 16 + juice.ease.in_back(1 - x) * 16
        end)
    end)
    juice.routine.create(function()
        juice.routine.wait_seconds(0.25)
        find_entity("treasure_percentage").ui_text.text = tostring(math.floor(collected / need * 100)) .. "%"
        juice.routine.wait_seconds_func(0.5, function(x)
            find_entity("treasure_percentage").ui_text.font_size = 16 + juice.ease.in_back(1 - x) * 16
        end)

        if need == amount then
            find_entity("crt_camera").scripts.crt_screen_controller.on_game_win()
        end
    end)
end