local target = nil

function start()
    target = find_entity("submarine")
end

function update(delta)
    if not target.scripts.submarine.game_over then
        if target.physics.velocity.y ~= 0.0 then
            entity.parent.sprite.color.a = 1
            entity.sprite.color.a = 1
        end
        entity.transform.rotation = target.physics.velocity.y * -20.0
    else
        entity.transform.rotation = entity.transform.rotation + delta * -1000.0
    end
end