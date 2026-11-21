-- MENÚ .EXE - Script por Sam
-- Ejecutar en LocalScript o Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Variables de estado
local noclipEnabled = false
local espEnabled = false
local godModeEnabled = false
local espObjects = {}

-- ==================== INTERFAZ ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuEXE"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

-- Marco principal futurista
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 210)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Título "Menú .exe"
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
TitleBar.BackgroundTransparency = 0.7
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Menú .exe"
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Botón minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 140)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.Parent = TitleBar

-- Contenedor de botones
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Función para crear botones
local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 220, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 100, 150)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    return btn
end

-- ==================== BOTONES ====================
local noclipBtn = createButton("Noclip: OFF", 1)
local espBtn = createButton("ESP (Borde rojo): OFF", 2)
local godBtn = createButton("God Mode (Forcefield): OFF", 3)

-- ==================== LÓGICA DE FUNCIONES ====================

-- 1. NOCLIP
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 80, 50) or Color3.fromRGB(20, 30, 45)
end
noclipBtn.MouseButton1Click:Connect(toggleNoclip)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 2. ESP (solo borde del personaje, rojo)
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local char = targetPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if char:FindFirstChild("MenuESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MenuESP"
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local sel = Instance.new("SelectionBox")
    sel.Name = "MenuESPFallback"
    sel.Adornee = char
    sel.Color3 = Color3.fromRGB(255, 0, 0)
    sel.LineThickness = 0.05
    sel.SurfaceTransparency = 1
    sel.Parent = char

    table.insert(espObjects, highlight)
    table.insert(espObjects, sel)
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local a = p.Character:FindFirstChild("MenuESP")
            local b = p.Character:FindFirstChild("MenuESPFallback")
            if a then a:Destroy() end
            if b then b:Destroy() end
        end
    end
end

local function refreshESP()
    clearESP()
    if not espEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        createESP(p)
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    espBtn.Text = "ESP (Borde rojo): " .. (espEnabled and "ON" or "OFF")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 80, 50) or Color3.fromRGB(20, 30, 45)
    refreshESP()
end
espBtn.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        task.wait(1)
        createESP(p)
    end
end)

local function hookCharAdded(p)
    p.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            refreshESP()
        end
    end)
end
for _, p in pairs(Players:GetPlayers()) do hookCharAdded(p) end
Players.PlayerAdded:Connect(hookCharAdded)

player.CharacterAdded:Connect(function()
    if espEnabled then task.wait(1) refreshESP() end
    if godModeEnabled then
        task.wait(1)
        local char = player.Character
        if char then
            local ff = Instance.new("ForceField")
            ff.Visible = true
            ff.Parent = char
        end
    end
end)

-- 3. GOD MODE (Forcefield)
local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    godBtn.Text = "God Mode (Forcefield): " .. (godModeEnabled and "ON" or "OFF")
    godBtn.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0, 80, 50) or Color3.fromRGB(20, 30, 45)
    
    if godModeEnabled and player.Character then
        local existing = player.Character:FindFirstChildOfClass("ForceField")
        if not existing then
            local ff = Instance.new("ForceField")
            ff.Visible = true
            ff.Parent = player.Character
        end
    end
end
godBtn.MouseButton1Click:Connect(toggleGodMode)

-- ==================== MINIMIZAR / TUERCA ====================
local GearBtn = Instance.new("TextButton")
GearBtn.Name = "GearButton"
GearBtn.Size = UDim2.new(0, 50, 0, 50)
GearBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
GearBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
GearBtn.BackgroundTransparency = 0.4
GearBtn.Text = "⚙"
GearBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
GearBtn.Font = Enum.Font.GothamBold
GearBtn.TextSize = 28
GearBtn.Visible = false
GearBtn.Active = true
GearBtn.Draggable = true
GearBtn.Parent = ScreenGui

local GearCorner = Instance.new("UICorner")
GearCorner.CornerRadius = UDim.new(1, 0)
GearCorner.Parent = GearBtn

local GearStroke = Instance.new("UIStroke")
GearStroke.Color = Color3.fromRGB(0, 200, 255)
GearStroke.Thickness = 1.5
GearStroke.Transparency = 0.3
GearStroke.Parent = GearBtn

MinBtn.MouseButton1Click:Connect(function()
    GearBtn.Position = MainFrame.Position
    MainFrame.Visible = false
    GearBtn.Visible = true
end)

GearBtn.MouseButton1Click:Connect(function()
    MainFrame.Position = GearBtn.Position
    GearBtn.Visible = false
    MainFrame.Visible = true
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

print("✅ Menú .exe cargado. Click TP eliminado, menú ajustado.")
