local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local LOOTLABS_URL = "https://links.lootlabs.gg/s?QN1KyqUN"
local LINKVERTISE_URL = "local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local LOOTLABS_URL = "https://links.lootlabs.gg/s?QN1KyqUN"
local LINKVERTISE_URL = "https://links.lootlabs.gg/s?MsVq5uin"
local API_URL = "https://heroic-light-production-0d34.up.railway.app/"
local SAVE_FILE = "CTH_Key.txt"

local VP = workspace.CurrentCamera.ViewportSize
local TOUCH = UserInputService.TouchEnabled
local KEYBOARD = UserInputService.KeyboardEnabled
local MOBILE = TOUCH and not KEYBOARD or VP.X < 700

local function tw(i, p, t, s)
    TweenService:Create(i, TweenInfo.new(t or 0.25, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play()
end

local function loadSavedKey()
    local ok, v = pcall(readfile, SAVE_FILE)
    return ok and v and v:match("^%s*(.-)%s*$") or nil
end

local function saveKey(k) pcall(writefile, SAVE_FILE, k) end

local function verifyKeyAPI(key)
    local ok, res = pcall(function() return game:HttpGet(API_URL.."/verify?key="..key) end)
    if not ok or not res then return false end
    return res:find('"valid":true') ~= nil
end

local function buildUI(onSuccess)
    local old = game.CoreGui:FindFirstChild("CTH_Key") or LP.PlayerGui:FindFirstChild("CTH_Key")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "CTH_Key"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = LP.PlayerGui end

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

    local PW = MOBILE and math.min(VP.X * 0.92, 420) or 460
    local BH = MOBILE and 52 or 44
    local TS = MOBILE and 13 or 11
    local TM = MOBILE and 15 or 13
    local TL = MOBILE and 24 or 22
    local PD = 18

    local PANEL_H = PD + 16 + 10 + TL + 8 + 16 + 12 + 1 + 12 + 12 + 6 + BH + 10 + 32 + 10 + BH + 10 + BH + 10 + 16 + 8 + 14 + PD

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, PW, 0, PANEL_H)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.6, 0)
    panel.BackgroundColor3 = Color3.fromRGB(9, 13, 28)
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.ZIndex = 10
    panel.Parent = sg
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

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
            stroke.Color = Color3.new(0, a * 0.784, a)
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
        local o = 0
        while topBar.Parent do
            o = (o + 0.006) % 1
            tg.Offset = Vector2.new(o * 2 - 1, 0)
            task.wait(0.03)
        end
    end)

    local Y = PD

    local function mkLabel(txt, tsize, color, font, xalign, h)
        local height = h or (tsize + 4)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -PD * 2, 0, height)
        l.Position = UDim2.new(0, PD, 0, Y)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = color or Color3.fromRGB(240, 244, 255)
        l.Font = font or Enum.Font.GothamBold
        l.TextSize = tsize
        l.TextXAlignment = xalign or Enum.TextXAlignment.Left
        l.TextWrapped = true
        l.ZIndex = 12
        l.Parent = panel
        Y += height
        return l
    end

    local function gap(n) Y += n end

    mkLabel("⚡ CATCH & THROW HUB", TS, Color3.fromRGB(0, 200, 255), Enum.Font.GothamBlack, nil, 16)
    gap(10)
    mkLabel("Access Required", TL, Color3.fromRGB(240, 244, 255), Enum.Font.GothamBlack, nil, TL)
    gap(8)
    mkLabel("Enter your key or get one free below.", TS, Color3.fromRGB(106, 127, 168), Enum.Font.Gotham, nil, 16)
    gap(12)

    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -PD * 2, 0, 1)
    div.Position = UDim2.new(0, PD, 0, Y)
    div.BackgroundColor3 = Color3.fromRGB(26, 37, 64)
    div.BorderSizePixel = 0
    div.ZIndex = 12
    div.Parent = panel
    gap(1 + 12)

    mkLabel("YOUR KEY", TS - 1, Color3.fromRGB(106, 127, 168), Enum.Font.GothamBold, nil, 12)
    gap(6)

    local inputBG = Instance.new("Frame")
    inputBG.Size = UDim2.new(1, -PD * 2, 0, BH)
    inputBG.Position = UDim2.new(0, PD, 0, Y)
    inputBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    inputBG.BorderSizePixel = 0
    inputBG.ZIndex = 12
    inputBG.Parent = panel
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
    keyBox.TextSize = TM
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false
    keyBox.ZIndex = 13
    keyBox.Parent = inputBG

    keyBox.Focused:Connect(function()
        tw(inputStroke, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.15)
        if MOBILE then
            local kh = GuiService.KeyboardHeight
            local bottom = panel.AbsolutePosition.Y + panel.AbsoluteSize.Y
            local shift = math.max(0, bottom + kh - VP.Y + 20)
            tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift)}, 0.25, Enum.EasingStyle.Quad)
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
        local kh = GuiService.KeyboardHeight
        local bottom = panel.AbsolutePosition.Y + panel.AbsoluteSize.Y
        local shift = math.max(0, bottom + kh - VP.Y + 20)
        tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift)}, 0.2, Enum.EasingStyle.Quad)
    end)

    gap(BH + 10)

    local statusBG = Instance.new("Frame")
    statusBG.Size = UDim2.new(1, -PD * 2, 0, 32)
    statusBG.Position = UDim2.new(0, PD, 0, Y)
    statusBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    statusBG.BackgroundTransparency = 0.3
    statusBG.BorderSizePixel = 0
    statusBG.ZIndex = 12
    statusBG.Parent = panel
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
    statusTxt.TextSize = TS
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.TextWrapped = true
    statusTxt.ZIndex = 13
    statusTxt.Parent = statusBG

    local function setStatus(msg, col)
        statusTxt.Text = msg
        statusTxt.TextColor3 = col
        tw(statusDot, {BackgroundColor3 = col}, 0.15)
    end

    gap(32 + 10)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1, -PD * 2, 0, BH)
    verifyBtn.Position = UDim2.new(0, PD, 0, Y)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 155, 215)
    verifyBtn.Text = "VERIFY KEY  →"
    verifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    verifyBtn.Font = Enum.Font.GothamBlack
    verifyBtn.TextSize = TM + 1
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.ZIndex = 12
    verifyBtn.Parent = panel
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)
    local vg = Instance.new("UIGradient", verifyBtn)
    vg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 175, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 185)),
    })
    vg.Rotation = 90
    verifyBtn.MouseEnter:Connect(function() tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}, 0.1) end)
    verifyBtn.MouseLeave:Connect(function() tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.1) end)

    gap(BH + 10)

    local function mkGetKeyBtn(txt, xscale, xoffset)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(xscale, -4, 0, BH)
        b.Position = UDim2.new(xoffset, PD + (xoffset > 0 and 2 or 0), 0, Y)
        b.BackgroundColor3 = Color3.fromRGB(8, 14, 32)
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(220, 235, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = TM - 1
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 12
        b.Parent = panel
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke")
        bs.Color = Color3.fromRGB(26, 37, 64)
        bs.Thickness = 1
        bs.Parent = b
        b.MouseEnter:Connect(function()
            tw(bs, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.1)
            tw(b, {BackgroundColor3 = Color3.fromRGB(0, 22, 50)}, 0.1)
        end)
        b.MouseLeave:Connect(function()
            tw(bs, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.1)
            tw(b, {BackgroundColor3 = Color3.fromRGB(8, 14, 32)}, 0.1)
        end)
        return b, bs
    end

    local llBtn = mkGetKeyBtn("🔗  Lootlabs", 0.5, 0)
    local lvBtn = mkGetKeyBtn("🔗  Linkvertise", 0.5, 0.5)
    gap(BH + 10)

    mkLabel("💾  Key saves after first use — no re-entry needed.", TS - 1, Color3.fromRGB(50, 70, 110), Enum.Font.Gotham, nil, 16)
    gap(8)
    mkLabel("catchthrowhub.com  •  v2.4.1  •  "..(MOBILE and "Mobile" or "PC"), TS - 2, Color3.fromRGB(30, 45, 80), Enum.Font.Gotham, nil, 14)

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local abs = panel.AbsolutePosition
            local sz = panel.AbsoluteSize
            if pos.X < abs.X or pos.X > abs.X + sz.X or pos.Y < abs.Y or pos.Y > abs.Y + sz.Y then
                keyBox:ReleaseFocus()
            end
        end
    end)

    local function dismiss()
        tw(panel, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.3, Enum.EasingStyle.Quad)
        tw(bg, {BackgroundTransparency = 1}, 0.4)
        tw(blur, {Size = 0}, 0.5)
        task.wait(0.5)
        sg:Destroy()
        blur:Destroy()
    end

    local verifying = false
    local function doVerify()
        if verifying then return end
        local key = keyBox.Text:match("^%s*(.-)%s*$")
        if key == "" then
            setStatus("Please enter your key first.", Color3.fromRGB(255, 68, 102))
            tw(inputStroke, {Color = Color3.fromRGB(255, 68, 102), Thickness = 1.5}, 0.1)
            task.delay(1.2, function() tw(inputStroke, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.3) end)
            return
        end
        verifying = true
        setStatus("Verifying key...", Color3.fromRGB(0, 200, 255))
        verifyBtn.Text = "Checking..."
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
                tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(150, 20, 45)}, 0.1)
                task.delay(0.5, function()
                    tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.3)
                    verifyBtn.Text = "VERIFY KEY  →"
                    verifying = false
                end)
            end
        end)
    end

    verifyBtn.MouseButton1Click:Connect(doVerify)
    keyBox.FocusLost:Connect(function(enter) if enter then doVerify() end end)

    llBtn.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_URL)
        setStatus("Lootlabs URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = llBtn.Text llBtn.Text = "✓ Copied!"
        task.delay(2, function() if llBtn then llBtn.Text = prev end end)
    end)
    lvBtn.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_URL)
        setStatus("Linkvertise URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = lvBtn.Text lvBtn.Text = "✓ Copied!"
        task.delay(2, function() if lvBtn then lvBtn.Text = prev end end)
    end)
