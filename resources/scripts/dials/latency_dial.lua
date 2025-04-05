local target = nil

local time = 0

function start()
    target = find_entity("submarine")
end

function update(delta)
    if target ~= nil then
        if not target.scripts.submarine.game_over then
            local progress = target.scripts.submarine.latency / target.scripts.submarine.max_latency
            entity.transform.rotation = 90 - (progress * 180)
        else
            time = time + delta
            entity.transform.rotation = 90 - ((math.sin(time * 10) + 1.0) / 2.0) * 180
        end
    end
end