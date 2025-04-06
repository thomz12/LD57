blink_speed = 0.5
local time = 0.0
local collected = false

function start()
    time = entity.transform.position.x + entity.transform.position.y
    entity.physics_circle.on_collision_start = on_collision
end

function on_collision(_, other)
    if not collected and other.name == "submarine" then
        collected = true
        find_entity("submarine").scripts.treasure_collect.add_treasure()
        find_entity("flash_panel").scripts.flash.flash_color(juice.color.new(1, 1, 0, 0.2))
        entity:remove_component("sprite")
        entity.audio:play()
        juice.routine.create(function()
            juice.routine.wait_seconds(1.0)
            entity:remove_component("physics_circle")
            destroy_entity(entity)
        end)
    end
end

function update(delta)
    if entity.sprite ~= nil then
        time = (time + delta) % blink_speed
        if time > (blink_speed / 2) then
            entity.sprite.color = juice.color.new(1, 1, 0, 1)
        else
            entity.sprite.color = juice.color.new(1, 1, 1, 1)
        end
    end
end