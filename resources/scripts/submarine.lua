-- How long it takes in seconds for inputs to be received by the submarine.
latency = 0.0

local input_buffer = {}
local time = 0.0

function update(delta)

    -- Keep track of time.
    time = time + delta
    local input_time = time + latency

    -- Store inputs in buffer to be delayed.
    if juice.input.is_key_held("a") then
        table.insert(input_buffer, { receive = input_time, cmd = "left"} )
    elseif juice.input.is_key_held("d") then
        table.insert(input_buffer, { receive = input_time, cmd = "right"})
    elseif juice.input.is_key_held("w") then
        table.insert(input_buffer, { receive = input_time, cmd = "up"})
    elseif juice.input.is_key_held("s") then
        table.insert(input_buffer, { receive = input_time, cmd = "down"})
    end

    -- If there is an item in the input buffer, try to process it.
    if #input_buffer > 0 then
        if input_buffer[1].receive <= time then
            local cmd = input_buffer[1].cmd

            -- Process command.
            if cmd == "left" then
                entity.physics:add_force(juice.vec2.new(-16, 0))
            elseif cmd == "right" then
                entity.physics:add_force(juice.vec2.new(16, 0))
            elseif cmd == "up" then
                entity.physics:add_force(juice.vec2.new(0, 16))
            elseif cmd == "down" then
                entity.physics:add_force(juice.vec2.new(0, -16))
            end

            -- Remove the command.
            table.remove(input_buffer, 1)
        end
    end

end