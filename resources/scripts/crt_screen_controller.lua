local game_over = false

function start()
    find_entity("submarine").scripts.submarine.on_game_over = on_game_over
end

function update()
    if game_over then
        if juice.input.is_key_released("space") then
            juice.routine.create(function()
                entity:find_child("crt_on_off_effect").scripts.crt_on_off_effect.turn_off()
                juice.routine.wait_seconds(0.5)
                load_scene("scenes/main.jbscene")
            end)
        end
    end
end

function on_game_over()
    entity:find_child("game_ui").ui_element.enabled = false
    entity:find_child("disconnected").ui_element.enabled = true
    game_over = true
    local box = entity:find_child("red_background")

    juice.routine.create(function()
        juice.routine.wait_seconds_func(1.0, function(x)
            box.ui_element.dimensions.y = x * 64
        end)
        juice.routine.wait_seconds(1.0)
        entity:find_child("retry").ui_element.enabled = true
    end)
end