end

local function loadHub()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Window = Rayfield:CreateWindow({
        Name = "Catch & Throw Hub  ⚡",
        Icon = "crosshair",
        LoadingTitle = "Catch & Throw Hub",
        LoadingSubtitle = "catchthrowhub.com",
        ShowText = "⚡ CTH",
        Theme = "Default",
        ToggleUIKeybind = "RightShift",
        DisableBuildWarnings = true,
        ConfigurationSaving = {Enabled = true, FolderName = "CTH_Hub", FileName = "Config"},
        KeySystem = false,
    })

    local state = {
        AutoCatch = false, SilentAim = false, ReachBypass = true,
        AutoWin = false, KillAura = false, KillAuraRange = 25,
        PlayerESP = false, KnifeESP = false,
        NoClip = false, InfJump = false, WalkSpeed = 16,
        AntiAFK = true, CatchRange = 20,
        CoinFarm = false, HitboxExp = false, HitboxSize = 15,
        SpinBot = false, RainbowChar = false, KnifeTele = false,
        AntiDash = false, GodMode = false,
    }

    local LP2 = game:GetService("Players").LocalPlayer
    local UIS2 = game:GetService("UserInputService")
    local Cam2 = workspace.CurrentCamera
    local HLPool = {}
    local knifeBoxes = {}

    local function Char() return LP2.Character end
    local function Root() local c = Char() return c and c:FindFirstChild("HumanoidRootPart") end
    local function Hum()  local c = Char() return c and c:FindFirstChild("Humanoid") end

    local function setHL(key, adornee, fill, outline, ft)
        if not HLPool[key] or not HLPool[key].Parent then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.OutlineTransparency = 0
            hl.Parent = game.CoreGui
            HLPool[key] = hl
        end
        HLPool[key].Adornee = adornee
        HLPool[key].FillColor = fill or Color3.fromRGB(220, 30, 30)
        HLPool[key].OutlineColor = outline or Color3.fromRGB(255, 255, 255)
        HLPool[key].FillTransparency = ft or 0.45
    end

    local KNIFE_NAMES = {"knife","thrownknife","knifeproj","projectileknife","throwknife","blade"}

    local function getKnives()
        local r = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored then
                local n = obj.Name:lower()
                for _, kn in pairs(KNIFE_NAMES) do
                    if n:find(kn) and not obj:FindFirstAncestorOfClass("Tool") then
                        table.insert(r, obj) break
                    end
                end
            end
        end
        return r
    end

    local function findRemote(kws)
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                for _, kw in pairs(kws) do if n:find(kw) then return r end end
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
        return best, bd
    end

    local catchRemote, catchRefresh = nil, 0
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.AutoCatch and not state.AutoWin then continue end
            local root = Root() if not root then continue end
            catchRefresh -= 0.05
            if catchRefresh <= 0 then
                catchRemote = findRemote({"catch","grab","pickup"})
                catchRefresh = 5
            end
            for _, knife in pairs(getKnives()) do
                if (knife.Position - root.Position).Magnitude <= state.CatchRange then
                    if catchRemote then pcall(function() catchRemote:FireServer(knife) end) end
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
        local root = Root()
        local target = best.Character:FindFirstChild("HumanoidRootPart")
        if not root or not target then throwCD = false return end
        local throwRemote = findRemote({"throw","fire","launch"})
        local savedCF = root.CFrame
        task.spawn(function()
            if state.ReachBypass then
                root.CFrame = CFrame.new(target.Position + Vector3.new(0,0,2.5))
                task.wait(0.05)
            end
            if throwRemote then
                pcall(function() throwRemote:FireServer(target.Position) end)
                pcall(function() throwRemote:FireServer(target) end)
            end
            Cam2.CFrame = CFrame.new(Cam2.CFrame.Position, target.Position)
            if state.ReachBypass then task.wait(0.1) root.CFrame = savedCF end
            task.wait(0.25)
            throwCD = false
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.4)
            if state.AutoWin then doThrow() end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.15)
            if not state.KillAura then continue end
            local best, bd = getNearestAlive()
            if best and bd <= state.KillAuraRange then doThrow() end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.KnifeTele then
                local root = Root()
                local knives = getKnives()
                if root and #knives > 0 then
                    local best, bd = nil, math.huge
                    for _, k in pairs(knives) do
                        local d = (k.Position - root.Position).Magnitude
                        if d < bd then bd = d best = k end
                    end
                    if best then root.CFrame = CFrame.new(best.Position + Vector3.new(0,3,0)) end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if state.CoinFarm then
                local root = Root()
                if root then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        local n = obj.Name:lower()
                        if (n:find("coin") or n:find("gold") or n:find("token")) and obj:IsA("BasePart") then
                            root.CFrame = CFrame.new(obj.Position)
                            task.wait(0.04)
                            local pp = obj:FindFirstChildWhichIsA("ProximityPrompt")
                            if pp then pcall(function() fireproximityprompt(pp) end) end
                        end
                    end
                    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local rn = remote.Name:lower()
                            if rn:find("coin") or rn:find("collect") or rn:find("reward") then
                                pcall(function() remote:FireServer() end)
                                task.wait(0.02)
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if not state.PlayerESP then
                for k, v in pairs(HLPool) do
                    if tostring(k):sub(1,4) == "esp_" then v:Destroy() HLPool[k] = nil end
                end
                continue
            end
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= LP2 and p.Character then
                    local ph = p.Character:FindFirstChild("Humanoid")
                    local fill = (ph and ph.Health > 0) and Color3.fromRGB(220,30,30) or Color3.fromRGB(80,80,80)
                    setHL("esp_"..p.UserId, p.Character, fill, Color3.fromRGB(255,255,255), 0.4)
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
                sb.Color3 = Color3.fromRGB(0,200,255)
                sb.SurfaceColor3 = Color3.fromRGB(0,200,255)
                sb.LineThickness = 0.06
                sb.SurfaceTransparency = 0.7
                sb.Adornee = knife
                sb.Parent = game.CoreGui
                table.insert(knifeBoxes, sb)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.HitboxExp then
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= LP2 and p.Character then
                        local pr = p.Character:FindFirstChild("HumanoidRootPart")
                        if pr then
                            pr.Size = Vector3.new(state.HitboxSize, state.HitboxSize, state.HitboxSize)
                            pr.Transparency = 0.9
                        end
                    end
                end
            end
        end
    end)

    local spinAngle = 0
    local rainbowHue = 0
    RunService.Heartbeat:Connect(function()
        local c = Char() if not c then return end
        if state.NoClip then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
        if state.GodMode then
            local h = Hum() if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end
        if state.SpinBot then
            local r = Root()
            if r then
                spinAngle = spinAngle + 8
                r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end
        if state.RainbowChar then
            rainbowHue = (rainbowHue + 0.008) % 1
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.BrickColor = BrickColor.new(Color3.fromHSV(rainbowHue, 1, 1))
                end
            end
        end
        local h = Hum()
        if h then h.WalkSpeed = state.WalkSpeed end
        if state.AntiDash then
            if h then h.WalkSpeed = math.max(h.WalkSpeed, state.WalkSpeed) end
        end
    end)

    UIS2.JumpRequest:Connect(function()
        if state.InfJump then
            local h = Hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    UIS2.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.T and state.SilentAim then doThrow() end
    end)

    LP2.Idled:Connect(function()
        if state.AntiAFK then
            local VU = game:GetService("VirtualUser")
            VU:Button2Down(Vector2.zero, Cam2.CFrame) task.wait(1) VU:Button2Up(Vector2.zero, Cam2.CFrame)
        end
    end)

    if MOBILE then
        local mg = Instance.new("ScreenGui")
        mg.Name = "CTH_Mobile" mg.ResetOnSpawn = false mg.ZIndexBehavior = Enum.ZIndexBehavior.Global
        mg.DisplayOrder = 50 mg.IgnoreGuiInset = true mg.Parent = LP2.PlayerGui

        local tbf = Instance.new("Frame")
        tbf.Size = UDim2.new(0, 78, 0, 78)
        tbf.Position = UDim2.new(1, -96, 1, -200)
        tbf.BackgroundTransparency = 1
        tbf.Parent = mg

        local tbb = Instance.new("Frame")
        tbb.Size = UDim2.new(1,0,1,0)
        tbb.BackgroundColor3 = Color3.fromRGB(0,155,215)
        tbb.BackgroundTransparency = 0.2
        tbb.BorderSizePixel = 0
        tbb.Parent = tbf
        Instance.new("UICorner", tbb).CornerRadius = UDim.new(1,0)
        local ts2 = Instance.new("UIStroke") ts2.Color = Color3.fromRGB(0,200,255) ts2.Thickness = 2 ts2.Parent = tbb

        local tIcon = Instance.new("TextLabel")
        tIcon.Size = UDim2.new(1,0,0.5,0) tIcon.Position = UDim2.new(0,0,0.08,0)
        tIcon.BackgroundTransparency = 1 tIcon.Text = "🔪" tIcon.TextSize = 26 tIcon.Parent = tbb

        local tLbl = Instance.new("TextLabel")
        tLbl.Size = UDim2.new(1,0,0.32,0) tLbl.Position = UDim2.new(0,0,0.62,0)
        tLbl.BackgroundTransparency = 1 tLbl.Text = "THROW"
        tLbl.TextColor3 = Color3.fromRGB(240,244,255) tLbl.Font = Enum.Font.GothamBlack
        tLbl.TextSize = 10 tLbl.Parent = tbb

        local tbtn = Instance.new("TextButton")
        tbtn.Size = UDim2.new(1,0,1,0) tbtn.BackgroundTransparency = 1
        tbtn.Text = "" tbtn.ZIndex = 2 tbtn.Parent = tbf

        tbtn.MouseButton1Click:Connect(function()
            if state.SilentAim then
                doThrow()
                tw(tbb, {BackgroundColor3 = Color3.fromRGB(0,220,100)}, 0.05)
                task.delay(0.2, function() tw(tbb, {BackgroundColor3 = Color3.fromRGB(0,155,215)}, 0.15) end)
            end
        end)

        local dragStart, dragPos
        tbf.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position dragPos = tbf.Position
            end
        end)
        tbf.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                local d = input.Position - dragStart
                tbf.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset+d.X, dragPos.Y.Scale, dragPos.Y.Offset+d.Y)
            end
        end)
        tbf.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then dragStart = nil end
        end)
    end

    local CombatTab = Window:CreateTab("Combat", "crosshair")

    CombatTab:CreateSection("Auto-Catch — 20Hz")
    CombatTab:CreateToggle({Name="Auto-Catch Knife", CurrentValue=false, Flag="AutoCatch",
        Callback=function(v) state.AutoCatch=v end})
    CombatTab:CreateSlider({Name="Catch Range (studs)", Range={5,60}, Increment=1, CurrentValue=20, Flag="CatchRange",
        Callback=function(v) state.CatchRange=v end})

    CombatTab:CreateSection("Throwing")
    CombatTab:CreateToggle({Name="Silent Aim "..(MOBILE and "(🔪 Button)" or "(T Key)"), CurrentValue=false, Flag="SilentAim",
        Callback=function(v) state.SilentAim=v end})
    CombatTab:CreateToggle({Name="Reach Bypass (TP before throw)", CurrentValue=true, Flag="ReachBypass",
        Callback=function(v) state.ReachBypass=v end})
    if not MOBILE then
        CombatTab:CreateButton({Name="Throw at Nearest (One Shot)", Callback=doThrow})
    end

    CombatTab:CreateSection("Auto Win")
    CombatTab:CreateToggle({Name="⚡ AUTO WIN (Catch + Throw Loop)", CurrentValue=false, Flag="AutoWin",
        Callback=function(v)
            state.AutoWin=v
            Rayfield:Notify({Title=v and "Auto Win ON" or "Auto Win OFF",
                Content=v and "Catching and throwing automatically every 0.4s!" or "Disabled",
                Duration=3, Image=v and "zap" or "info"})
        end})

    CombatTab:CreateSection("Kill Aura")
    CombatTab:CreateToggle({Name="Kill Aura (Auto throw when in range)", CurrentValue=false, Flag="KillAura",
        Callback=function(v) state.KillAura=v end})
    CombatTab:CreateSlider({Name="Kill Aura Range", Range={5,80}, Increment=1, CurrentValue=25, Flag="KillAuraRange",
        Callback=function(v) state.KillAuraRange=v end})

    CombatTab:CreateSection("Knife")
    CombatTab:CreateToggle({Name="Knife Teleport (TP to knife location)", CurrentValue=false, Flag="KnifeTele",
        Callback=function(v) state.KnifeTele=v end})

    local VisTab = Window:CreateTab("Visuals", "eye")

    VisTab:CreateSection("ESP")
    VisTab:CreateToggle({Name="Player ESP (Red Highlights)", CurrentValue=false, Flag="PlayerESP",
        Callback=function(v) state.PlayerESP=v end})
    VisTab:CreateToggle({Name="Knife Zone ESP (Cyan)", CurrentValue=false, Flag="KnifeESP",
        Callback=function(v) state.KnifeESP=v end})

    VisTab:CreateSection("Character FX")
    VisTab:CreateToggle({Name="Rainbow Character (FE ✅)", CurrentValue=false, Flag="RainbowChar",
        Callback=function(v) state.RainbowChar=v end})
    VisTab:CreateToggle({Name="Spin Bot (Confuse enemies)", CurrentValue=false, Flag="SpinBot",
        Callback=function(v) state.SpinBot=v end})

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

    PlrTab:CreateSection("Defense")
    PlrTab:CreateToggle({Name="God Mode (Health Regen)", CurrentValue=false, Flag="GodMode",
        Callback=function(v) state.GodMode=v end})
    PlrTab:CreateToggle({Name="Anti Dash (Freeze WalkSpeed)", CurrentValue=false, Flag="AntiDash",
        Callback=function(v) state.AntiDash=v end})
    PlrTab:CreateToggle({Name="Anti AFK", CurrentValue=true, Flag="AFK",
        Callback=function(v) state.AntiAFK=v end})

    PlrTab:CreateSection("Combat Assist")
    PlrTab:CreateToggle({Name="Hitbox Expander (Easier hits)", CurrentValue=false, Flag="HitboxExp",
        Callback=function(v) state.HitboxExp=v end})
    PlrTab:CreateSlider({Name="Hitbox Size", Range={5,50}, Increment=1, CurrentValue=15, Flag="HitboxSize",
        Callback=function(v) state.HitboxSize=v end})

    PlrTab:CreateSection("Farm")
    PlrTab:CreateToggle({Name="💰 Coin Farm (Auto collect coins)", CurrentValue=false, Flag="CoinFarm",
        Callback=function(v)
            state.CoinFarm=v
            Rayfield:Notify({Title=v and "Coin Farm ON" or "Coin Farm OFF",
                Content=v and "Collecting all coins on map!" or "Disabled",
                Duration=3, Image=v and "dollar-sign" or "info"})
        end})

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
        Rayfield:Notify({Title="Remotes Dumped", Content=#lines.." remotes — copied + saved", Duration=4, Image="terminal"})
    end})
    SettingsTab:CreateButton({Name="Copy My Position", Callback=function()
        local r = Root() if not r then return end
        local p = r.Position
        setclipboard(("%.2f, %.2f, %.2f"):format(p.X,p.Y,p.Z))
        Rayfield:Notify({Title="Position Copied", Content=("%.1f, %.1f, %.1f"):format(p.X,p.Y,p.Z), Duration=3, Image="copy"})
    end})
    SettingsTab:CreateButton({Name="Clear Saved Key", Callback=function()
        pcall(function() delfile(SAVE_FILE) end)
        Rayfield:Notify({Title="Key Cleared", Content="Re-enter on next launch", Duration=3, Image="trash"})
    end})
    SettingsTab:CreateButton({Name="Platform: "..(MOBILE and "📱 Mobile" or "🖥️ PC").." (auto-detected)", Callback=function()
        Rayfield:Notify({Title="Platform Info",
            Content="Platform: "..(MOBILE and "Mobile" or "PC").."\nScreen: "..VP.X.."x"..VP.Y..
                "\nTouch: "..tostring(TOUCH).."\nKeyboard: "..tostring(KEYBOARD),
            Duration=5, Image="info"})
    end})

    Rayfield:LoadConfiguration()
    Rayfield:Notify({
        Title = "⚡ CTH Hub Loaded!",
        Content = (MOBILE and "📱 Mobile — 🔪 button to throw" or "🖥️ PC — Press T to throw") ..
            "\nRightShift to toggle UI",
        Duration = 6, Image = "crosshair"
    })
