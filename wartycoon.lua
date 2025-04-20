-- This script provides a simple ESP (Extra Sensory Perception) effect by highlighting players.

local function highlightPlayer(player)
    if player.Character and player ~= game.Players.LocalPlayer then
        local h = Instance.new("Highlight")
        h.Parent = player.Character
        h.FillColor = Color3.new(1, 0, 0)
        h.OutlineColor = Color3.new(0, 0, 1)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Name = "PlayerHighlightFill"
    end
end

local function removeHighlight(player)
    if player.Character then
        local h = player.Character:FindFirstChild("PlayerHighlightFill")
        if h then
            h:Destroy()
        end
    end
end

for _, p in pairs(game.Players:GetPlayers()) do
    highlightPlayer(p)
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        wait(0.2)
        highlightPlayer(p)
    end)
end)

game.Players.PlayerRemoving:Connect(removeHighlight)

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        removeHighlight(p)
        wait(0.2)
        highlightPlayer(p)
    end)
end)
