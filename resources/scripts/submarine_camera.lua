local target = nil
local target_pos = nil

function start()
    target = find_entity("submarine")
    if target ~= nil then
        entity.transform.position = target.transform.position
        entity.transform.position.z = 0.0
    end
end

function update(delta)
    if target ~= nil then
        target_pos = target.transform.position
        entity.transform.position = juice.vec3.new(
            math.floor(target_pos.x + 0.5),
            math.floor(target_pos.y + 0.5),
            0.0)
    end
end