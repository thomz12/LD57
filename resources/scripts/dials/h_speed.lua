local target = nil

function start()
    target = find_entity("submarine")
end

function update(delta)
    if target ~= nil then
        if not target.scripts.submarine.game_over then
            entity.transform.rotation = target.physics.velocity.x * -10.0
        else
            entity.transform.rotation = entity.transform.rotation + delta * 1000.0
        end
    end
end