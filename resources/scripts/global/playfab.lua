local json = require("scripts/external/json")
playfab = {}

playfab.signed_in = false

function playfab.init(title_id)
    playfab.title_id = title_id
    juice.info("[Playfab] Setup Playfab with Title ID: " .. title_id)
end

function playfab.make_request(operation, request_body, callback)
    local url = string.format("https://%s.playfabapi.com/Client/%s", playfab.title_id, operation)
    local headers = {}
    headers["Content-Type"] = "application/json"

    -- Add session ticket if available.
    if playfab.session_ticket ~= nil then
        headers["X-Authorization"] = playfab.session_ticket
    end

    juice.trace("Sending request: " .. url)

    local request_result = juice.http.request(url, json.encode(request_body), headers, function(result, response)
        if result then
            juice.trace(string.format("[Playfab] response: %s", response))
            local body = json.decode(response)
            
            callback(true, body.data)
        else
            juice.error("[Playfab] request failed!")
            callback(false, nil)
        end
    end)

    if not request_result then
        juice.error("[Playfab] Cannot send Playfab http request!")
        callback(false, nil)
    end
end

---Sign in with custom ID.
---@param id string
---@param callback fun(result: boolean, data: table)
function playfab.sign_in(id, callback)
    local body = {
        TitleId = playfab.title_id,
        CreateAccount = "true",
        CustomId = id
    }
    playfab.make_request("LoginWithCustomID", body, function(result, data)
        if result then
            playfab.signed_in = true
            playfab.playfab_id = data.PlayFabId
            playfab.session_ticket = data.SessionTicket
        end
        callback(result, body)
    end)
end

---Set the display name of signed in user.
---@param name string
---@param callback fun(result: boolean, data: table)
function playfab.set_display_name(name, callback)
    if not playfab.signed_in then
        juice.warn("[Playfab] Not signed in, cannot set name.")
        return
    end

    local body = {
        DisplayName = name
    }

    playfab.make_request("UpdateUserTitleDisplayName", body, callback)
end

---Get player profile of signed in player.
---@param callback fun(result: boolean, data: table)
function playfab.get_player_profile(callback)
    if not playfab.signed_in then
        juice.warn("[Playfab] Not signed in, cannot get player profile.")
        return
    end

    local body = {
        PlayFabId = playfab.playfab_id
    }

    playfab.make_request("GetPlayerProfile", body, callback)
end

---Get all title data. Needs signed in player.
---@param callback fun(result: boolean, data: table)
function playfab.get_title_data(callback)
    if not playfab.signed_in then
        juice.warn("[Playfab] Not signed in, cannot get title data.")
        return
    end

    playfab.make_request("GetTitleData", {}, callback)
end

---Update given player statistics
---@param statistics table Table with stats to update. Key is the stat name, Value is the stat value.
---@param callback fun(result: boolean, data: table)
function playfab.update_player_statistics(statistics, callback)
    if not playfab.signed_in then
        juice.warn("[Playfab] Not signed in, cannot update statistics.")
        return
    end

    local stats = {}
    stats.Statistics = {}
    for stat, val in pairs(statistics) do
        table.insert(stats.Statistics, { StatisticName = stat, Value = val})
    end

    playfab.make_request("UpdatePlayerStatistics", stats, callback)
end

function playfab.get_leaderboard(leaderboard, start_pos, amount, callback)
    if not playfab.signed_in then
        juice.warn("[Playfab] Not signed in, cannot get leaderboard.")
        return
    end

    local body = {
        StatisticName = leaderboard,
        StartPosition = start_pos or 0,
        MaxResultsCount = amount or 10
    }

    playfab.make_request("GetLeaderboard", body, callback)
end

return playfab