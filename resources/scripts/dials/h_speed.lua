local target = nil

function start()
    target = find_entity("submarine")
end

function update(delta)
    if target ~= nil then
        entity.transform.rotation = target.physics.velocity.x * -10.0
    end
end