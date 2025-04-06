function start()
    juice.routine.create(function()
        juice.routine.wait_seconds(2.0)
        juice.routine.wait_seconds_func(0.5, function(x)
            entity.ui_element.pivot.y = x
        end)
    end)
end