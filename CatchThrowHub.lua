local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local LOOTLABS_URL = "https://lootlabs.gg/cat/YOURLINK"
local LINKVERTISE_URL = "https://linkvertise.com/YOURLINK"
local API_URL = "https://YOUR-RAILWAY-APP.railway.app"
local SAVE_FILE = "CTH_Key.txt"

local VP = workspace.CurrentCamera.ViewportSize
local TOUCH = UserInputService.TouchEnabled
local KEYBOARD = UserInputService.KeyboardEnabled
local MOBILE = TOUCH and not KEYBOARD or VP.X < 700

local function tw(i, p, t, s, d)
    TweenService:Create(i, TweenInfo.new(t or 0.25, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p):Play()
end

local function loadSavedKey()
    local ok, v = pcall(readfile, SAVE_FILE)
    return ok and v and v:match("^%s*(.-)%s*$") or nil
end

local function saveKey(k)
    pcall(writefile, SAVE_FILE, k)
end

local function verifyKeyAPI(key)
    local ok, res = pcall(function()
        return game:HttpGet(API_URL .. "/verify?key=" .. key)
    end)
    if not ok or not res then return false end
    return res:find('"valid":true') ~= nil
end

local function buildUI(onSuccess)
    local oldUI = game.CoreGui:FindFirstChild("CTH_Key") or LP.PlayerGui:FindFirstChild("CTH_Key")
    if oldUI then oldUI:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "CTH_Key"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999
    sg.Parent = pcall(function() return game.CoreGui end) and game.CoreGui or LP.PlayerGui

    local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    blur.Size = 0
    tw(blur, {Size = 18}, 0.5)

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(4, 6, 14)
    bg.BackgroundTransparency = 0.18
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = sg

    local PANEL_W = MOBILE and math.min(VP.X * 0.94, 420) or 460
    local BTN_H = MOBILE and 52 or 44
    local TXT_SM = MOBILE and 13 or 11
    local TXT_MD = MOBILE and 14 or 13
    local TXT_LG = MOBILE and 24 or 22
    local PAD = MOBILE and 18 or 16
    local SPACING = MOBILE and 14 or 10

    local TOTAL_H = PAD
        + 14 + SPACING
        + TXT_LG + SPACING
        + 18 + SPACING
        + 1 + SPACING
        + 14 + 6
        + BTN_H + SPACING
        + 34 + SPACING
        + BTN_H + SPACING
        + BTN_H + SPACING
        + 18 + SPACING
        + 16 + PAD

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, PANEL_W, 0, TOTAL_H)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.BackgroundColor3 = Color3.fromRGB(9, 13, 28)
    panel.BorderSizePixel = 0
    panel.ZIndex = 10
    panel.ClipsDescendants = true
    panel.Parent = sg
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, MOBILE and 16 or 14)

    panel.BackgroundTransparency = 1
    panel.Position = UDim2.new(0.5, 0, 0.6, 0)
    tw(panel, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(26, 37, 64)
    stroke.Thickness = 1
    stroke.Parent = panel

    task.spawn(function()
        local t = 0
        while panel.Parent do
            t += 0.02
            local a = (math.sin(t) + 1) / 2
            stroke.Color = Color3.new(
                a * 0 + (1 - a) * (26/255),
                a * (200/255) + (1 - a) * (37/255),
                a * (255/255) + (1 - a) * (64/255)
            )
            stroke.Thickness = 1 + a * 0.6
            task.wait(0.05)
        end
    end)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 2)
    topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 11
    topBar.Parent = panel
    local tg = Instance.new("UIGradient", topBar)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 60, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 180)),
    })
    task.spawn(function()
        local off = 0
        while topBar.Parent do
            off = (off + 0.006) % 1
            tg.Offset = Vector2.new(off * 2 - 1, 0)
            task.wait(0.03)
        end
    end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -2)
    scrollFrame.Position = UDim2.new(0, 0, 0, 2)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = MOBILE and 3 or 0
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, TOTAL_H + 20)
    scrollFrame.ScrollingEnabled = true
    scrollFrame.ZIndex = 11
    scrollFrame.Parent = panel

    local Y = PAD

    local function lbl(txt, tsize, color, font, xalign)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -PAD * 2, 0, tsize + 4)
        l.Position = UDim2.new(0, PAD, 0, Y)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = color or Color3.fromRGB(240, 244, 255)
        l.Font = font or Enum.Font.GothamBold
        l.TextSize = tsize
        l.TextXAlignment = xalign or Enum.TextXAlignment.Left
        l.TextWrapped = true
        l.ZIndex = 12
        l.Parent = scrollFrame
        return l
    end

    lbl("⚡ CATCH & THROW HUB", TXT_SM, Color3.fromRGB(0, 200, 255), Enum.Font.GothamBlack)
    Y += TXT_SM + SPACING

    lbl("Access Required", TXT_LG, Color3.fromRGB(240, 244, 255), Enum.Font.GothamBlack)
    Y += TXT_LG + SPACING

    lbl("Enter your key or get one free below.", TXT_SM, Color3.fromRGB(106, 127, 168), Enum.Font.Gotham)
    Y += TXT_SM + SPACING

    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -PAD * 2, 0, 1)
    div.Position = UDim2.new(0, PAD, 0, Y)
    div.BackgroundColor3 = Color3.fromRGB(26, 37, 64)
    div.BorderSizePixel = 0
    div.ZIndex = 12
    div.Parent = scrollFrame
    Y += 1 + SPACING

    lbl("YOUR KEY", TXT_SM - 2, Color3.fromRGB(106, 127, 168), Enum.Font.GothamBold)
    Y += (TXT_SM - 2) + 6

    local inputBG = Instance.new("Frame")
    inputBG.Size = UDim2.new(1, -PAD * 2, 0, BTN_H)
    inputBG.Position = UDim2.new(0, PAD, 0, Y)
    inputBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    inputBG.BorderSizePixel = 0
    inputBG.ZIndex = 12
    inputBG.Parent = scrollFrame
    Instance.new("UICorner", inputBG).CornerRadius = UDim.new(0, 8)
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(26, 37, 64)
    inputStroke.Thickness = 1
    inputStroke.Parent = inputBG

    local keyIcon = Instance.new("TextLabel")
    keyIcon.Size = UDim2.new(0, 36, 1, 0)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Text = "🔑"
    keyIcon.TextSize = MOBILE and 17 or 15
    keyIcon.ZIndex = 13
    keyIcon.Parent = inputBG

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -44, 1, -4)
    keyBox.Position = UDim2.new(0, 38, 0, 2)
    keyBox.BackgroundTransparency = 1
    keyBox.Text = ""
    keyBox.PlaceholderText = "CTH-XXXX-XXXX-XXXX"
    keyBox.PlaceholderColor3 = Color3.fromRGB(55, 75, 105)
    keyBox.TextColor3 = Color3.fromRGB(240, 244, 255)
    keyBox.Font = Enum.Font.GothamBold
    keyBox.TextSize = TXT_MD
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false
    keyBox.ZIndex = 13
    keyBox.Parent = inputBG

    keyBox.Focused:Connect(function()
        tw(inputStroke, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.15)
        if MOBILE then
            local keyboardH = GuiService.KeyboardHeight
            local shift = math.max(0, keyboardH - (VP.Y - (panel.AbsolutePosition.Y + panel.AbsoluteSize.Y)))
            tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift - 20)}, 0.25, Enum.EasingStyle.Quad)
        end
    end)
    keyBox.FocusLost:Connect(function()
        tw(inputStroke, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.15)
        if MOBILE then
            tw(panel, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.25, Enum.EasingStyle.Quad)
        end
    end)

    GuiService:GetPropertyChangedSignal("KeyboardHeight"):Connect(function()
        if not keyBox:IsFocused() then return end
        local keyboardH = GuiService.KeyboardHeight
        local panelBottom = panel.AbsolutePosition.Y + panel.AbsoluteSize.Y
        local shift = math.max(0, panelBottom + keyboardH - VP.Y + 20)
        tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift)}, 0.25, Enum.EasingStyle.Quad)
    end)

    Y += BTN_H + SPACING

    local statusBG = Instance.new("Frame")
    statusBG.Size = UDim2.new(1, -PAD * 2, 0, 34)
    statusBG.Position = UDim2.new(0, PAD, 0, Y)
    statusBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    statusBG.BackgroundTransparency = 0.3
    statusBG.BorderSizePixel = 0
    statusBG.ZIndex = 12
    statusBG.Parent = scrollFrame
    Instance.new("UICorner", statusBG).CornerRadius = UDim.new(0, 7)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 7, 0, 7)
    statusDot.Position = UDim2.new(0, 12, 0.5, -3.5)
    statusDot.BackgroundColor3 = Color3.fromRGB(106, 127, 168)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 13
    statusDot.Parent = statusBG
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusTxt = Instance.new("TextLabel")
    statusTxt.Size = UDim2.new(1, -30, 1, 0)
    statusTxt.Position = UDim2.new(0, 26, 0, 0)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "Waiting for key..."
    statusTxt.TextColor3 = Color3.fromRGB(106, 127, 168)
    statusTxt.Font = Enum.Font.Gotham
    statusTxt.TextSize = TXT_SM
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.TextWrapped = true
    statusTxt.ZIndex = 13
    statusTxt.Parent = statusBG

    local function setStatus(msg, col)
        statusTxt.Text = msg
        statusTxt.TextColor3 = col
        tw(statusDot, {BackgroundColor3 = col}, 0.15)
    end

    Y += 34 + SPACING

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1, -PAD * 2, 0, BTN_H)
    verifyBtn.Position = UDim2.new(0, PAD, 0, Y)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 155, 215)
    verifyBtn.Text = "VERIFY KEY  →"
    verifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    verifyBtn.Font = Enum.Font.GothamBlack
    verifyBtn.TextSize = TXT_MD + 1
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.ZIndex = 12
    verifyBtn.Parent = scrollFrame
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)
    local verifyGrad = Instance.new("UIGradient", verifyBtn)
    verifyGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 185)),
    })
    verifyGrad.Rotation = 90

    verifyBtn.MouseEnter:Connect(function()
        tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}, 0.1)
    end)
    verifyBtn.MouseLeave:Connect(function()
        tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.1)
    end)

    Y += BTN_H + SPACING

    local llBtn = Instance.new("TextButton")
    llBtn.Size = UDim2.new(0.475, 0, 0, BTN_H)
    llBtn.Position = UDim2.new(0, PAD, 0, Y)
    llBtn.BackgroundColor3 = Color3.fromRGB(8, 14, 32)
    llBtn.Text = "🔗  Lootlabs"
    llBtn.TextColor3 = Color3.fromRGB(220, 235, 255)
    llBtn.Font = Enum.Font.GothamBold
    llBtn.TextSize = TXT_MD - 1
    llBtn.BorderSizePixel = 0
    llBtn.AutoButtonColor = false
    llBtn.ZIndex = 12
    llBtn.Parent = scrollFrame
    Instance.new("UICorner", llBtn).CornerRadius = UDim.new(0, 8)
    local llStroke = Instance.new("UIStroke")
    llStroke.Color = Color3.fromRGB(26, 37, 64)
    llStroke.Thickness = 1
    llStroke.Parent = llBtn

    local lvBtn = Instance.new("TextButton")
    lvBtn.Size = UDim2.new(0.475, 0, 0, BTN_H)
    lvBtn.Position = UDim2.new(0.525, 0, 0, Y)
    lvBtn.BackgroundColor3 = Color3.fromRGB(8, 14, 32)
    lvBtn.Text = "🔗  Linkvertise"
    lvBtn.TextColor3 = Color3.fromRGB(220, 235, 255)
    lvBtn.Font = Enum.Font.GothamBold
    lvBtn.TextSize = TXT_MD - 1
    lvBtn.BorderSizePixel = 0
    lvBtn.AutoButtonColor = false
    lvBtn.ZIndex = 12
    lvBtn.Parent = scrollFrame
    Instance.new("UICorner", lvBtn).CornerRadius = UDim.new(0, 8)
    local lvStroke = Instance.new("UIStroke")
    lvStroke.Color = Color3.fromRGB(26, 37, 64)
    lvStroke.Thickness = 1
    lvStroke.Parent = lvBtn

    for _, data in pairs({{llBtn, llStroke}, {lvBtn, lvStroke}}) do
        local btn, str = data[1], data[2]
        btn.MouseEnter:Connect(function()
            tw(str, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.1)
            tw(btn, {BackgroundColor3 = Color3.fromRGB(0, 22, 50)}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            tw(str, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.1)
            tw(btn, {BackgroundColor3 = Color3.fromRGB(8, 14, 32)}, 0.1)
        end)
    end

    if MOBILE then
        llBtn.TouchLongPress:Connect(function() end)
        lvBtn.TouchLongPress:Connect(function() end)
    end

    Y += BTN_H + SPACING

    local saveTxt = Instance.new("TextLabel")
    saveTxt.Size = UDim2.new(1, -PAD * 2, 0, 18)
    saveTxt.Position = UDim2.new(0, PAD, 0, Y)
    saveTxt.BackgroundTransparency = 1
    saveTxt.Text = "💾  Key saves after first use — no re-entry needed next time."
    saveTxt.TextColor3 = Color3.fromRGB(50, 70, 110)
    saveTxt.Font = Enum.Font.Gotham
    saveTxt.TextSize = TXT_SM - 1
    saveTxt.TextXAlignment = Enum.TextXAlignment.Left
    saveTxt.TextWrapped = true
    saveTxt.ZIndex = 12
    saveTxt.Parent = scrollFrame
    Y += 18 + SPACING

    local footerTxt = Instance.new("TextLabel")
    footerTxt.Size = UDim2.new(1, -PAD * 2, 0, 16)
    footerTxt.Position = UDim2.new(0, PAD, 0, Y)
    footerTxt.BackgroundTransparency = 1
    footerTxt.Text = "catchthrowhub.com  •  v2.4.1  •  " .. (MOBILE and "Mobile" or "PC")
    footerTxt.TextColor3 = Color3.fromRGB(30, 45, 80)
    footerTxt.Font = Enum.Font.Gotham
    footerTxt.TextSize = TXT_SM - 2
    footerTxt.TextXAlignment = Enum.TextXAlignment.Left
    footerTxt.ZIndex = 12
    footerTxt.Parent = scrollFrame

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, Y + 16 + PAD)

    if VP.Y < TOTAL_H + 80 then
        panel.Size = UDim2.new(0, PANEL_W, 0, VP.Y * 0.88)
    end

    local function dismiss()
        tw(panel, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.3, Enum.EasingStyle.Quad)
        tw(bg, {BackgroundTransparency = 1}, 0.4)
        tw(blur, {Size = 0}, 0.5)
        task.wait(0.5)
        sg:Destroy()
        blur:Destroy()
    end

    local function doVerify()
        local key = keyBox.Text:match("^%s*(.-)%s*$")
        if key == "" then
            setStatus("Please enter your key first.", Color3.fromRGB(255, 68, 102))
            tw(inputStroke, {Color = Color3.fromRGB(255, 68, 102), Thickness = 1.5}, 0.1)
            task.delay(1.2, function() tw(inputStroke, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.3) end)
            return
        end
        setStatus("Verifying key...", Color3.fromRGB(0, 200, 255))
        verifyBtn.Text = "Checking..."
        verifyBtn.Active = false

        task.spawn(function()
            local valid = verifyKeyAPI(key)
            if valid then
                setStatus("✓ Key verified! Loading hub...", Color3.fromRGB(0, 255, 136))
                tw(inputStroke, {Color = Color3.fromRGB(0, 255, 136)}, 0.15)
                tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 180, 90)}, 0.2)
                verifyBtn.Text = "✓ Verified!"
                saveKey(key)
                task.wait(1.2)
                dismiss()
                onSuccess()
            else
                setStatus("✗ Invalid or expired key. Get a new one below.", Color3.fromRGB(255, 68, 102))
                tw(inputStroke, {Color = Color3.fromRGB(255, 68, 102), Thickness = 1.5}, 0.1)
                task.delay(1.5, function() tw(inputStroke, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.3) end)
                tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(160, 20, 50)}, 0.1)
                task.delay(0.5, function()
                    tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.3)
                    verifyBtn.Text = "VERIFY KEY  →"
                    verifyBtn.Active = true
                end)
            end
        end)
    end

    verifyBtn.MouseButton1Click:Connect(doVerify)
    keyBox.FocusLost:Connect(function(enter) if enter then doVerify() end end)

    llBtn.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_URL)
        setStatus("Lootlabs URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = llBtn.Text
        llBtn.Text = "✓ Copied!"
        task.delay(2, function() if llBtn then llBtn.Text = prev end end)
    end)

    lvBtn.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_URL)
        setStatus("Linkvertise URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = lvBtn.Text
        lvBtn.Text = "✓ Copied!"
        task.delay(2, function() if lvBtn then lvBtn.Text = prev end end)
    end)

    if MOBILE then
        local closeHint = Instance.new("TextLabel")
        closeHint.Size = UDim2.new(1, 0, 0, 24)
        closeHint.Position = UDim2.new(0, 0, 1, 6)
        closeHint.BackgroundTransparency = 1
        closeHint.Text = "Tap outside to dismiss"
        closeHint.TextColor3 = Color3.fromRGB(40, 55, 90)
        closeHint.Font = Enum.Font.Gotham
        closeHint.TextSize = 10
        closeHint.ZIndex = 10
        closeHint.Parent = panel
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local abs = panel.AbsolutePosition
            local sz  = panel.AbsoluteSize
            if pos.X < abs.X or pos.X > abs.X + sz.X
                or pos.Y < abs.Y or pos.Y > abs.Y + sz.Y then
                keyBox:ReleaseFocus()
            end
        end
    end)
