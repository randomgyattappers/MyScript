local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local LOOTLABS_URL = "https://links.lootlabs.gg/s?gn1U3ocC"
local LINKVERTISE_URL = "https://linkvertise.com/4521873/6l4it25kaDcy?o=sharing"
local API_URL = "https://heroic-light-production-0d34.up.railway.app/"
local SAVE_FILE = "CTH_Key.txt"

local function tw(inst, props, t, style)
    TweenService:Create(inst, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart), props):Play()
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
        return game:HttpGet(API_URL.."/verify?key="..key)
    end)
    if not ok then return false end
    local parsed = pcall(function()
        local data = game:GetService("HttpService"):JSONDecode(res)
        return data.valid == true
    end)
    return res:find('"valid":true') ~= nil
end

local function buildUI(onSuccess)
    local old = game.CoreGui:FindFirstChild("CTH_Key")
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
    tw(blur, {Size = 20}, 0.5)

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(4,6,14)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = sg

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0,460,0,400)
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.new(0.5,0,0.5,0)
    panel.BackgroundColor3 = Color3.fromRGB(9,13,28)
    panel.BorderSizePixel = 0
    panel.ZIndex = 10
    panel.Parent = sg
    Instance.new("UICorner",panel).CornerRadius = UDim.new(0,14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(26,37,64)
    stroke.Thickness = 1
    stroke.Parent = panel

    panel.BackgroundTransparency = 1
    panel.Position = UDim2.new(0.5,0,0.6,0)
    tw(panel, {BackgroundTransparency=0, Position=UDim2.new(0.5,0,0.5,0)}, 0.45, Enum.EasingStyle.Back)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,2)
    topBar.BackgroundColor3 = Color3.fromRGB(0,200,255)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 11
    topBar.Parent = panel
    Instance.new("UIGradient", topBar).Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(0,60,180)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(0,60,180)),
    })

    local function label(parent, txt, size, pos, color, font, tsize, xalign)
        local l = Instance.new("TextLabel")
        l.Size = size
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = color or Color3.fromRGB(240,244,255)
        l.Font = font or Enum.Font.GothamBold
        l.TextSize = tsize or 13
        l.TextXAlignment = xalign or Enum.TextXAlignment.Left
        l.ZIndex = 12
        l.Parent = parent
        return l
    end

    label(panel, "⚡ CATCH & THROW HUB",
        UDim2.new(1,-32,0,20),
        UDim2.new(0,16,0,16),
        Color3.fromRGB(0,200,255),
        Enum.Font.GothamBlack, 13)

    label(panel, "Access Required",
        UDim2.new(1,-32,0,28),
        UDim2.new(0,16,0,44),
        Color3.fromRGB(240,244,255),
        Enum.Font.GothamBlack, 22)

    label(panel, "Enter your key or get one free below.",
        UDim2.new(1,-32,0,18),
        UDim2.new(0,16,0,74),
        Color3.fromRGB(106,127,168),
        Enum.Font.Gotham, 12)

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1,-32,0,1)
    divider.Position = UDim2.new(0,16,0,102)
    divider.BackgroundColor3 = Color3.fromRGB(26,37,64)
    divider.BorderSizePixel = 0
    divider.ZIndex = 12
    divider.Parent = panel

    label(panel, "YOUR KEY",
        UDim2.new(1,-32,0,14),
        UDim2.new(0,16,0,116),
        Color3.fromRGB(106,127,168),
        Enum.Font.GothamBold, 10)

    local inputBG = Instance.new("Frame")
    inputBG.Size = UDim2.new(1,-32,0,44)
    inputBG.Position = UDim2.new(0,16,0,134)
    inputBG.BackgroundColor3 = Color3.fromRGB(5,8,18)
    inputBG.BorderSizePixel = 0
    inputBG.ZIndex = 12
    inputBG.Parent = panel
    Instance.new("UICorner",inputBG).CornerRadius = UDim.new(0,8)
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(26,37,64)
    inputStroke.Thickness = 1
    inputStroke.Parent = inputBG

    local keyIcon = Instance.new("TextLabel")
    keyIcon.Size = UDim2.new(0,36,1,0)
    keyIcon.Position = UDim2.new(0,0,0,0)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Text = "🔑"
    keyIcon.TextSize = 15
    keyIcon.ZIndex = 13
    keyIcon.Parent = inputBG

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1,-44,1,-2)
    keyBox.Position = UDim2.new(0,38,0,1)
    keyBox.BackgroundTransparency = 1
    keyBox.Text = ""
    keyBox.PlaceholderText = "CTH-XXXX-XXXX-XXXX"
    keyBox.PlaceholderColor3 = Color3.fromRGB(60,80,110)
    keyBox.TextColor3 = Color3.fromRGB(240,244,255)
    keyBox.Font = Enum.Font.GothamBold
    keyBox.TextSize = 14
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false
    keyBox.ZIndex = 13
    keyBox.Parent = inputBG

    keyBox.Focused:Connect(function()
        tw(inputStroke,{Color=Color3.fromRGB(0,200,255),Thickness=1.5},0.15)
    end)
    keyBox.FocusLost:Connect(function()
        tw(inputStroke,{Color=Color3.fromRGB(26,37,64),Thickness=1},0.15)
    end)

    local statusBG = Instance.new("Frame")
    statusBG.Size = UDim2.new(1,-32,0,32)
    statusBG.Position = UDim2.new(0,16,0,186)
    statusBG.BackgroundColor3 = Color3.fromRGB(5,8,18)
    statusBG.BackgroundTransparency = 0.3
    statusBG.BorderSizePixel = 0
    statusBG.ZIndex = 12
    statusBG.Parent = panel
    Instance.new("UICorner",statusBG).CornerRadius = UDim.new(0,7)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0,6,0,6)
    statusDot.Position = UDim2.new(0,12,0.5,-3)
    statusDot.BackgroundColor3 = Color3.fromRGB(106,127,168)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 13
    statusDot.Parent = statusBG
    Instance.new("UICorner",statusDot).CornerRadius = UDim.new(1,0)

    local statusTxt = Instance.new("TextLabel")
    statusTxt.Size = UDim2.new(1,-28,1,0)
    statusTxt.Position = UDim2.new(0,24,0,0)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "Waiting for key..."
    statusTxt.TextColor3 = Color3.fromRGB(106,127,168)
    statusTxt.Font = Enum.Font.Gotham
    statusTxt.TextSize = 12
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.ZIndex = 13
    statusTxt.Parent = statusBG

    local function setStatus(msg, col)
        statusTxt.Text = msg
        statusTxt.TextColor3 = col
        tw(statusDot,{BackgroundColor3=col},0.15)
    end

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1,-32,0,44)
    verifyBtn.Position = UDim2.new(0,16,0,228)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0,160,220)
    verifyBtn.Text = "VERIFY KEY  →"
    verifyBtn.TextColor3 = Color3.fromRGB(0,0,0)
    verifyBtn.Font = Enum.Font.GothamBlack
    verifyBtn.TextSize = 14
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.ZIndex = 12
    verifyBtn.Parent = panel
    Instance.new("UICorner",verifyBtn).CornerRadius = UDim.new(0,8)

    verifyBtn.MouseEnter:Connect(function()
        tw(verifyBtn,{BackgroundColor3=Color3.fromRGB(0,210,255)},0.1)
    end)
    verifyBtn.MouseLeave:Connect(function()
        tw(verifyBtn,{BackgroundColor3=Color3.fromRGB(0,160,220)},0.1)
    end)

    local llBtn = Instance.new("TextButton")
    llBtn.Size = UDim2.new(0.47,0,0,40)
    llBtn.Position = UDim2.new(0,16,0,284)
    llBtn.BackgroundColor3 = Color3.fromRGB(8,14,32)
    llBtn.Text = "🔗  Get Key (Lootlabs)"
    llBtn.TextColor3 = Color3.fromRGB(240,244,255)
    llBtn.Font = Enum.Font.GothamBold
    llBtn.TextSize = 12
    llBtn.BorderSizePixel = 0
    llBtn.AutoButtonColor = false
    llBtn.ZIndex = 12
    llBtn.Parent = panel
    Instance.new("UICorner",llBtn).CornerRadius = UDim.new(0,8)
    local llStroke = Instance.new("UIStroke")
    llStroke.Color = Color3.fromRGB(26,37,64)
    llStroke.Thickness = 1
    llStroke.Parent = llBtn

    local lvBtn = Instance.new("TextButton")
    lvBtn.Size = UDim2.new(0.47,0,0,40)
    lvBtn.Position = UDim2.new(0.53,0,0,284)
    lvBtn.BackgroundColor3 = Color3.fromRGB(8,14,32)
    lvBtn.Text = "🔗  Linkvertise"
    lvBtn.TextColor3 = Color3.fromRGB(240,244,255)
    lvBtn.Font = Enum.Font.GothamBold
    lvBtn.TextSize = 12
    lvBtn.BorderSizePixel = 0
    lvBtn.AutoButtonColor = false
    lvBtn.ZIndex = 12
    lvBtn.Parent = panel
    Instance.new("UICorner",lvBtn).CornerRadius = UDim.new(0,8)
    local lvStroke = Instance.new("UIStroke")
    lvStroke.Color = Color3.fromRGB(26,37,64)
    lvStroke.Thickness = 1
    lvStroke.Parent = lvBtn

    for _, btn in pairs({llBtn, lvBtn}) do
        local str = btn == llBtn and llStroke or lvStroke
        btn.MouseEnter:Connect(function()
            tw(str,{Color=Color3.fromRGB(0,200,255),Thickness=1.5},0.1)
            tw(btn,{BackgroundColor3=Color3.fromRGB(0,25,55)},0.1)
        end)
        btn.MouseLeave:Connect(function()
            tw(str,{Color=Color3.fromRGB(26,37,64),Thickness=1},0.1)
            tw(btn,{BackgroundColor3=Color3.fromRGB(8,14,32)},0.1)
        end)
    end

    label(panel, "💾 Key saves after first use — no re-entry needed next session.",
        UDim2.new(1,-32,0,18),
        UDim2.new(0,16,0,336),
        Color3.fromRGB(50,70,110),
        Enum.Font.Gotham, 11)

    label(panel, "catchthrowhub.com  •  v2.4.1",
        UDim2.new(1,-32,0,16),
        UDim2.new(0,16,0,362),
        Color3.fromRGB(30,45,80),
        Enum.Font.Gotham, 10)

    llBtn.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_URL)
        setStatus("Lootlabs URL copied! Paste in browser, complete tasks, get your key.", Color3.fromRGB(0,200,255))
        llBtn.Text = "✓ Copied!"
        task.delay(2, function() if llBtn then llBtn.Text = "🔗  Get Key (Lootlabs)" end end)
    end)

    lvBtn.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_URL)
        setStatus("Linkvertise URL copied! Paste in browser to get your key.", Color3.fromRGB(0,200,255))
        lvBtn.Text = "✓ Copied!"
        task.delay(2, function() if lvBtn then lvBtn.Text = "🔗  Linkvertise" end end)
    end)

    local function doVerify()
        local key = keyBox.Text:match("^%s*(.-)%s*$")
        if key == "" then
            setStatus("Please enter your key first.", Color3.fromRGB(255,68,102))
            tw(inputStroke,{Color=Color3.fromRGB(255,68,102),Thickness=1.5},0.1)
            task.delay(1, function() tw(inputStroke,{Color=Color3.fromRGB(26,37,64),Thickness=1},0.3) end)
            return
        end
        setStatus("Verifying key...", Color3.fromRGB(0,200,255))
        verifyBtn.Text = "Checking..."

        task.spawn(function()
            local valid = verifyKeyAPI(key)
            if valid then
                setStatus("✓ Key verified! Loading hub...", Color3.fromRGB(0,255,136))
                tw(inputStroke,{Color=Color3.fromRGB(0,255,136)},0.15)
                tw(verifyBtn,{BackgroundColor3=Color3.fromRGB(0,200,100)},0.2)
                verifyBtn.Text = "✓ Verified!"
                saveKey(key)
                task.wait(1.2)
                tw(panel,{BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.4,0)},0.35,Enum.EasingStyle.Quad)
                tw(bg,{BackgroundTransparency=1},0.4)
                tw(blur,{Size=0},0.5)
                task.wait(0.5)
                sg:Destroy()
                blur:Destroy()
                onSuccess()
            else
                setStatus("✗ Invalid or expired key. Get a new one below.", Color3.fromRGB(255,68,102))
                tw(inputStroke,{Color=Color3.fromRGB(255,68,102),Thickness=1.5},0.1)
                task.delay(1.5, function() tw(inputStroke,{Color=Color3.fromRGB(26,37,64),Thickness=1},0.3) end)
                tw(verifyBtn,{BackgroundColor3=Color3.fromRGB(180,20,50)},0.1)
                task.delay(0.5, function() tw(verifyBtn,{BackgroundColor3=Color3.fromRGB(0,160,220)},0.3) end)
                verifyBtn.Text = "VERIFY KEY  →"
            end
        end)
    end

    verifyBtn.MouseButton1Click:Connect(doVerify)
    keyBox.FocusLost:Connect(function(enter) if enter then doVerify() end end)
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
        ConfigurationSaving = {Enabled=true, FolderName="CTH_Hub", FileName="Config"},
        KeySystem = false,
    })

    local state = {
        AutoCatch=false, SilentAim=false, ReachBypass=true,
        PlayerESP=false, KnifeESP=false, NoClip=false,
        InfJump=false, WalkSpeed=16, CatchRange=20,
        AntiAFK=true,
    }

    local LP2 = game:GetService("Players").LocalPlayer
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Cam2 = workspace.CurrentCamera
    local HLPool2 = {}
    local knifeBoxes2 = {}

    local function Char() return LP2.Character end
    local function Root() local c=Char() return c and c:FindFirstChild("HumanoidRootPart") end
    local function Hum() local c=Char() return c and c:FindFirstChild("Humanoid") end

    local function setHL2(key, adornee, fill, outline, ft)
        if not HLPool2[key] or not HLPool2[key].Parent then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.OutlineTransparency = 0
            hl.Parent = game.CoreGui
            HLPool2[key] = hl
        end
        HLPool2[key].Adornee = adornee
        HLPool2[key].FillColor = fill or Color3.fromRGB(220,30,30)
        HLPool2[key].OutlineColor = outline or Color3.fromRGB(255,255,255)
        HLPool2[key].FillTransparency = ft or 0.45
    end

    local KNIFE_NAMES = {"knife","thrownknife","knifeproj","projectileknife","throwknife","blade"}

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

    local function findRemote(keywords)
        for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                for _, kw in pairs(keywords) do
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
                    local d = (pr.Position-root.Position).Magnitude
                    if d < bd then bd=d best=p end
                end
            end
        end
        return best
    end

    task.spawn(function()
        local catchRemote, refreshT = nil, 0
        while true do
            task.wait(0.05)
            if not state.AutoCatch then continue end
            local root = Root() if not root then continue end
            refreshT -= 0.05
            if refreshT <= 0 then
                catchRemote = findRemote({"catch","grab","pickup"})
                refreshT = 5
            end
            for _, knife in pairs(getKnives()) do
                if (knife.Position-root.Position).Magnitude <= state.CatchRange then
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
    UIS.InputBegan:Connect(function(input, gp)
        if gp or input.KeyCode ~= Enum.KeyCode.T or not state.SilentAim or throwCD then return end
        throwCD = true
        local best = getNearestAlive()
        if not best or not best.Character then throwCD=false return end
        local root = Root()
        local target = best.Character:FindFirstChild("HumanoidRootPart")
        if not root or not target then throwCD=false return end
        local throwRemote = findRemote({"throw","fire","launch"})
        local savedCF = root.CFrame
        task.spawn(function()
            if state.ReachBypass then
                root.CFrame = CFrame.new(target.Position+Vector3.new(0,0,2.5))
                task.wait(0.05)
            end
            if throwRemote then
                pcall(function() throwRemote:FireServer(target.Position) end)
                pcall(function() throwRemote:FireServer(target) end)
            end
            Cam2.CFrame = CFrame.new(Cam2.CFrame.Position, target.Position)
            if state.ReachBypass then
                task.wait(0.1)
                root.CFrame = savedCF
            end
            task.wait(0.3)
            throwCD = false
        end)
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if not state.PlayerESP then
                for k,v in pairs(HLPool2) do
                    if tostring(k):sub(1,4)=="esp_" then v:Destroy() HLPool2[k]=nil end
                end
                continue
            end
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= LP2 and p.Character then
                    local ph = p.Character:FindFirstChild("Humanoid")
                    local fill = (ph and ph.Health>0) and Color3.fromRGB(220,30,30) or Color3.fromRGB(80,80,80)
                    setHL2("esp_"..p.UserId, p.Character, fill, Color3.fromRGB(255,255,255), 0.4)
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            for _, b in pairs(knifeBoxes2) do pcall(function() b:Destroy() end) end
            knifeBoxes2 = {}
            if not state.KnifeESP then continue end
            for _, knife in pairs(getKnives()) do
                local sb = Instance.new("SelectionBox")
                sb.Color3 = Color3.fromRGB(0,200,255)
                sb.SurfaceColor3 = Color3.fromRGB(0,200,255)
                sb.LineThickness = 0.06
                sb.SurfaceTransparency = 0.7
                sb.Adornee = knife
                sb.Parent = game.CoreGui
                table.insert(knifeBoxes2, sb)
            end
        end
    end)

    RS.Heartbeat:Connect(function()
        local c = Char() if not c then return end
        if state.NoClip then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
        local h = Hum()
        if h then h.WalkSpeed = state.WalkSpeed end
    end)

    UIS.JumpRequest:Connect(function()
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

    local CombatTab = Window:CreateTab("Combat", "crosshair")
    CombatTab:CreateSection("Auto-Catch — 20Hz Protection")
    CombatTab:CreateToggle({Name="Auto-Catch Knife",CurrentValue=false,Flag="AutoCatch",Callback=function(v) state.AutoCatch=v end})
    CombatTab:CreateSlider({Name="Catch Range (studs)",Range={5,50},Increment=1,CurrentValue=20,Flag="CatchRange",Callback=function(v) state.CatchRange=v end})
    CombatTab:CreateSection("Silent Aim + Reach Bypass")
    CombatTab:CreateToggle({Name="Silent Aim (Press T)",CurrentValue=false,Flag="SilentAim",Callback=function(v) state.SilentAim=v end})
    CombatTab:CreateToggle({Name="Reach Bypass (Auto-TP before throw)",CurrentValue=true,Flag="ReachBypass",Callback=function(v) state.ReachBypass=v end})
    CombatTab:CreateButton({Name="Throw at Nearest (One Shot)",Callback=function()
        local best = getNearestAlive()
        if not best or not best.Character then return end
        local root = Root()
        local target = best.Character:FindFirstChild("HumanoidRootPart")
        if not root or not target then return end
        local throwRemote = findRemote({"throw","fire","launch"})
        local savedCF = root.CFrame
        task.spawn(function()
            if state.ReachBypass then root.CFrame=CFrame.new(target.Position+Vector3.new(0,0,2.5)) task.wait(0.05) end
            if throwRemote then pcall(function() throwRemote:FireServer(target.Position) end) end
            Cam2.CFrame = CFrame.new(Cam2.CFrame.Position, target.Position)
            if state.ReachBypass then task.wait(0.1) root.CFrame=savedCF end
        end)
    end})

    local VisTab = Window:CreateTab("Visuals", "eye")
    VisTab:CreateSection("ESP")
    VisTab:CreateToggle({Name="Player ESP (Red)",CurrentValue=false,Flag="PlayerESP",Callback=function(v) state.PlayerESP=v end})
    VisTab:CreateToggle({Name="Knife Zone ESP (Cyan)",CurrentValue=false,Flag="KnifeESP",Callback=function(v) state.KnifeESP=v end})
    VisTab:CreateSection("World")
    VisTab:CreateToggle({Name="Full Bright",CurrentValue=false,Flag="FullBright",Callback=function(v)
        game:GetService("Lighting").Brightness=v and 10 or 1
        game:GetService("Lighting").ClockTime=v and 14 or 10
        game:GetService("Lighting").GlobalShadows=not v
        game:GetService("Lighting").Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
    end})
    VisTab:CreateSlider({Name="FOV",Range={30,140},Increment=5,CurrentValue=70,Flag="FOV",Callback=function(v) Cam2.FieldOfView=v end})

    local PlrTab = Window:CreateTab("Player", "user")
    PlrTab:CreateSection("Movement")
    PlrTab:CreateSlider({Name="Walk Speed",Range={16,300},Increment=1,CurrentValue=16,Flag="WS",Callback=function(v) state.WalkSpeed=v end})
    PlrTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="IJ",Callback=function(v) state.InfJump=v end})
    PlrTab:CreateToggle({Name="No Clip",CurrentValue=false,Flag="NC",Callback=function(v) state.NoClip=v end})
    PlrTab:CreateToggle({Name="Low Gravity",CurrentValue=false,Flag="LG",Callback=function(v) workspace.Gravity=v and 40 or 196.2 end})
    PlrTab:CreateToggle({Name="Anti AFK",CurrentValue=true,Flag="AFK",Callback=function(v) state.AntiAFK=v end})

    local SettingsTab = Window:CreateTab("Settings", "settings")
    SettingsTab:CreateSection("Advanced")
    SettingsTab:CreateButton({Name="Dump Remotes to Clipboard",Callback=function()
        local lines={}
        for _,r in pairs(game:GetDescendants()) do
            if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                table.insert(lines, r.ClassName..": "..r:GetFullName())
            end
        end
        local out = table.concat(lines,"\n")
        pcall(function() writefile("CTH_Remotes.txt",out) end)
        setclipboard(out)
        Rayfield:Notify({Title="Dumped",Content=#lines.." remotes copied",Duration=3,Image="terminal"})
    end})
    SettingsTab:CreateButton({Name="Clear Saved Key",Callback=function()
        pcall(function() delfile(SAVE_FILE) end)
        Rayfield:Notify({Title="Key Cleared",Content="Re-enter key on next launch",Duration=3,Image="trash"})
    end})

    Rayfield:LoadConfiguration()
    Rayfield:Notify({Title="⚡ CTH Hub Loaded!",Content="RightShift to toggle | Press T to throw",Duration=5,Image="crosshair"})
end

task.spawn(function()
    local saved = loadSavedKey()
    if saved and verifyKeyAPI(saved) then
        loadHub()
        return
    end
    buildUI(loadHub)
end)
