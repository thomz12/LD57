function start()
    juice.routine.create(function()
        juice.routine.wait_seconds(4.0)
        find_entity("crt_on_off_effect").scripts.crt_on_off_effect.turn_off()
        juice.routine.wait_seconds(1.0)
        load_scene("scenes/main_menu.jbscene")
    end)
end