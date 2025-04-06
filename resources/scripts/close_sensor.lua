close = 0
zoom = 0.1

local zoomed = false

function start()
    entity.physics_box.on_collision_start = function(this, other)
        if other.parent.name == "tilemap" then
            close = close + 1
        end
    end
    entity.physics_box.on_collision_end = function(this, other)
        if other.parent.name == "tilemap" then
            close = close - 1
        end
    end
end

function update()
    if close > 0 then
        entity.parent.scripts.submarine.ping_time = 2.5
        entity.parent.scripts.submarine.ping_pitch_add = 0.1
        if not zoomed then
            zoomed = true
            juice.routine.create(function()
                juice.routine.wait_seconds_func(1.0, function(x)
                    find_entity("submarine_camera").camera.zoom = 1.0 + x * zoom
                end)
            end)
        end
    else
        entity.parent.scripts.submarine.ping_time = 5.0
        entity.parent.scripts.submarine.ping_pitch_add = 0.0
        if zoomed then
            zoomed = false
            juice.routine.create(function()
                juice.routine.wait_seconds_func(1.0, function(x)
                    find_entity("submarine_camera").camera.zoom = 1.0 + (1 - x) * zoom
                end)
            end)
        end
    end
end