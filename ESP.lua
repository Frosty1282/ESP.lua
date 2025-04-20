-- This script provides a simple ESP (Extra Sensory Perception) effect by highlighting players.
-- It also adds a transparent red circle around each player and displays their health.

local function highlightPlayer(player)
    if player.Character and player ~= game.Players.LocalPlayer then
        local h = Instance.new("Highlight")
        h.Parent = player.Character
        h.FillColor = Color3.new(1, 0, 0)
        h.OutlineColor = Color3.new(0, 0, 1)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Name = "PlayerHighlightFill"

        -- Create a circle around the player
        local circle = Instance.new("Part")
        circle.Parent = player.Character
        circle.Shape = Enum.PartType.Ball
        circle.Size = Vector3.new(6, 6, 6)
        circle.Position = player.Character:WaitForChild("HumanoidRootPart").Position
        circle.Anchored = false
        circle.CanCollide = false
        circle.Transparency = 0.8
        circle.BrickColor = BrickColor.Red()
        circle.Name = "ESPCircle"

        -- Make the circle follow the player's position
        local function updateCirclePosition()
            if player.Character and circle then
                circle.Position = player.Character:WaitForChild("HumanoidRootPart").Position;
            end
        end

        circle.AssemblyMoved:Connect(updateCirclePosition);
        player.Character:GetPropertyChangedSignal("Position"):Connect(updateCirclePosition);

        -- Add a BillboardGui to display health
        local healthGui = Instance.new("BillboardGui")
        healthGui.Parent = player.Character:WaitForChild("Head")
        healthGui.Size = UDim2.new(3, 0, 1, 0)  -- Adjust size as needed
        healthGui.StudOffset = Vector3.new(0, 1.5, 0)  -- Position above the head
        healthGui.Name = "HealthGui"

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Parent = healthGui
        healthLabel.Text = "100/100"
        healthLabel.BackgroundColor3 = Color3.new(0, 0, 0)
        healthLabel.TextColor3 = Color3.new(1, 1, 1)
        healthLabel.TextScaled = true
        healthLabel.Font = Enum.Font.SourceSansBold
        healthLabel.Size = UDim2.new(1, 0, 1, 0)

        -- Function to update health display
        local function updateHealthDisplay()
            if player.Character and healthLabel then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    healthLabel.Text = math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
                end
            end
        end

        -- Update health display initially and when health changes
        updateHealthDisplay()
        player.Character:WaitForChild("Humanoid").HealthChanged:Connect(updateHealthDisplay)
    end
end

local function removeHighlight(player)
    if player.Character then
        local h = player.Character:FindFirstChild("PlayerHighlightFill")
        if h then
            h:Destroy()
        end
        local circle = player.Character:FindFirstChild("ESPCircle")
        if circle then
            circle:Destroy()
        end
        local healthGui = player.Character:FindFirstChild("HealthGui")
        if healthGui then
            healthGui:Destroy()
        end
    end
end

-- Initial application of ESP
for _, p in pairs(game.Players:GetPlayers()) do
    highlightPlayer(p)
end

-- Connect to player events
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
