local submarine = nil
local image = nil
local text = nil

local status_colors = {
    juice.color.new(1.0, 0.0, 0.0, 1.0),
    juice.color.new(1.0, 0.33, 0.0, 1.0),
    juice.color.new(1.0, 0.66, 0.0, 1.0),
    juice.color.new(0.66, 1.0, 0.0, 1.0),
    juice.color.new(0.33, 1.0, 0.0, 1.0),
    juice.color.new(0.0, 1.0, 0.0, 1.0),
}

function start()
    submarine = find_entity("submarine")
    image = find_entity("status_icon")
    text = find_entity("latency_text")
end

function update()
    if submarine ~= nil then
        local progress = submarine.scripts.submarine.latency / submarine.scripts.submarine.max_latency
        local status = 5 - math.floor(progress * 5)
        status = math.min(5, math.max(0, status))

        image.ui_image.image = juice.resources:load_texture("sprites/ui/status_" .. status .. ".png")
        entity.ui_panel.color = status_colors[status + 1]
        text.ui_text.text = tostring(math.floor(submarine.scripts.submarine.latency * 1000)) .. " ms"
    end
end