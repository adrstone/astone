--// CONFIG
if not _G.Config then
    _G.Config = {
        TargetPlayer = nil,
        PetNames = {}
    }
end

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- lấy target từ config
local targetPlayer = nil
if _G.Config.TargetPlayer then
    targetPlayer = game.Players:FindFirstChild(_G.Config.TargetPlayer)
end

if not targetPlayer then
    warn("⚠️ Target player is not online or not set in config")
    return
end

-- lấy danh sách pet từ config
local petNames = _G.Config.PetNames or {}
local pets = {}

for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") then
        for _, name in ipairs(petNames) do
            if string.find(tool.Name, name) then
                table.insert(pets, tool)
                break
            end
        end
    end
end

if #pets == 0 then
    print("⚠️ No pets found in Backpack")
    return
end

print("✅ Number of pets available for trade: " .. #pets)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = player:WaitForChild("PlayerGui")
local BackpackGui = PlayerGui:WaitForChild("BackpackGui").Backpack
local hotbar = BackpackGui:WaitForChild("Hotbar")
local inventory = BackpackGui:WaitForChild("Inventory")

local favEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item")

local function openInventory()
    local invBtn = BackpackGui:FindFirstChild("InventoryButton") or BackpackGui:FindFirstChild("OpenInventory")
    if invBtn and invBtn:IsA("ImageButton") then
        firesignal(invBtn.MouseButton1Click)
        task.wait(0.5)
    else
        inventory.Visible = true
    end
end

local function isFavorite(toolName)
    for _, slot in ipairs(hotbar:GetChildren()) do
        if slot:FindFirstChild("ToolName") and slot.ToolName.Text == toolName then
            if slot:FindFirstChild("FavIcon") and slot.FavIcon.Visible then
                return true
            end
        end
    end
    local uiGrid = inventory:WaitForChild("ScrollingFrame"):WaitForChild("UIGridFrame")
    for _, slot in ipairs(uiGrid:GetChildren()) do
        if slot:FindFirstChild("ToolName") and slot.ToolName.Text == toolName then
            if slot:FindFirstChild("FavIcon") and slot.FavIcon.Visible then
                return true
            end
        end
    end
    return false
end

local function checkAndUnfavHeldTool()
    local heldTool = char:FindFirstChildOfClass("Tool")
    if heldTool then
        openInventory()
        if isFavorite(heldTool.Name) then
            print("Currently holding " .. heldTool.Name .. " and it is Favorite → unfavoriting...")
            favEvent:FireServer(heldTool)
            task.wait(0.3)
        else
            print("Currently holding " .. heldTool.Name .. " but it is NOT favorite")
        end
    else
        print("Not holding any tool")
    end
end

for i, petTool in ipairs(pets) do
    humanoid:EquipTool(petTool)
    task.wait(0.5)
    checkAndUnfavHeldTool()
    local args = {"GivePet", targetPlayer}
    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetGiftingService"):FireServer(unpack(args))
    print("Sent pet " .. i .. ": " .. petTool.Name)
    task.wait(0.5)
end
