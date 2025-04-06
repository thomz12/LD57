local time = 0

function start()
    entity.ui_element.on_mouse_enter = function()
        juice.info("enter!")
    end
end

function update(delta)
    time = time + delta
    entity.ui_element.dimensions.x = 200 + 5 + math.sin(math.pi * 2 * time) * 5
    entity.ui_element.dimensions.y = 32 + 5 + math.sin(math.pi * 2 * time) * 5

    if juice.input.is_key_pressed("space") then
        find_entity("button_play").ui_panel.color = juice.color.new(1, 1, 1, 1)

        juice.routine.create(function()
            find_entity("crt_on_off_effect").scripts.crt_on_off_effect.turn_off()
            juice.routine.wait_seconds(1.0)
            load_scene("scenes/main.jbscene")
        end)
    end
end