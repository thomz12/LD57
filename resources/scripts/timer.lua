time = 0.0

function update(delta)
    time = time + delta
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    entity.ui_text.text = string.format("%02.f:%02.f", minutes, seconds)
end