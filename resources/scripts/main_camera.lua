local pp_result = nil
local min_scale = 1.0

function start()
    pp_result = entity:find_child("post_process_result")
end

function update()
    ratio = juice.vec2.new(
        entity.ui_element.dimensions.x / 320,
        entity.ui_element.dimensions.y / 180
    )
    min_scale = math.min(ratio.x, ratio.y)
    pp_result.ui_element.dimensions = juice.vec2.new(min_scale * 320, min_scale * 180)
end

function shake_camera(length, intensity)
    juice.routine.create(function()
        juice.routine.wait_seconds_func(length, function(x)
            local rand_x = (math.random() * 2 - 1) * intensity * min_scale * (1.0 - x)
            local rand_y = (math.random() * 2 - 1) * intensity * min_scale * (1.0 - x)
            pp_result.ui_element.offset = juice.vec2.new(rand_x, rand_y)
        end)
        pp_result.ui_element.offset = juice.vec2.new(0, 0)
    end)
end