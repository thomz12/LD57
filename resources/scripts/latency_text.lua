local submarine = nil

function start()
    submarine = find_entity("submarine")
end

function update()
    entity.ui_text.text = tostring(math.floor(submarine.scripts.submarine.latency * 1000)) .. " ms"
end