end

local function loadHub()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Window = Rayfield:CreateWindow({
        Name          = "Catch & Throw Hub  ⚡",
        Icon          = "crosshair",
        LoadingTitle  = "Catch & Throw Hub",
        LoadingSubtitle = "catchthrowhub.com",
        ShowText      = "⚡ CTH",
        Theme         = "Default",
        ToggleUIKeybind = "RightShift",
        DisableBuildWarnings = true,
        ConfigurationSaving = {Enabled = true, FolderName = "CTH_Hub", FileName = "Config"},
        KeySystem     = false,
    })

    local state = {
        AutoCatch   = false,
        SilentAim   = false,
        ReachBypass = true,
        PlayerESP   = false,
        KnifeESP    = false,
        NoClip      = false,
        InfJump     = false,
        WalkSpeed   = 16,
        CatchRange  = 20,
        AntiAFK     = true,
        AutoThrow   = false,
    }

    local LP2     = game:GetService("Players").LocalPlayer
    local RS      = game:GetService("RunService")
    local UIS2    = game:GetService("UserInputService")
    local Cam2    = workspace.CurrentCamera
    local HLPool  = {}
    local knifeBoxes = {}

    local function Char()  return LP2.Character end
    local function Root()  local c = Char() return c and c:FindFirstChild("HumanoidRootPart") end
    local function Hum()   local c = Char() return c and c:FindFirstChild("Humanoid") end

    local function setHL(key, adornee, fill, outline, ft)
        if not HLPool[key] or not HLPool[key].Parent then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.OutlineTransparency = 0
            hl.Parent = game.CoreGui
            HLPool[key] = hl
        end
        HLPool[key].Adornee          = adornee
        HLPool[key].FillColor        = fill    or Color3.fromRGB(220, 30, 30)
        HLPool[key].OutlineColor     = outline or Color3.fromRGB(255, 255, 255)
        HLPool[key].FillTransparency = ft      or 0.45
    end

    local KNIFE_NAMES = {"knife", "thrownknife", "knifeproj", "projectileknife", "throwknife", "blade"}

    local function getKnives()
        local result = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored then
                local n = obj.Name:lower()
                for _, kn in pairs(KNIFE_NAMES) do
                    if n:find(kn) and not obj:FindFirstAncestorOfClass("Tool") then
                        table.insert(result, obj)
                        break
                    end
                end
            end
        end
        return result
    end

    local function findRemote(kws)
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                for _, kw in pairs(kws) do
                    if n:find(kw) then return r end
                end
            end
        end
        return nil
    end

    local function getNearestAlive()
        local root = Root() if not root then return nil end
        local best, bd = nil, math.huge
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP2 and p.Character then
                local ph = p.Character:FindFirstChild("Humanoid")
                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                if ph and ph.Health > 0 and pr then
                    local d = (pr.Position - root.Position).Magnitude
                    if d < bd then bd = d best = p end
                end
            end
        end
        return best
    end

    local catchRemote, catchRefresh = nil, 0
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.AutoCatch then continue end
            local root = Root() if not root then continue end
            catchRefresh -= 0.05
            if catchRefresh <= 0 then
                catchRemote  = findRemote({"catch", "grab", "pickup"})
                catchRefresh = 5
            end
            for _, knife in pairs(getKnives()) do
                if (knife.Position - root.Position).Magnitude <= state.CatchRange then
                    if catchRemote then
                        pcall(function() catchRemote:FireServer(knife) end)
                    end
                    local pp = knife:FindFirstChildWhichIsA("ProximityPrompt")
                        or (knife.Parent and knife.Parent:FindFirstChildWhichIsA("ProximityPrompt"))
                    if pp then pcall(function() fireproximityprompt(pp) end) end
                end
            end
        end
    end)

    local throwCD = false
    local function doThrow()
        if throwCD then return end
        throwCD = true
        local best = getNearestAlive()
        if not best or not best.Character then throwCD = false return end
        local root   = Root()
        local target = best.Character:FindFirstChild("HumanoidRootPart")
        if not root or not target then throwCD = false return end
        local throwRemote = findRemote({"throw", "fire", "launch"})
        local savedCF = root.CFrame
        task.spawn(function()
            if state.ReachBypass then
                root.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 2.5))
                task.wait(0.05)
            end
            if throwRemote then
                pcall(function() throwRemote:FireServer(target.Position) end)
                pcall(function() throwRemote:FireServer(target) end)
            end
            Cam2.CFrame = CFrame.new(Cam2.CFrame.Position, target.Position)
            if state.ReachBypass then task.wait(0.1) root.CFrame = savedCF end
            task.wait(0.3)
            throwCD = false
        end)
    end

    UIS2.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.T and state.SilentAim then
            doThrow()
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if not state.PlayerESP then
                for k, v in pairs(HLPool) do
                    if tostring(k):sub(1, 4) == "esp_" then v:Destroy() HLPool[k] = nil end
                end
                continue
            end
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= LP2 and p.Character then
                    local ph = p.Character:FindFirstChild("Humanoid")
                    local fill = (ph and ph.Health > 0) and Color3.fromRGB(220, 30, 30) or Color3.fromRGB(80, 80, 80)
                    setHL("esp_" .. p.UserId, p.Character, fill, Color3.fromRGB(255, 255, 255), 0.4)
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            for _, b in pairs(knifeBoxes) do pcall(function() b:Destroy() end) end
            knifeBoxes = {}
            if not state.KnifeESP then continue end
            for _, knife in pairs(getKnives()) do
                local sb = Instance.new("SelectionBox")
                sb.Color3 = Color3.fromRGB(0, 200, 255)
                sb.SurfaceColor3 = Color3.fromRGB(0, 200, 255)
                sb.LineThickness = 0.06
                sb.SurfaceTransparency = 0.7
                sb.Adornee = knife
                sb.Parent = game.CoreGui
                table.insert(knifeBoxes, sb)
            end
        end
    end)

    RS.Heartbeat:Connect(function()
        local c = Char() if not c then return end
        if state.NoClip then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
        local h = Hum()
        if h then h.WalkSpeed = state.WalkSpeed end
    end)

    UIS2.JumpRequest:Connect(function()
        if state.InfJump then
            local h = Hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    LP2.Idled:Connect(function()
        if state.AntiAFK then
            local VU = game:GetService("VirtualUser")
            VU:Button2Down(Vector2.zero, Cam2.CFrame)
            task.wait(1)
            VU:Button2Up(Vector2.zero, Cam2.CFrame)
        end
    end)

    if MOBILE then
        local mobileGui = Instance.new("ScreenGui")
        mobileGui.Name = "CTH_Mobile"
        mobileGui.ResetOnSpawn = false
        mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        mobileGui.DisplayOrder = 50
        mobileGui.IgnoreGuiInset = true
        mobileGui.Parent = LP2.PlayerGui

        local throwBtnFrame = Instance.new("Frame")
        throwBtnFrame.Size = UDim2.new(0, 80, 0, 80)
        throwBtnFrame.Position = UDim2.new(1, -100, 1, -200)
        throwBtnFrame.BackgroundTransparency = 1
        throwBtnFrame.Parent = mobileGui

        local throwBtnBG = Instance.new("Frame")
        throwBtnBG.Size = UDim2.new(1, 0, 1, 0)
        throwBtnBG.BackgroundColor3 = Color3.fromRGB(0, 155, 215)
        throwBtnBG.BackgroundTransparency = 0.2
        throwBtnBG.BorderSizePixel = 0
        throwBtnBG.Parent = throwBtnFrame
        Instance.new("UICorner", throwBtnBG).CornerRadius = UDim.new(1, 0)
        local throwStroke2 = Instance.new("UIStroke")
        throwStroke2.Color = Color3.fromRGB(0, 200, 255)
        throwStroke2.Thickness = 2
        throwStroke2.Parent = throwBtnBG

        local throwBtnTxt = Instance.new("TextLabel")
        throwBtnTxt.Size = UDim2.new(1, 0, 0.5, 0)
        throwBtnTxt.Position = UDim2.new(0, 0, 0.1, 0)
        throwBtnTxt.BackgroundTransparency = 1
        throwBtnTxt.Text = "🔪"
        throwBtnTxt.TextSize = 26
        throwBtnTxt.Parent = throwBtnBG

        local throwBtnLabel = Instance.new("TextLabel")
        throwBtnLabel.Size = UDim2.new(1, 0, 0.35, 0)
        throwBtnLabel.Position = UDim2.new(0, 0, 0.62, 0)
        throwBtnLabel.BackgroundTransparency = 1
        throwBtnLabel.Text = "THROW"
        throwBtnLabel.TextColor3 = Color3.fromRGB(240, 244, 255)
        throwBtnLabel.Font = Enum.Font.GothamBlack
        throwBtnLabel.TextSize = 10
        throwBtnLabel.Parent = throwBtnBG

        local throwBtn = Instance.new("TextButton")
        throwBtn.Size = UDim2.new(1, 0, 1, 0)
        throwBtn.BackgroundTransparency = 1
        throwBtn.Text = ""
        throwBtn.ZIndex = 2
        throwBtn.Parent = throwBtnFrame

        throwBtn.MouseButton1Click:Connect(function()
            if state.SilentAim then
                doThrow()
                tw(throwBtnBG, {BackgroundColor3 = Color3.fromRGB(0, 220, 100)}, 0.05)
                task.delay(0.2, function() tw(throwBtnBG, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.15) end)
            end
        end)

        local dragStart, dragPos
        throwBtnFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                dragPos = throwBtnFrame.Position
            end
        end)
        throwBtnFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                local delta = input.Position - dragStart
                throwBtnFrame.Position = UDim2.new(
                    dragPos.X.Scale, dragPos.X.Offset + delta.X,
                    dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
                )
            end
        end)
        throwBtnFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = nil
            end
        end)
    end

    local CombatTab = Window:CreateTab("Combat", "crosshair")
    CombatTab:CreateSection("Auto-Catch  —  20Hz Protection")
    CombatTab:CreateToggle({Name="Auto-Catch Knife", CurrentValue=false, Flag="AutoCatch",
        Callback=function(v) state.AutoCatch=v end})
    CombatTab:CreateSlider({Name="Catch Range (studs)", Range={5,50}, Increment=1, CurrentValue=20, Flag="CatchRange",
        Callback=function(v) state.CatchRange=v end})
    CombatTab:CreateSection("Silent Aim + Reach Bypass")
    CombatTab:CreateToggle({Name="Silent Aim " .. (MOBILE and "(Use 🔪 Button)" or "(Press T)"),
        CurrentValue=false, Flag="SilentAim",
        Callback=function(v) state.SilentAim=v end})
    CombatTab:CreateToggle({Name="Reach Bypass (Auto-TP before throw)",
        CurrentValue=true, Flag="ReachBypass",
        Callback=function(v) state.ReachBypass=v end})
    if not MOBILE then
        CombatTab:CreateButton({Name="Throw at Nearest (One Shot)", Callback=doThrow})
    end

    local VisTab = Window:CreateTab("Visuals", "eye")
    VisTab:CreateSection("ESP")
    VisTab:CreateToggle({Name="Player ESP (Red)", CurrentValue=false, Flag="PlayerESP",
        Callback=function(v) state.PlayerESP=v end})
    VisTab:CreateToggle({Name="Knife Zone ESP (Cyan)", CurrentValue=false, Flag="KnifeESP",
        Callback=function(v) state.KnifeESP=v end})
    VisTab:CreateSection("World")
    VisTab:CreateToggle({Name="Full Bright", CurrentValue=false, Flag="FullBright",
        Callback=function(v)
            game:GetService("Lighting").Brightness = v and 10 or 1
            game:GetService("Lighting").ClockTime  = v and 14 or 10
            game:GetService("Lighting").GlobalShadows = not v
            game:GetService("Lighting").Ambient = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
        end})
    VisTab:CreateSlider({Name="FOV", Range={30,140}, Increment=5, CurrentValue=70, Flag="FOV",
        Callback=function(v) Cam2.FieldOfView=v end})

    local PlrTab = Window:CreateTab("Player", "user")
    PlrTab:CreateSection("Movement")
    PlrTab:CreateSlider({Name="Walk Speed", Range={16,300}, Increment=1, CurrentValue=16, Flag="WS",
        Callback=function(v) state.WalkSpeed=v end})
    PlrTab:CreateToggle({Name="Infinite Jump", CurrentValue=false, Flag="IJ",
        Callback=function(v) state.InfJump=v end})
    PlrTab:CreateToggle({Name="No Clip", CurrentValue=false, Flag="NC",
        Callback=function(v) state.NoClip=v end})
    PlrTab:CreateToggle({Name="Low Gravity", CurrentValue=false, Flag="LG",
        Callback=function(v) workspace.Gravity=v and 40 or 196.2 end})
    PlrTab:CreateToggle({Name="Anti AFK", CurrentValue=true, Flag="AFK",
        Callback=function(v) state.AntiAFK=v end})

    local SettingsTab = Window:CreateTab("Settings", "settings")
    SettingsTab:CreateSection("Tools")
    SettingsTab:CreateButton({Name="Dump Remotes to Clipboard", Callback=function()
        local lines = {}
        for _, r in pairs(game:GetDescendants()) do
            if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                table.insert(lines, r.ClassName..": "..r:GetFullName())
            end
        end
        local out = table.concat(lines, "\n")
        pcall(function() writefile("CTH_Remotes.txt", out) end)
        setclipboard(out)
        Rayfield:Notify({Title="Dumped", Content=#lines.." remotes copied", Duration=3, Image="terminal"})
    end})
    SettingsTab:CreateButton({Name="Clear Saved Key", Callback=function()
        pcall(function() delfile(SAVE_FILE) end)
        Rayfield:Notify({Title="Key Cleared", Content="Re-enter on next launch", Duration=3, Image="trash"})
    end})

    SettingsTab:CreateSection("Platform")
    SettingsTab:CreateButton({Name="Platform: " .. (MOBILE and "📱 Mobile" or "🖥️ PC") .. " (detected)", Callback=function()
        Rayfield:Notify({Title="Platform", Content="Running on "..(MOBILE and "Mobile" or "PC").." | Screen: "..VP.X.."x"..VP.Y, Duration=4, Image="info"})
    end})

    Rayfield:LoadConfiguration()
    Rayfield:Notify({
        Title   = "⚡ CTH Hub Loaded!",
        Content = (MOBILE and "📱 Mobile mode — use 🔪 button to throw" or "🖥️ PC mode — Press T to throw") .. "\nRightShift to toggle UI",
        Duration = 6,
        Image   = "crosshair"
    })
end

task.spawn(function()
    local saved = loadSavedKey()
    if saved and verifyKeyAPI(saved) then
        loadHub()
        return
    end
    buildUI(loadHub)
end)
