time = 0.0

local player = nil

function start()
    player = find_entity("submarine")
end

function update(delta)
    if player.scripts.submarine.game_over then
        time = time + delta * 500
    else
        time = time + delta
    end
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    entity.ui_text.text = string.format("%02.f:%02.f", minutes, seconds)
end