end

task.spawn(function()
    local saved = loadSavedKey()
    if saved and verifyKeyAPI(saved) then loadHub() return end
    buildUI(loadHub)
end)"
local API_URL = "https://heroic-light-production-0d34.up.railway.app/"
local SAVE_FILE = "CTH_Key.txt"

local VP = workspace.CurrentCamera.ViewportSize
local TOUCH = UserInputService.TouchEnabled
local KEYBOARD = UserInputService.KeyboardEnabled
local MOBILE = TOUCH and not KEYBOARD or VP.X < 700

local function tw(i, p, t, s)
    TweenService:Create(i, TweenInfo.new(t or 0.25, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play()
end

local function loadSavedKey()
    local ok, v = pcall(readfile, SAVE_FILE)
    return ok and v and v:match("^%s*(.-)%s*$") or nil
end

local function saveKey(k) pcall(writefile, SAVE_FILE, k) end

local function verifyKeyAPI(key)
    local ok, res = pcall(function() return game:HttpGet(API_URL.."/verify?key="..key) end)
    if not ok or not res then return false end
    return res:find('"valid":true') ~= nil
end

local function buildUI(onSuccess)
    local old = game.CoreGui:FindFirstChild("CTH_Key") or LP.PlayerGui:FindFirstChild("CTH_Key")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "CTH_Key"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = LP.PlayerGui end

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

    local PW = MOBILE and math.min(VP.X * 0.92, 420) or 460
    local BH = MOBILE and 52 or 44
    local TS = MOBILE and 13 or 11
    local TM = MOBILE and 15 or 13
    local TL = MOBILE and 24 or 22
    local PD = 18

    local PANEL_H = PD + 16 + 10 + TL + 8 + 16 + 12 + 1 + 12 + 12 + 6 + BH + 10 + 32 + 10 + BH + 10 + BH + 10 + 16 + 8 + 14 + PD

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, PW, 0, PANEL_H)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.6, 0)
    panel.BackgroundColor3 = Color3.fromRGB(9, 13, 28)
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.ZIndex = 10
    panel.Parent = sg
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

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
            stroke.Color = Color3.new(0, a * 0.784, a)
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
        local o = 0
        while topBar.Parent do
            o = (o + 0.006) % 1
            tg.Offset = Vector2.new(o * 2 - 1, 0)
            task.wait(0.03)
        end
    end)

    local Y = PD

    local function mkLabel(txt, tsize, color, font, xalign, h)
        local height = h or (tsize + 4)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -PD * 2, 0, height)
        l.Position = UDim2.new(0, PD, 0, Y)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = color or Color3.fromRGB(240, 244, 255)
        l.Font = font or Enum.Font.GothamBold
        l.TextSize = tsize
        l.TextXAlignment = xalign or Enum.TextXAlignment.Left
        l.TextWrapped = true
        l.ZIndex = 12
        l.Parent = panel
        Y += height
        return l
    end

    local function gap(n) Y += n end

    mkLabel("⚡ CATCH & THROW HUB", TS, Color3.fromRGB(0, 200, 255), Enum.Font.GothamBlack, nil, 16)
    gap(10)
    mkLabel("Access Required", TL, Color3.fromRGB(240, 244, 255), Enum.Font.GothamBlack, nil, TL)
    gap(8)
    mkLabel("Enter your key or get one free below.", TS, Color3.fromRGB(106, 127, 168), Enum.Font.Gotham, nil, 16)
    gap(12)

    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -PD * 2, 0, 1)
    div.Position = UDim2.new(0, PD, 0, Y)
    div.BackgroundColor3 = Color3.fromRGB(26, 37, 64)
    div.BorderSizePixel = 0
    div.ZIndex = 12
    div.Parent = panel
    gap(1 + 12)

    mkLabel("YOUR KEY", TS - 1, Color3.fromRGB(106, 127, 168), Enum.Font.GothamBold, nil, 12)
    gap(6)

    local inputBG = Instance.new("Frame")
    inputBG.Size = UDim2.new(1, -PD * 2, 0, BH)
    inputBG.Position = UDim2.new(0, PD, 0, Y)
    inputBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    inputBG.BorderSizePixel = 0
    inputBG.ZIndex = 12
    inputBG.Parent = panel
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
    keyBox.TextSize = TM
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false
    keyBox.ZIndex = 13
    keyBox.Parent = inputBG

    keyBox.Focused:Connect(function()
        tw(inputStroke, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.15)
        if MOBILE then
            local kh = GuiService.KeyboardHeight
            local bottom = panel.AbsolutePosition.Y + panel.AbsoluteSize.Y
            local shift = math.max(0, bottom + kh - VP.Y + 20)
            tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift)}, 0.25, Enum.EasingStyle.Quad)
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
        local kh = GuiService.KeyboardHeight
        local bottom = panel.AbsolutePosition.Y + panel.AbsoluteSize.Y
        local shift = math.max(0, bottom + kh - VP.Y + 20)
        tw(panel, {Position = UDim2.new(0.5, 0, 0.5, -shift)}, 0.2, Enum.EasingStyle.Quad)
    end)

    gap(BH + 10)

    local statusBG = Instance.new("Frame")
    statusBG.Size = UDim2.new(1, -PD * 2, 0, 32)
    statusBG.Position = UDim2.new(0, PD, 0, Y)
    statusBG.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    statusBG.BackgroundTransparency = 0.3
    statusBG.BorderSizePixel = 0
    statusBG.ZIndex = 12
    statusBG.Parent = panel
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
    statusTxt.TextSize = TS
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.TextWrapped = true
    statusTxt.ZIndex = 13
    statusTxt.Parent = statusBG

    local function setStatus(msg, col)
        statusTxt.Text = msg
        statusTxt.TextColor3 = col
        tw(statusDot, {BackgroundColor3 = col}, 0.15)
    end

    gap(32 + 10)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1, -PD * 2, 0, BH)
    verifyBtn.Position = UDim2.new(0, PD, 0, Y)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 155, 215)
    verifyBtn.Text = "VERIFY KEY  →"
    verifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    verifyBtn.Font = Enum.Font.GothamBlack
    verifyBtn.TextSize = TM + 1
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.ZIndex = 12
    verifyBtn.Parent = panel
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)
    local vg = Instance.new("UIGradient", verifyBtn)
    vg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 175, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 185)),
    })
    vg.Rotation = 90
    verifyBtn.MouseEnter:Connect(function() tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}, 0.1) end)
    verifyBtn.MouseLeave:Connect(function() tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.1) end)

    gap(BH + 10)

    local function mkGetKeyBtn(txt, xscale, xoffset)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(xscale, -4, 0, BH)
        b.Position = UDim2.new(xoffset, PD + (xoffset > 0 and 2 or 0), 0, Y)
        b.BackgroundColor3 = Color3.fromRGB(8, 14, 32)
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(220, 235, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = TM - 1
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 12
        b.Parent = panel
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke")
        bs.Color = Color3.fromRGB(26, 37, 64)
        bs.Thickness = 1
        bs.Parent = b
        b.MouseEnter:Connect(function()
            tw(bs, {Color = Color3.fromRGB(0, 200, 255), Thickness = 1.5}, 0.1)
            tw(b, {BackgroundColor3 = Color3.fromRGB(0, 22, 50)}, 0.1)
        end)
        b.MouseLeave:Connect(function()
            tw(bs, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.1)
            tw(b, {BackgroundColor3 = Color3.fromRGB(8, 14, 32)}, 0.1)
        end)
        return b, bs
    end

    local llBtn = mkGetKeyBtn("🔗  Lootlabs", 0.5, 0)
    local lvBtn = mkGetKeyBtn("🔗  Linkvertise", 0.5, 0.5)
    gap(BH + 10)

    mkLabel("💾  Key saves after first use — no re-entry needed.", TS - 1, Color3.fromRGB(50, 70, 110), Enum.Font.Gotham, nil, 16)
    gap(8)
    mkLabel("catchthrowhub.com  •  v2.4.1  •  "..(MOBILE and "Mobile" or "PC"), TS - 2, Color3.fromRGB(30, 45, 80), Enum.Font.Gotham, nil, 14)

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local abs = panel.AbsolutePosition
            local sz = panel.AbsoluteSize
            if pos.X < abs.X or pos.X > abs.X + sz.X or pos.Y < abs.Y or pos.Y > abs.Y + sz.Y then
                keyBox:ReleaseFocus()
            end
        end
    end)

    local function dismiss()
        tw(panel, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.3, Enum.EasingStyle.Quad)
        tw(bg, {BackgroundTransparency = 1}, 0.4)
        tw(blur, {Size = 0}, 0.5)
        task.wait(0.5)
        sg:Destroy()
        blur:Destroy()
    end

    local verifying = false
    local function doVerify()
        if verifying then return end
        local key = keyBox.Text:match("^%s*(.-)%s*$")
        if key == "" then
            setStatus("Please enter your key first.", Color3.fromRGB(255, 68, 102))
            tw(inputStroke, {Color = Color3.fromRGB(255, 68, 102), Thickness = 1.5}, 0.1)
            task.delay(1.2, function() tw(inputStroke, {Color = Color3.fromRGB(26, 37, 64), Thickness = 1}, 0.3) end)
            return
        end
        verifying = true
        setStatus("Verifying key...", Color3.fromRGB(0, 200, 255))
        verifyBtn.Text = "Checking..."
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
                tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(150, 20, 45)}, 0.1)
                task.delay(0.5, function()
                    tw(verifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 155, 215)}, 0.3)
                    verifyBtn.Text = "VERIFY KEY  →"
                    verifying = false
                end)
            end
        end)
    end

    verifyBtn.MouseButton1Click:Connect(doVerify)
    keyBox.FocusLost:Connect(function(enter) if enter then doVerify() end end)

    llBtn.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_URL)
        setStatus("Lootlabs URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = llBtn.Text llBtn.Text = "✓ Copied!"
        task.delay(2, function() if llBtn then llBtn.Text = prev end end)
    end)
    lvBtn.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_URL)
        setStatus("Linkvertise URL copied! Open it in your browser.", Color3.fromRGB(0, 200, 255))
        local prev = lvBtn.Text lvBtn.Text = "✓ Copied!"
        task.delay(2, function() if lvBtn then lvBtn.Text = prev end end)
    end)
