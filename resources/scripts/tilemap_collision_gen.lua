function start()
    local created = 0
    for i, tile in ipairs(entity.tilemap.tile_data) do
        if tile >= 0 and tile ~= 42 then
            local box = create_entity("box " .. created)
            box:set_parent(entity)
            box:add_component("transform")

            local x = math.floor(((i - 1) % entity.tilemap.map_height)) * 16 + 8
            local y = math.floor(((i - 1) / entity.tilemap.map_width)) * 16 + 8
            box.transform.position = juice.vec3.new(x, y, 0)

            box:add_component("physics_box")
            created = created + 1
        end
    end
end