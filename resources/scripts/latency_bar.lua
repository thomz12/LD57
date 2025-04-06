local submarine = nil
local image = nil
local text = nil

update_wait = 1.0
local time = 0.0

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

function update(delta)
    time = time + delta
    if submarine ~= nil and time >= update_wait then
        if not submarine.scripts.submarine.game_over then
            local progress = submarine.scripts.submarine.latency / submarine.scripts.submarine.max_latency
            local status = 5 - math.floor(progress * 5)
            status = math.min(5, math.max(0, status))

            image.ui_image.image = juice.resources:load_texture("sprites/ui/status_" .. status .. ".png")
            entity.ui_panel.color = status_colors[status + 1]
            text.ui_text.text = tostring(math.floor(submarine.scripts.submarine.latency * 1000)) .. " ms"
        else
            update_wait = 0.1
            image.ui_image.image = juice.resources:load_texture("sprites/ui/status_" .. math.random(0, 5) .. ".png")
            entity.ui_panel.color = status_colors[math.random(1, 6)]
            text.ui_text.text = tostring(math.random(0, 1000)) .. " ms"
        end
        time = 0.0
    end
end