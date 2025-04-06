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
        if juice.input.is_key_released("escape") then
            juice.routine.create(function()
                entity:find_child("crt_on_off_effect").scripts.crt_on_off_effect.turn_off()
                juice.routine.wait_seconds(0.5)
                load_scene("scenes/main_menu.jbscene")
            end)
        end
    end
end

function on_game_over()
    entity.audio:play()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(4, function(x)
            entity.audio.volume = 1.0 - x
        end)
    end)

    juice.routine.create(function()
        find_entity("main_camera").scripts.main_camera.shake_camera(3.0, 2.0)
        entity:find_child("sonar_image").ui_image.image = juice.resources:load_texture("sprites/no_signal.png")
        juice.routine.wait_seconds_func(2, function(x)
            find_entity("crt_camera").scripts.crt.chrom = 1 + math.random() * 20 * (1.0 - x)
        end)
        juice.routine.wait_seconds(2.0)
        entity:find_child("game_ui").ui_element.enabled = false
        entity:find_child("disconnected").ui_element.enabled = true
        game_over = true
        local box = entity:find_child("red_background")
        juice.routine.wait_seconds_func(1.0, function(x)
            box.ui_element.dimensions.y = x * 64
        end)
        juice.routine.wait_seconds(1.0)
        entity:find_child("retry").ui_element.enabled = true
        juice.routine.wait_seconds(1.0)
        entity:find_child("exit").ui_element.enabled = true
    end)
end