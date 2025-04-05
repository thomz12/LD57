function flash_color(color)
    entity.ui_panel.color = color
    local start_a = color.a
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.2, function(x)
            entity.ui_panel.color.a = start_a - (x * start_a)
        end)
    end)
end