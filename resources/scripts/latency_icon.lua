local submarine = nil

function start()
    submarine = find_entity("submarine")
end

function update()
    if submarine ~= nil then
        local progress = submarine.scripts.submarine.latency / submarine.scripts.submarine.max_latency
        local status = 5 - math.floor(progress * 5)
        status = math.min(5, math.max(0, status))
        entity.ui_image.image = juice.resources:load_texture("sprites/ui/status_" .. status .. ".png")
    end
end