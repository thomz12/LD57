local top
local bottom
local left
local right

function start()
    entity.ui_element.enabled = true
    top = entity:find_child("black_top")
    bottom = entity:find_child("black_bottom")
    left = entity:find_child("black_left")
    right = entity:find_child("black_right")
    turn_on()
end

function turn_on()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.2, function(x)
            left.ui_element.parent_scale.x = (1.0 - x) * 0.5
            right.ui_element.parent_scale.x = (1.0 - x) * 0.5
            entity.ui_element.dimensions.y = x * 4
        end)
        juice.routine.wait_seconds(0.5)
        juice.routine.wait_seconds_func(0.2, function(x)
            entity.ui_element.parent_scale.y = x
            entity.ui_panel.color.a = 1.0 - x
            find_entity("crt_camera").scripts.crt.crt_strenght = 0.3 + (1.0 - x) * 4
            find_entity("crt_camera").scripts.crt.chrom = 1.0 + (1.0 - x) * 10
        end)
        juice.routine.wait_seconds(1.5)
    end)
end

function turn_off()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.1, function(x)
            entity.ui_element.parent_scale.y = 1.0 - x
            entity.ui_panel.color.a = x
            find_entity("crt_camera").scripts.crt.crt_strenght = 0.3 + (x) * 4
            find_entity("crt_camera").scripts.crt.chrom = 1.0 + (x) * 10
        end)
        juice.routine.wait_seconds(0.1)
        juice.routine.wait_seconds_func(0.1, function(x)
            left.ui_element.parent_scale.x = x * 0.5
            right.ui_element.parent_scale.x = x * 0.5
            entity.ui_element.dimensions.y = 1 + (1.0 - x) * 4
        end)
    end)
end