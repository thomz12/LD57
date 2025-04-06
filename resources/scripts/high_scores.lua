local high_scores_btn
local height = 341
local lb_entries = {}

open = false
loaded = false
loading = false

local function uuid()
    math.randomseed(os.time())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function start()
    high_scores_btn = entity:find_child("button_highscores")
    high_scores_btn.ui_element.on_mouse_enter = btn_mouse_enter
    high_scores_btn.ui_element.on_mouse_exit = btn_mouse_exit
    high_scores_btn.ui_element.on_mouse_stay = btn_mouse_stay
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
                            local new_username = names[math.random(#names)] .. " " .. math.random(1000, 9999)
                            local name = juice.prompt("Username for leaderboards:", new_username)
                            if name == nil or name == "" then
                                name = new_username
                            end
                            playfab.set_display_name(name, function(name_result, name_body)
                                if name_result then
                                    juice.info("Set username: " .. name)
                                    playfab.user_name = name
                                    show()
                                end
                            end)
                        else
                            playfab.user_name = get_profile_body.PlayerProfile.DisplayName
                            show()
                        end
                    else
                        juice.warn("Failed to get player profile.")
                    end
                end)
            end
        end)
    else
        show()
    end
end

function btn_mouse_enter()
    high_scores_btn.ui_panel.color = juice.color.new(.5, .5, .5, 1)
end

function btn_mouse_exit()
    high_scores_btn.ui_panel.color = juice.color.new(1, 1, 1, 1)
end

function btn_mouse_stay()
    if juice.input.is_key_pressed("mouse_left") then
        if not open then
            open = true
            entity:find_child("scores_button_text").ui_text.text = "Hide Global Highscores"
            juice.routine.create(function()
                juice.routine.wait_seconds_func(0.5, function(x)
                    entity.ui_element.dimensions.y = 64 + x * height
                end)
            end)
            if not loaded then
                loading = true
                playfab.get_leaderboard("finish_time", 0, 10, function(get_hs_result, get_hs_body)
                    loading = false
                    if get_hs_result then
                        loaded = true
                        local leaderboard = get_hs_body.Leaderboard
                        for i, lb_entry in ipairs(leaderboard) do
                            local entry = spawn("prefabs/highscore_entry.jbprefab")

                            local time = 86400 - lb_entry.StatValue
                            local minutes = math.floor(time / 60)
                            local seconds = math.floor(time % 60)

                            entry:set_parent(entity)
                            entry.ui_element.offset.y = entry.ui_element.offset.y - 34 * (i - 1)
                            entry:find_child("text_place").ui_text.text = tostring(lb_entry.Position + 1)
                            entry:find_child("text_name").ui_text.text = lb_entry.DisplayName
                            entry:find_child("text_time").ui_text.text = string.format("%02.f:%02.f", minutes, seconds)

                            if lb_entry.Position == 0 then
                                entry.ui_panel.color = juice.color.new(241 / 255, 229 / 255, 55 / 255, 1.0)
                            elseif lb_entry.Position == 1 then
                                entry.ui_panel.color = juice.color.new(214 / 255, 214 / 255, 214 / 255, 1.0)
                            elseif lb_entry.Position == 2 then
                                entry.ui_panel.color = juice.color.new(184 / 255, 151 / 255, 81 / 255, 1.0)
                            end

                            table.insert(lb_entries, entry)
                        end
                    end
                end)
            else
                for _, entry in ipairs(lb_entries) do
                    entry.ui_element.enabled = true
                end
            end
        else
            open = false
            entity:find_child("scores_button_text").ui_text.text = "Show Global Highscores"

            for _, entry in ipairs(lb_entries) do
                entry.ui_element.enabled = false
            end

            juice.routine.create(function()
                juice.routine.wait_seconds_func(0.5, function(x)
                    entity.ui_element.dimensions.y = 64 + (1.0 - x) * height
                end)
            end)
        end
    end
end

function show()
    entity:find_child("name_text").ui_text.text = "Welcome, " .. playfab.user_name
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.5, function(x)
            entity.ui_element.pivot.y = 1.0 - x
        end)
    end)
end

function hide()
    juice.routine.create(function()
        juice.routine.wait_seconds_func(0.5, function(x)
            entity.ui_element.pivot.y = x
        end)
    end)
end