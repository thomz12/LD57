local target = nil

function start()
    target = find_entity("submarine")
end

function update(delta)
    if target ~= nil then
        if not target.scripts.submarine.game_over then
            if target.physics.velocity.x ~= 0.0 then
                entity.parent.sprite.color.a = 1
                entity.sprite.color.a = 1
            end
            entity.transform.rotation = target.physics.velocity.x * -10.0
        else
            entity.transform.rotation = entity.transform.rotation + delta * 1000.0
        end
    end
end