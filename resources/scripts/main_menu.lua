local time = 0

local function uuid()
    math.randomseed(os.time())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function start()
    if not playfab.signed_in then
        playfab.init("1983B9")
        local id = juice.load_string("player_id")
        if not id or id == "" then
            id = uuid()
            juice.save_string("player_id", id)
        end
        playfab.sign_in(id, function(login_success, login_body)
            if login_success then
                juice.info("signed in!")

                playfab.get_player_profile(function(get_profile_success, get_profile_body)
                    if get_profile_success then
                        if not get_profile_body.PlayerProfile.DisplayName then
                            names = { "Diver", "Officer", "Chief", "Navigator", "Sonar Tech", "Torpedo", "Engineer", "Comm Tech", "Medical", "Cook", "Deckhand" }
                            local new_username = names[math.random(#names)] .. math.random(1000, 9999)
                            local name = juice.prompt("Username for leaderboards:", new_username)
                            if name == nil or name == "" then
                                name = new_username
                            end
                            playfab.set_display_name(name, function(name_result, name_body)
                                if name_result then
                                    juice.info("Set username: " .. name)
                                end
                            end)
                        end
                    else
                        juice.warn("Failed to get player profile.")
                    end
                end)
            end
        end)
    end
end

function update(delta)
    time = time + delta
    entity.ui_element.dimensions.x = 200 + 5 + math.sin(math.pi * 2 * time) * 5
    entity.ui_element.dimensions.y = 32 + 5 + math.sin(math.pi * 2 * time) * 5

    if juice.input.is_key_pressed("space") then
        find_entity("button_play").ui_panel.color = juice.color.new(1, 1, 1, 1)

        juice.routine.create(function()
            find_entity("crt_on_off_effect").scripts.crt_on_off_effect.turn_off()
            juice.routine.wait_seconds(1.0)
            load_scene("scenes/main.jbscene")
        end)
    end
end