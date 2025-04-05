-- How long it takes in seconds for inputs to be received by the submarine.
latency = 0.0
max_latency = 2
latency_progress = 0.0001

-- Speed of the submarine along both axis.
horizontal_speed = 8.0
vertical_speed = 2.0

local input_buffer = {}
local time = 0.0

local start_pos = juice.vec2.new(0, 0)
game_over = false

function start()
    start_pos = juice.vec2.new(entity.transform.position)
    entity.physics.on_physics_update = on_physics
    entity.physics_box.on_collision_start = on_collision
end

function on_collision(_, other)
    if other.parent.name == "tilemap" then
        if not game_over and on_game_over ~= nil then
            game_over = true
            on_game_over()
            find_entity("main_camera").scripts.main_camera.shake_camera(1.0, 2.0)
        end
    end
end

function on_physics(delta)
    local pos = entity.transform.position
    latency = juice.vec2.new(start_pos.x - pos.x, start_pos.y - pos.y):length() * latency_progress

    -- Keep track of time.
    time = time + delta
    local input_time = time + latency

    -- Store inputs in buffer to be delayed.
    if juice.input.is_key_held("a") or juice.input.is_key_held("left") then
        table.insert(input_buffer, { receive = input_time, cmd = "left"} )
    elseif juice.input.is_key_held("d") or juice.input.is_key_held("right") then
        table.insert(input_buffer, { receive = input_time, cmd = "right"})
    elseif juice.input.is_key_held("w") or juice.input.is_key_held("up") then
        table.insert(input_buffer, { receive = input_time, cmd = "up"})
    elseif juice.input.is_key_held("s") or juice.input.is_key_held("down") then
        table.insert(input_buffer, { receive = input_time, cmd = "down"})
    end

    -- If there is an item in the input buffer, try to process it.
    if #input_buffer > 0 then
        if input_buffer[1].receive <= time then
            local cmd = input_buffer[1].cmd

            -- Process command.
            if cmd == "left" then
                entity.physics:add_force(juice.vec2.new(-horizontal_speed, 0))
            elseif cmd == "right" then
                entity.physics:add_force(juice.vec2.new(horizontal_speed, 0))
            elseif cmd == "up" then
                entity.physics:add_force(juice.vec2.new(0, vertical_speed))
            elseif cmd == "down" then
                entity.physics:add_force(juice.vec2.new(0, -vertical_speed))
            end

            -- Remove the command.
            table.remove(input_buffer, 1)
        end
    end
end