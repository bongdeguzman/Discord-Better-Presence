local Halakasige = {
    presences = {
        discordid = 123123123123, --Use your own discordid bot
        assetName = 'assetnamehere', --if you don't know how to set it up use https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
        assetText = 'Your Server Name Here',
        assetNameSmall = 'smallassets here if you want' -- same as here
    },
    roleIcons = {
        user = "Player",
        vip = "Donator",
        admin = "Admin",
        owner = "Owner"
    },
    discordButtons = {
        { label = "Join Server", url = "fivem://connect/yourserverip:port" },
        { label = "Discord", url = "https://discord.gg/invitelink" }
    }
}

function Halakasige:updateStatus(key, value)
    if self[key] ~= value then
        self[key] = value
        local richPresenceString = string.format(
            "ID: [%s] Players: %d/%d\n [%s] %s",
            GetPlayerServerId(PlayerId()),
            self.playerCount or GlobalState.playerCount or 0,
            GetConvarInt("sv_maxclients", 128),
            self.fullName or GetPlayerName(PlayerId()),
            self.role or self.roleIcons["user"]
        )
        SetRichPresence(richPresenceString)
    end
end

function Halakasige:initRichPresence(firstName, lastName, group)
    local fullName = string.format("%s %s", firstName, lastName)
    local role = self.roleIcons[group] or self.roleIcons["user"]

    SetDiscordAppId(self.presences.discordid)
    SetDiscordRichPresenceAsset(self.presences.assetName)
    SetDiscordRichPresenceAssetText(self.presences.assetText)
    SetDiscordRichPresenceAssetSmall(self.presences.assetNameSmall)
    SetDiscordRichPresenceAssetSmallText(role)

    self:updateStatus("fullName", fullName)
    self:updateStatus("role", role)

    for i, button in ipairs(self.discordButtons) do
        SetDiscordRichPresenceAction(i - 1, button.label, button.url)
    end

    CreateThread(function()
        while true do
            Wait(60000) --60 second tick cuz who cares? haha
            local playerCount = GlobalState.playerCount or 0
            self:updateStatus("playerCount", playerCount)
        end
    end)
end

AddEventHandler("esx:playerLoaded", function(xPlayer)
    Halakasige:initRichPresence(xPlayer.firstName, xPlayer.lastName, xPlayer.group)
end)
