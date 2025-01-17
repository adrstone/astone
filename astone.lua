local ReplicatedStorage = game:GetService("ReplicatedStorage")
local chooseTeamEvent = Instance.new("RemoteEvent", ReplicatedStorage)
chooseTeamEvent.Name = "ChooseTeamEvent"

chooseTeamEvent.OnServerEvent:Connect(function(player, team)
    if team == "Pirates" then
        player.Team = game.Teams.Pirates
        player:LoadCharacter()
    elseif team == "Marines" then
        player.Team = game.Teams.Marines
        player:LoadCharacter()
    end
end)