end

local function loadHub()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Window = Rayfield:CreateWindow({
        Name = "Catch & Throw Hub  ⚡",
        Icon = "crosshair",
        LoadingTitle = "Catch & Throw Hub",
        LoadingSubtitle = "catchthrowhub.com",
        ShowText = "⚡ CTH",
        Theme = "Default",
        ToggleUIKeybind = "RightShift",
        DisableBuildWarnings = true,
        ConfigurationSaving = {Enabled = true, FolderName = "CTH_Hub", FileName = "Config"},
        KeySystem = false,
    })

    local state = {
        AutoCatch = false, SilentAim = false, ReachBypass = true,
        AutoWin = false, KillAura = false, KillAuraRange = 25,
        PlayerESP = false, KnifeESP = false,
        NoClip = false, InfJump = false, WalkSpeed = 16,
        AntiAFK = true, CatchRange = 20,
        CoinFarm = false, HitboxExp = false, HitboxSize = 15,
        SpinBot = false, RainbowChar = false, KnifeTele = false,
        AntiDash = false, GodMode = false,
    }

    local LP2 = game:GetService("Players").LocalPlayer
    local UIS2 = game:GetService("UserInputService")
    local Cam2 = workspace.CurrentCamera
    local HLPool = {}
    local knifeBoxes = {}

    local function Char() return LP2.Character end
    local function Root() local c = Char() return c and c:FindFirstChild("HumanoidRootPart") end
    local function Hum()  local c = Char() return c and c:FindFirstChild("Humanoid") end

    local function setHL(key, adornee, fill, outline, ft)
        if not HLPool[key] or not HLPool[key].Parent then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.OutlineTransparency = 0
            hl.Parent = game.CoreGui
            HLPool[key] = hl
        end
        HLPool[key].Adornee = adornee
        HLPool[key].FillColor = fill or Color3.fromRGB(220, 30, 30)
        HLPool[key].OutlineColor = outline or Color3.fromRGB(255, 255, 255)
        HLPool[key].FillTransparency = ft or 0.45
    end

    local KNIFE_NAMES = {"knife","thrownknife","knifeproj","projectileknife","throwknife","blade"}

    local function getKnives()
        local r = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored then
                local n = obj.Name:lower()
                for _, kn in pairs(KNIFE_NAMES) do
                    if n:find(kn) and not obj:FindFirstAncestorOfClass("Tool") then
                        table.insert(r, obj) break
                    end
                end
            end
        end
        return r
    end

    local function findRemote(kws)
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                for _, kw in pairs(kws) do if n:find(kw) then return r end end
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
        return best, bd
    end

    local catchRemote, catchRefresh = nil, 0
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.AutoCatch and not state.AutoWin then continue end
            local root = Root() if not root then continue end
            catchRefresh -= 0.05
            if catchRefresh <= 0 then
                catchRemote = findRemote({"catch","grab","pickup"})
                catchRefresh = 5
            end
            for _, knife in pairs(getKnives()) do
                if (knife.Position - root.Position).Magnitude <= state.CatchRange then
                    if catchRemote then pcall(function() catchRemote:FireServer(knife) end) end
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
        local root = Root()
        local target = best.Character:FindFirstChild("HumanoidRootPart")
        if not root or not target then throwCD = false return end
        local throwRemote = findRemote({"throw","fire","launch"})
        local savedCF = root.CFrame
        task.spawn(function()
            if state.ReachBypass then
                root.CFrame = CFrame.new(target.Position + Vector3.new(0,0,2.5))
                task.wait(0.05)
            end
            if throwRemote then
                pcall(function() throwRemote:FireServer(target.Position) end)
                pcall(function() throwRemote:FireServer(target) end)
            end
            Cam2.CFrame = CFrame.new(Cam2.CFrame.Position, target.Position)
            if state.ReachBypass then task.wait(0.1) root.CFrame = savedCF end
            task.wait(0.25)
            throwCD = false
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.4)
            if state.AutoWin then doThrow() end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.15)
            if not state.KillAura then continue end
            local best, bd = getNearestAlive()
            if best and bd <= state.KillAuraRange then doThrow() end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.KnifeTele then
                local root = Root()
                local knives = getKnives()
                if root and #knives > 0 then
                    local best, bd = nil, math.huge
                    for _, k in pairs(knives) do
                        local d = (k.Position - root.Position).Magnitude
                        if d < bd then bd = d best = k end
                    end
                    if best then root.CFrame = CFrame.new(best.Position + Vector3.new(0,3,0)) end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if state.CoinFarm then
                local root = Root()
                if root then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        local n = obj.Name:lower()
                        if (n:find("coin") or n:find("gold") or n:find("token")) and obj:IsA("BasePart") then
                            root.CFrame = CFrame.new(obj.Position)
                            task.wait(0.04)
                            local pp = obj:FindFirstChildWhichIsA("ProximityPrompt")
                            if pp then pcall(function() fireproximityprompt(pp) end) end
                        end
                    end
                    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local rn = remote.Name:lower()
                            if rn:find("coin") or rn:find("collect") or rn:find("reward") then
                                pcall(function() remote:FireServer() end)
                                task.wait(0.02)
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if not state.PlayerESP then
                for k, v in pairs(HLPool) do
                    if tostring(k):sub(1,4) == "esp_" then v:Destroy() HLPool[k] = nil end
                end
                continue
            end
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= LP2 and p.Character then
                    local ph = p.Character:FindFirstChild("Humanoid")
                    local fill = (ph and ph.Health > 0) and Color3.fromRGB(220,30,30) or Color3.fromRGB(80,80,80)
                    setHL("esp_"..p.UserId, p.Character, fill, Color3.fromRGB(255,255,255), 0.4)
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
                sb.Color3 = Color3.fromRGB(0,200,255)
                sb.SurfaceColor3 = Color3.fromRGB(0,200,255)
                sb.LineThickness = 0.06
                sb.SurfaceTransparency = 0.7
                sb.Adornee = knife
                sb.Parent = game.CoreGui
                table.insert(knifeBoxes, sb)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.HitboxExp then
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= LP2 and p.Character then
                        local pr = p.Character:FindFirstChild("HumanoidRootPart")
                        if pr then
                            pr.Size = Vector3.new(state.HitboxSize, state.HitboxSize, state.HitboxSize)
                            pr.Transparency = 0.9
                        end
                    end
                end
            end
        end
    end)

    local spinAngle = 0
    local rainbowHue = 0
    RunService.Heartbeat:Connect(function()
        local c = Char() if not c then return end
        if state.NoClip then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
        if state.GodMode then
            local h = Hum() if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end
        if state.SpinBot then
            local r = Root()
            if r then
                spinAngle = spinAngle + 8
                r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end
        if state.RainbowChar then
            rainbowHue = (rainbowHue + 0.008) % 1
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.BrickColor = BrickColor.new(Color3.fromHSV(rainbowHue, 1, 1))
                end
            end
        end
        local h = Hum()
        if h then h.WalkSpeed = state.WalkSpeed end
        if state.AntiDash then
            if h then h.WalkSpeed = math.max(h.WalkSpeed, state.WalkSpeed) end
        end
    end)

    UIS2.JumpRequest:Connect(function()
        if state.InfJump then
            local h = Hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    UIS2.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.T and state.SilentAim then doThrow() end
    end)

    LP2.Idled:Connect(function()
        if state.AntiAFK then
            local VU = game:GetService("VirtualUser")
            VU:Button2Down(Vector2.zero, Cam2.CFrame) task.wait(1) VU:Button2Up(Vector2.zero, Cam2.CFrame)
        end
    end)

    if MOBILE then
        local mg = Instance.new("ScreenGui")
        mg.Name = "CTH_Mobile" mg.ResetOnSpawn = false mg.ZIndexBehavior = Enum.ZIndexBehavior.Global
        mg.DisplayOrder = 50 mg.IgnoreGuiInset = true mg.Parent = LP2.PlayerGui

        local tbf = Instance.new("Frame")
        tbf.Size = UDim2.new(0, 78, 0, 78)
        tbf.Position = UDim2.new(1, -96, 1, -200)
        tbf.BackgroundTransparency = 1
        tbf.Parent = mg

        local tbb = Instance.new("Frame")
        tbb.Size = UDim2.new(1,0,1,0)
        tbb.BackgroundColor3 = Color3.fromRGB(0,155,215)
        tbb.BackgroundTransparency = 0.2
        tbb.BorderSizePixel = 0
        tbb.Parent = tbf
        Instance.new("UICorner", tbb).CornerRadius = UDim.new(1,0)
        local ts2 = Instance.new("UIStroke") ts2.Color = Color3.fromRGB(0,200,255) ts2.Thickness = 2 ts2.Parent = tbb

        local tIcon = Instance.new("TextLabel")
        tIcon.Size = UDim2.new(1,0,0.5,0) tIcon.Position = UDim2.new(0,0,0.08,0)
        tIcon.BackgroundTransparency = 1 tIcon.Text = "🔪" tIcon.TextSize = 26 tIcon.Parent = tbb

        local tLbl = Instance.new("TextLabel")
        tLbl.Size = UDim2.new(1,0,0.32,0) tLbl.Position = UDim2.new(0,0,0.62,0)
        tLbl.BackgroundTransparency = 1 tLbl.Text = "THROW"
        tLbl.TextColor3 = Color3.fromRGB(240,244,255) tLbl.Font = Enum.Font.GothamBlack
        tLbl.TextSize = 10 tLbl.Parent = tbb

        local tbtn = Instance.new("TextButton")
        tbtn.Size = UDim2.new(1,0,1,0) tbtn.BackgroundTransparency = 1
        tbtn.Text = "" tbtn.ZIndex = 2 tbtn.Parent = tbf

        tbtn.MouseButton1Click:Connect(function()
            if state.SilentAim then
                doThrow()
                tw(tbb, {BackgroundColor3 = Color3.fromRGB(0,220,100)}, 0.05)
                task.delay(0.2, function() tw(tbb, {BackgroundColor3 = Color3.fromRGB(0,155,215)}, 0.15) end)
            end
        end)

        local dragStart, dragPos
        tbf.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position dragPos = tbf.Position
            end
        end)
        tbf.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                local d = input.Position - dragStart
                tbf.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset+d.X, dragPos.Y.Scale, dragPos.Y.Offset+d.Y)
            end
        end)
        tbf.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then dragStart = nil end
        end)
    end

    local CombatTab = Window:CreateTab("Combat", "crosshair")

    CombatTab:CreateSection("Auto-Catch — 20Hz")
    CombatTab:CreateToggle({Name="Auto-Catch Knife", CurrentValue=false, Flag="AutoCatch",
        Callback=function(v) state.AutoCatch=v end})
    CombatTab:CreateSlider({Name="Catch Range (studs)", Range={5,60}, Increment=1, CurrentValue=20, Flag="CatchRange",
        Callback=function(v) state.CatchRange=v end})

    CombatTab:CreateSection("Throwing")
    CombatTab:CreateToggle({Name="Silent Aim "..(MOBILE and "(🔪 Button)" or "(T Key)"), CurrentValue=false, Flag="SilentAim",
        Callback=function(v) state.SilentAim=v end})
    CombatTab:CreateToggle({Name="Reach Bypass (TP before throw)", CurrentValue=true, Flag="ReachBypass",
        Callback=function(v) state.ReachBypass=v end})
    if not MOBILE then
        CombatTab:CreateButton({Name="Throw at Nearest (One Shot)", Callback=doThrow})
    end

    CombatTab:CreateSection("Auto Win")
    CombatTab:CreateToggle({Name="⚡ AUTO WIN (Catch + Throw Loop)", CurrentValue=false, Flag="AutoWin",
        Callback=function(v)
            state.AutoWin=v
            Rayfield:Notify({Title=v and "Auto Win ON" or "Auto Win OFF",
                Content=v and "Catching and throwing automatically every 0.4s!" or "Disabled",
                Duration=3, Image=v and "zap" or "info"})
        end})

    CombatTab:CreateSection("Kill Aura")
    CombatTab:CreateToggle({Name="Kill Aura (Auto throw when in range)", CurrentValue=false, Flag="KillAura",
        Callback=function(v) state.KillAura=v end})
    CombatTab:CreateSlider({Name="Kill Aura Range", Range={5,80}, Increment=1, CurrentValue=25, Flag="KillAuraRange",
        Callback=function(v) state.KillAuraRange=v end})

    CombatTab:CreateSection("Knife")
    CombatTab:CreateToggle({Name="Knife Teleport (TP to knife location)", CurrentValue=false, Flag="KnifeTele",
        Callback=function(v) state.KnifeTele=v end})

    local VisTab = Window:CreateTab("Visuals", "eye")

    VisTab:CreateSection("ESP")
    VisTab:CreateToggle({Name="Player ESP (Red Highlights)", CurrentValue=false, Flag="PlayerESP",
        Callback=function(v) state.PlayerESP=v end})
    VisTab:CreateToggle({Name="Knife Zone ESP (Cyan)", CurrentValue=false, Flag="KnifeESP",
        Callback=function(v) state.KnifeESP=v end})

    VisTab:CreateSection("Character FX")
    VisTab:CreateToggle({Name="Rainbow Character (FE ✅)", CurrentValue=false, Flag="RainbowChar",
        Callback=function(v) state.RainbowChar=v end})
    VisTab:CreateToggle({Name="Spin Bot (Confuse enemies)", CurrentValue=false, Flag="SpinBot",
        Callback=function(v) state.SpinBot=v end})

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

    PlrTab:CreateSection("Defense")
    PlrTab:CreateToggle({Name="God Mode (Health Regen)", CurrentValue=false, Flag="GodMode",
        Callback=function(v) state.GodMode=v end})
    PlrTab:CreateToggle({Name="Anti Dash (Freeze WalkSpeed)", CurrentValue=false, Flag="AntiDash",
        Callback=function(v) state.AntiDash=v end})
    PlrTab:CreateToggle({Name="Anti AFK", CurrentValue=true, Flag="AFK",
        Callback=function(v) state.AntiAFK=v end})

    PlrTab:CreateSection("Combat Assist")
    PlrTab:CreateToggle({Name="Hitbox Expander (Easier hits)", CurrentValue=false, Flag="HitboxExp",
        Callback=function(v) state.HitboxExp=v end})
    PlrTab:CreateSlider({Name="Hitbox Size", Range={5,50}, Increment=1, CurrentValue=15, Flag="HitboxSize",
        Callback=function(v) state.HitboxSize=v end})

    PlrTab:CreateSection("Farm")
    PlrTab:CreateToggle({Name="💰 Coin Farm (Auto collect coins)", CurrentValue=false, Flag="CoinFarm",
        Callback=function(v)
            state.CoinFarm=v
            Rayfield:Notify({Title=v and "Coin Farm ON" or "Coin Farm OFF",
                Content=v and "Collecting all coins on map!" or "Disabled",
                Duration=3, Image=v and "dollar-sign" or "info"})
        end})

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
        Rayfield:Notify({Title="Remotes Dumped", Content=#lines.." remotes — copied + saved", Duration=4, Image="terminal"})
    end})
    SettingsTab:CreateButton({Name="Copy My Position", Callback=function()
        local r = Root() if not r then return end
        local p = r.Position
        setclipboard(("%.2f, %.2f, %.2f"):format(p.X,p.Y,p.Z))
        Rayfield:Notify({Title="Position Copied", Content=("%.1f, %.1f, %.1f"):format(p.X,p.Y,p.Z), Duration=3, Image="copy"})
    end})
    SettingsTab:CreateButton({Name="Clear Saved Key", Callback=function()
        pcall(function() delfile(SAVE_FILE) end)
        Rayfield:Notify({Title="Key Cleared", Content="Re-enter on next launch", Duration=3, Image="trash"})
    end})
    SettingsTab:CreateButton({Name="Platform: "..(MOBILE and "📱 Mobile" or "🖥️ PC").." (auto-detected)", Callback=function()
        Rayfield:Notify({Title="Platform Info",
            Content="Platform: "..(MOBILE and "Mobile" or "PC").."\nScreen: "..VP.X.."x"..VP.Y..
                "\nTouch: "..tostring(TOUCH).."\nKeyboard: "..tostring(KEYBOARD),
            Duration=5, Image="info"})
    end})

    Rayfield:LoadConfiguration()
    Rayfield:Notify({
        Title = "⚡ CTH Hub Loaded!",
        Content = (MOBILE and "📱 Mobile — 🔪 button to throw" or "🖥️ PC — Press T to throw") ..
            "\nRightShift to toggle UI",
        Duration = 6, Image = "crosshair"
    })
end

task.spawn(function()
    local saved = loadSavedKey()
    if saved and verifyKeyAPI(saved) then loadHub() return end
    buildUI(loadHub)
end)
