local target = nil

function start()
    target = find_entity("submarine")
end

function update(delta)
    if target ~= nil then
        entity.transform.rotation = target.physics.velocity.y * -20.0
    end
end