-- ================================================================
--   ██████╗ █████╗ ████████╗ ██████╗██╗  ██╗
--  ██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║  ██║
--  ██║     ███████║   ██║   ██║     ███████║
--  ██║     ██╔══██║   ██║   ██║     ██╔══██║
--  ╚██████╗██║  ██║   ██║   ╚██████╗██║  ██║
--         ╚═══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
--   CATCH & THROW HUB — v2.4.1
--   catchthrowhub.com
--   Auto-Catch 20Hz | Silent Aim | Reach Bypass
-- ================================================================

-- ============================================================
-- !! OWNER CONFIG — EDIT THESE !!
-- ============================================================
local CFG = {
   -- Your Lootlabs link (users complete tasks → get key)
   LOOTLABS_URL   = "https://lootdest.org/s?gn1U3ocC",

   -- Backup Linkvertise URL (shown as alternative)
   LINKVERTISE_URL = "https://link-target.net/4521873/GJLSo9Vs9UiR",

   -- GitHub raw URL to your keys.txt (one key per line)
   -- Create a private/public repo, put keys there, paste raw URL
   KEYS_URL = "https://github.com/randomgyattappers/cth-keys/blob/main/keys.txt",

   -- Local save file name (so user doesn't re-enter key each session)
   SAVE_FILE = "CTH_Key.txt",

   -- Your Discord invite
   DISCORD = "https://discord.gg/SJzhmmudna",

   VERSION  = "v2.4.1",
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")
local Workspace        = workspace

local LP  = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- ============================================================
-- TWEEN HELPER
-- ============================================================
local function tween(inst, props, t, style, dir)
   TweenService:Create(inst,
      TweenInfo.new(t or 0.25,
         style or Enum.EasingStyle.Quart,
         dir   or Enum.EasingDirection.Out),
      props):Play()
end

-- ============================================================
-- COLORS (matching website)
-- ============================================================
local C = {
   BG     = Color3.fromRGB(5,   8,   16),
   PANEL  = Color3.fromRGB(10,  15,  30),
   PANEL2 = Color3.fromRGB(15,  22,  45),
   BORDER = Color3.fromRGB(26,  37,  64),
   BLUE   = Color3.fromRGB(0,   200, 255),
   BLUE2  = Color3.fromRGB(0,   120, 180),
   WHITE  = Color3.fromRGB(240, 244, 255),
   MUTED  = Color3.fromRGB(106, 127, 168),
   GREEN  = Color3.fromRGB(0,   255, 136),
   RED    = Color3.fromRGB(255, 68,  102),
   BLACK  = Color3.fromRGB(0,   0,   0),
}

-- ============================================================
-- KEY VERIFICATION
-- ============================================================
local validKeys = {}
local keyVerified = false

local function fetchKeys()
   local ok, result = pcall(function()
      return game:HttpGet(CFG.KEYS_URL)
   end)
   if ok and result then
      for line in result:gmatch("[^\n\r]+") do
         line = line:match("^%s*(.-)%s*$") -- trim whitespace
         if line ~= "" then
            validKeys[line] = true
         end
      end
      return true
   end
   return false
end

local function isValidKey(key)
   return validKeys[key] == true
end

local function loadSavedKey()
   local ok, saved = pcall(function() return readfile(CFG.SAVE_FILE) end)
   if ok and saved and saved ~= "" then
      saved = saved:match("^%s*(.-)%s*$")
      if isValidKey(saved) then return saved end
   end
   return nil
end

local function saveKey(key)
   pcall(function() writefile(CFG.SAVE_FILE, key) end)
end

-- ============================================================
-- REMOVE EXISTING UI
-- ============================================================
local function cleanUI(name)
   for _, v in pairs({game.CoreGui, LP.PlayerGui}) do
      local old = v:FindFirstChild(name)
      if old then old:Destroy() end
   end
end
cleanUI("CTH_KeyUI")
cleanUI("CTH_Hub")

-- ============================================================
-- BLUR EFFECT
-- ============================================================
local blurFX = Instance.new("BlurEffect")
blurFX.Size   = 0
blurFX.Parent = Lighting

-- ============================================================
-- KEY SYSTEM UI — Custom beautiful GUI matching website design
-- ============================================================
local function buildKeyUI(onSuccess)
   tween(blurFX, {Size = 28}, 0.6)

   local sg = Instance.new("ScreenGui")
   sg.Name           = "CTH_KeyUI"
   sg.ResetOnSpawn   = false
   sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
   sg.DisplayOrder   = 999
   sg.IgnoreGuiInset = true
   pcall(function() sg.Parent = game.CoreGui end)
   if not sg.Parent then sg.Parent = LP.PlayerGui end

   -- ── FULL SCREEN OVERLAY ─────────────────────────────────
   local overlay = Instance.new("Frame")
   overlay.Name              = "Overlay"
   overlay.Size              = UDim2.new(1,0,1,0)
   overlay.BackgroundColor3  = C.BG
   overlay.BackgroundTransparency = 0.15
   overlay.BorderSizePixel   = 0
   overlay.ZIndex            = 1
   overlay.Parent            = sg

   -- Animated gradient stripe (top)
   local stripe = Instance.new("Frame")
   stripe.Size              = UDim2.new(1,0,0,2)
   stripe.Position          = UDim2.new(0,0,0,0)
   stripe.BackgroundColor3  = C.BLUE
   stripe.BorderSizePixel   = 0
   stripe.ZIndex            = 2
   stripe.Parent            = sg
   local stripeGrad = Instance.new("UIGradient")
   stripeGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(0,80,200)),
      ColorSequenceKeypoint.new(0.5, C.BLUE),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0,80,200)),
   })
   stripeGrad.Parent = stripe

   -- Animate stripe gradient offset
   task.spawn(function()
      local offset = 0
      while stripe.Parent do
         offset = (offset + 0.005) % 1
         stripeGrad.Offset = Vector2.new(offset * 2 - 1, 0)
         task.wait(0.03)
      end
   end)

   -- Particle dots (decorative)
   task.spawn(function()
      while sg.Parent do
         local dot = Instance.new("Frame")
         dot.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
         dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
         dot.BackgroundColor3 = math.random() > 0.6 and C.BLUE or C.WHITE
         dot.BackgroundTransparency = 0.3
         dot.BorderSizePixel = 0
         dot.ZIndex = 2
         Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
         dot.Parent = sg
         tween(dot, {BackgroundTransparency = 1, Position = dot.Position - UDim2.new(0,0,0.1,0)}, 3)
         task.delay(3, function() if dot then dot:Destroy() end end)
         task.wait(0.12)
      end
   end)

   -- ── MAIN PANEL ──────────────────────────────────────────
   local panel = Instance.new("Frame")
   panel.Name              = "Panel"
   panel.Size              = UDim2.new(0, 480, 0, 520)
   panel.Position          = UDim2.new(0.5, -240, 0.5, -260)
   panel.BackgroundColor3  = C.PANEL
   panel.BackgroundTransparency = 0
   panel.BorderSizePixel   = 0
   panel.ZIndex            = 3
   panel.AnchorPoint       = Vector2.new(0.5, 0.5)
   panel.Parent            = sg
   Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

   -- Entrance animation
   panel.BackgroundTransparency = 1
   panel.Position = UDim2.new(0.5, -240, 0.6, -260)
   tween(panel, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -240, 0.5, -260)}, 0.5, Enum.EasingStyle.Back)

   -- Panel border glow
   local stroke = Instance.new("UIStroke")
   stroke.Color          = C.BORDER
   stroke.Thickness      = 1
   stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
   stroke.Parent         = panel

   -- Glow border animation
   task.spawn(function()
      local t = 0
      while panel.Parent do
         t = t + 0.02
         local alpha = (math.sin(t) + 1) / 2
         stroke.Color = Color3.new(
            alpha * C.BLUE.R + (1-alpha) * C.BORDER.R,
            alpha * C.BLUE.G + (1-alpha) * C.BORDER.G,
            alpha * C.BLUE.B + (1-alpha) * C.BORDER.B
         )
         stroke.Thickness = 1 + alpha * 0.5
         task.wait(0.05)
      end
   end)

   -- Top glow bar on panel
   local panelGlow = Instance.new("Frame")
   panelGlow.Size             = UDim2.new(1,0,0,1)
   panelGlow.BackgroundColor3 = C.BLUE
   panelGlow.BorderSizePixel  = 0
   panelGlow.ZIndex           = 4
   panelGlow.Parent           = panel
   local panelGlowGrad = Instance.new("UIGradient")
   panelGlowGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0,  Color3.fromRGB(0,0,0)),
      ColorSequenceKeypoint.new(0.3, C.BLUE),
      ColorSequenceKeypoint.new(0.7, C.BLUE),
      ColorSequenceKeypoint.new(1,  Color3.fromRGB(0,0,0)),
   })
   panelGlowGrad.Parent = panelGlow

   -- Inner radial glow (center-left)
   local innerGlow = Instance.new("ImageLabel")
   innerGlow.Size              = UDim2.new(1.2, 0, 1.2, 0)
   innerGlow.Position          = UDim2.new(-0.1, 0, -0.1, 0)
   innerGlow.BackgroundTransparency = 1
   innerGlow.Image             = "rbxassetid://4483362458"
   innerGlow.ImageColor3       = C.BLUE
   innerGlow.ImageTransparency = 0.92
   innerGlow.ZIndex            = 3
   innerGlow.Parent            = panel

   -- ── HEADER ──────────────────────────────────────────────
   local header = Instance.new("Frame")
   header.Size             = UDim2.new(1,0,0,80)
   header.BackgroundColor3 = Color3.fromRGB(8, 13, 28)
   header.BackgroundTransparency = 0
   header.BorderSizePixel  = 0
   header.ZIndex           = 4
   header.Parent           = panel
   Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

   -- Square bottom corners on header
   local headerSquare = Instance.new("Frame")
   headerSquare.Size             = UDim2.new(1,0,0.5,0)
   headerSquare.Position         = UDim2.new(0,0,0.5,0)
   headerSquare.BackgroundColor3 = Color3.fromRGB(8,13,28)
   headerSquare.BorderSizePixel  = 0
   headerSquare.ZIndex           = 4
   headerSquare.Parent           = header

   -- Logo icon
   local logoFrame = Instance.new("Frame")
   logoFrame.Size             = UDim2.new(0,36,0,36)
   logoFrame.Position         = UDim2.new(0,20,0.5,-18)
   logoFrame.BackgroundColor3 = Color3.fromRGB(0,60,100)
   logoFrame.BorderSizePixel  = 0
   logoFrame.ZIndex           = 5
   logoFrame.Parent           = header
   Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0,8)
   local logoStroke = Instance.new("UIStroke")
   logoStroke.Color     = C.BLUE
   logoStroke.Thickness = 1
   logoStroke.Parent    = logoFrame

   local logoText = Instance.new("TextLabel")
   logoText.Size                 = UDim2.new(1,0,1,0)
   logoText.BackgroundTransparency = 1
   logoText.Text                 = "⚡"
   logoText.TextScaled           = true
   logoText.ZIndex               = 6
   logoText.Parent               = logoFrame

   -- Hub title
   local hubTitle = Instance.new("TextLabel")
   hubTitle.Size                 = UDim2.new(0,280,0,22)
   hubTitle.Position             = UDim2.new(0,64,0,16)
   hubTitle.BackgroundTransparency = 1
   hubTitle.Text                 = "CATCH & THROW HUB"
   hubTitle.TextColor3           = C.WHITE
   hubTitle.Font                 = Enum.Font.GothamBlack
   hubTitle.TextSize             = 15
   hubTitle.TextXAlignment       = Enum.TextXAlignment.Left
   hubTitle.ZIndex               = 5
   hubTitle.Parent               = header

   local hubSub = Instance.new("TextLabel")
   hubSub.Size                 = UDim2.new(0,280,0,18)
   hubSub.Position             = UDim2.new(0,64,0,38)
   hubSub.BackgroundTransparency = 1
   hubSub.Text                 = "catchthrowhub.com  •  "..CFG.VERSION
   hubSub.TextColor3           = C.BLUE
   hubSub.Font                 = Enum.Font.GothamBold
   hubSub.TextSize             = 11
   hubSub.TextXAlignment       = Enum.TextXAlignment.Left
   hubSub.ZIndex               = 5
   hubSub.Parent               = header

   -- Version badge
   local vBadge = Instance.new("Frame")
   vBadge.Size             = UDim2.new(0,68,0,24)
   vBadge.Position         = UDim2.new(1,-88,0.5,-12)
   vBadge.BackgroundColor3 = Color3.fromRGB(0,50,80)
   vBadge.BorderSizePixel  = 0
   vBadge.ZIndex           = 5
   vBadge.Parent           = header
   Instance.new("UICorner",vBadge).CornerRadius = UDim.new(1,0)
   local vStroke = Instance.new("UIStroke")
   vStroke.Color     = C.BLUE
   vStroke.Thickness = 1
   vStroke.Parent    = vBadge
   local vText = Instance.new("TextLabel")
   vText.Size                 = UDim2.new(1,0,1,0)
   vText.BackgroundTransparency = 1
   vText.Text                 = "ACTIVE"
   vText.TextColor3           = C.BLUE
   vText.Font                 = Enum.Font.GothamBold
   vText.TextSize             = 10
   vText.ZIndex               = 6
   vText.Parent               = vBadge

   -- ── BODY CONTENT ────────────────────────────────────────
   local body = Instance.new("Frame")
   body.Size             = UDim2.new(1,0,1,-80)
   body.Position         = UDim2.new(0,0,0,80)
   body.BackgroundTransparency = 1
   body.ZIndex           = 4
   body.Parent           = panel

   -- Title text
   local titleLabel = Instance.new("TextLabel")
   titleLabel.Size                = UDim2.new(1,-40,0,30)
   titleLabel.Position            = UDim2.new(0,20,0,22)
   titleLabel.BackgroundTransparency = 1
   titleLabel.Text                = "Access Required"
   titleLabel.TextColor3          = C.WHITE
   titleLabel.Font                = Enum.Font.GothamBlack
   titleLabel.TextSize            = 22
   titleLabel.TextXAlignment      = Enum.TextXAlignment.Left
   titleLabel.ZIndex              = 5
   titleLabel.Parent              = body

   local subLabel = Instance.new("TextLabel")
   subLabel.Size                = UDim2.new(1,-40,0,20)
   subLabel.Position            = UDim2.new(0,20,0,52)
   subLabel.BackgroundTransparency = 1
   subLabel.Text                = "Enter your key below or get one free with Lootlabs."
   subLabel.TextColor3          = C.MUTED
   subLabel.Font                = Enum.Font.Gotham
   subLabel.TextSize            = 12
   subLabel.TextXAlignment      = Enum.TextXAlignment.Left
   subLabel.ZIndex              = 5
   subLabel.Parent              = body

   -- Divider
   local divider = Instance.new("Frame")
   divider.Size             = UDim2.new(1,-40,0,1)
   divider.Position         = UDim2.new(0,20,0,82)
   divider.BackgroundColor3 = C.BORDER
   divider.BorderSizePixel  = 0
   divider.ZIndex           = 5
   divider.Parent           = body

   -- ── KEY INPUT SECTION ────────────────────────────────────
   local inputLabel = Instance.new("TextLabel")
   inputLabel.Size                = UDim2.new(1,-40,0,16)
   inputLabel.Position            = UDim2.new(0,20,0,100)
   inputLabel.BackgroundTransparency = 1
   inputLabel.Text                = "YOUR KEY"
   inputLabel.TextColor3          = C.MUTED
   inputLabel.Font                = Enum.Font.GothamBold
   inputLabel.TextSize            = 10
   inputLabel.LetterSpacing       = 4
   inputLabel.TextXAlignment      = Enum.TextXAlignment.Left
   inputLabel.ZIndex              = 5
   inputLabel.Parent              = body

   -- Input container
   local inputContainer = Instance.new("Frame")
   inputContainer.Size             = UDim2.new(1,-40,0,48)
   inputContainer.Position         = UDim2.new(0,20,0,122)
   inputContainer.BackgroundColor3 = Color3.fromRGB(6,10,22)
   inputContainer.BorderSizePixel  = 0
   inputContainer.ZIndex           = 5
   inputContainer.Parent           = body
   Instance.new("UICorner",inputContainer).CornerRadius = UDim.new(0,10)
   local inputStroke = Instance.new("UIStroke")
   inputStroke.Color     = C.BORDER
   inputStroke.Thickness = 1
   inputStroke.Parent    = inputContainer

   -- Icon in input
   local inputIcon = Instance.new("TextLabel")
   inputIcon.Size                 = UDim2.new(0,40,1,0)
   inputIcon.BackgroundTransparency = 1
   inputIcon.Text                 = "🔑"
   inputIcon.TextSize             = 16
   inputIcon.ZIndex               = 6
   inputIcon.Parent               = inputContainer

   -- The actual text box
   local keyInput = Instance.new("TextBox")
   keyInput.Size                  = UDim2.new(1,-50,1,0)
   keyInput.Position              = UDim2.new(0,44,0,0)
   keyInput.BackgroundTransparency = 1
   keyInput.Text                  = ""
   keyInput.PlaceholderText       = "CAT-XXXX-XXXX-XXXX"
   keyInput.PlaceholderColor3     = C.MUTED
   keyInput.TextColor3            = C.WHITE
   keyInput.Font                  = Enum.Font.GothamBold
   keyInput.TextSize              = 14
   keyInput.TextXAlignment        = Enum.TextXAlignment.Left
   keyInput.ClearTextOnFocus      = false
   keyInput.ZIndex                = 6
   keyInput.Parent                = inputContainer

   -- Focus glow effect on input
   keyInput.Focused:Connect(function()
      tween(inputStroke, {Color = C.BLUE, Thickness = 1.5}, 0.2)
      tween(inputIcon, {TextColor3 = C.BLUE}, 0.2)
   end)
   keyInput.FocusLost:Connect(function()
      tween(inputStroke, {Color = C.BORDER, Thickness = 1}, 0.2)
      tween(inputIcon, {TextColor3 = C.MUTED}, 0.2)
   end)

   -- ── STATUS MESSAGE ───────────────────────────────────────
   local statusFrame = Instance.new("Frame")
   statusFrame.Size             = UDim2.new(1,-40,0,36)
   statusFrame.Position         = UDim2.new(0,20,0,178)
   statusFrame.BackgroundColor3 = Color3.fromRGB(6,10,22)
   statusFrame.BackgroundTransparency = 0.3
   statusFrame.BorderSizePixel  = 0
   statusFrame.ZIndex           = 5
   statusFrame.Parent           = body
   Instance.new("UICorner",statusFrame).CornerRadius = UDim.new(0,8)

   local statusDot = Instance.new("Frame")
   statusDot.Size             = UDim2.new(0,7,0,7)
   statusDot.Position         = UDim2.new(0,14,0.5,-3.5)
   statusDot.BackgroundColor3 = C.MUTED
   statusDot.BorderSizePixel  = 0
   statusDot.ZIndex           = 6
   statusDot.Parent           = statusFrame
   Instance.new("UICorner",statusDot).CornerRadius = UDim.new(1,0)

   local statusMsg = Instance.new("TextLabel")
   statusMsg.Size                 = UDim2.new(1,-40,1,0)
   statusMsg.Position             = UDim2.new(0,30,0,0)
   statusMsg.BackgroundTransparency = 1
   statusMsg.Text                 = "Waiting for key..."
   statusMsg.TextColor3           = C.MUTED
   statusMsg.Font                 = Enum.Font.Gotham
   statusMsg.TextSize             = 12
   statusMsg.TextXAlignment       = Enum.TextXAlignment.Left
   statusMsg.ZIndex               = 6
   statusMsg.Parent               = statusFrame

   local function setStatus(msg, color)
      statusMsg.Text      = msg
      statusMsg.TextColor3 = color or C.MUTED
      tween(statusDot, {BackgroundColor3 = color or C.MUTED}, 0.2)
   end

   -- ── VERIFY BUTTON ────────────────────────────────────────
   local verifyBtn = Instance.new("TextButton")
   verifyBtn.Size              = UDim2.new(1,-40,0,48)
   verifyBtn.Position          = UDim2.new(0,20,0,226)
   verifyBtn.BackgroundColor3  = C.BLUE
   verifyBtn.Text              = ""
   verifyBtn.BorderSizePixel   = 0
   verifyBtn.ZIndex            = 5
   verifyBtn.AutoButtonColor   = false
   verifyBtn.Parent            = body
   Instance.new("UICorner",verifyBtn).CornerRadius = UDim.new(0,10)

   local verifyGrad = Instance.new("UIGradient")
   verifyGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(0,160,220)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,180)),
   })
   verifyGrad.Rotation = 90
   verifyGrad.Parent   = verifyBtn

   local verifyText = Instance.new("TextLabel")
   verifyText.Size                 = UDim2.new(1,0,1,0)
   verifyText.BackgroundTransparency = 1
   verifyText.Text                 = "VERIFY KEY  →"
   verifyText.TextColor3           = Color3.fromRGB(0,0,0)
   verifyText.Font                 = Enum.Font.GothamBlack
   verifyText.TextSize             = 14
   verifyText.ZIndex               = 6
   verifyText.Parent               = verifyBtn

   -- Hover effect
   verifyBtn.MouseEnter:Connect(function()
      tween(verifyBtn, {BackgroundColor3 = Color3.fromRGB(30,220,255)}, 0.15)
   end)
   verifyBtn.MouseLeave:Connect(function()
      tween(verifyBtn, {BackgroundColor3 = C.BLUE}, 0.15)
   end)

   -- ── GET KEY BUTTONS ──────────────────────────────────────
   local getKeyRow = Instance.new("Frame")
   getKeyRow.Size             = UDim2.new(1,-40,0,44)
   getKeyRow.Position         = UDim2.new(0,20,0,284)
   getKeyRow.BackgroundTransparency = 1
   getKeyRow.ZIndex           = 5
   getKeyRow.Parent           = body

   -- Lootlabs button
   local llBtn = Instance.new("TextButton")
   llBtn.Size             = UDim2.new(0.49,0,1,0)
   llBtn.BackgroundColor3 = Color3.fromRGB(10,20,45)
   llBtn.Text             = ""
   llBtn.BorderSizePixel  = 0
   llBtn.ZIndex           = 6
   llBtn.AutoButtonColor  = false
   llBtn.Parent           = getKeyRow
   Instance.new("UICorner",llBtn).CornerRadius = UDim.new(0,10)
   local llStroke = Instance.new("UIStroke")
   llStroke.Color     = C.BORDER
   llStroke.Thickness = 1
   llStroke.Parent    = llBtn

   local llText = Instance.new("TextLabel")
   llText.Size                 = UDim2.new(1,0,1,0)
   llText.BackgroundTransparency = 1
   llText.Text                 = "🔗  Lootlabs"
   llText.TextColor3           = C.WHITE
   llText.Font                 = Enum.Font.GothamBold
   llText.TextSize             = 13
   llText.ZIndex               = 7
   llText.Parent               = llBtn

   -- Linkvertise button
   local lvBtn = Instance.new("TextButton")
   lvBtn.Size             = UDim2.new(0.49,0,1,0)
   lvBtn.Position         = UDim2.new(0.51,0,0,0)
   lvBtn.BackgroundColor3 = Color3.fromRGB(10,20,45)
   lvBtn.Text             = ""
   lvBtn.BorderSizePixel  = 0
   lvBtn.ZIndex           = 6
   lvBtn.AutoButtonColor  = false
   lvBtn.Parent           = getKeyRow
   Instance.new("UICorner",lvBtn).CornerRadius = UDim.new(0,10)
   local lvStroke = Instance.new("UIStroke")
   lvStroke.Color     = C.BORDER
   lvStroke.Thickness = 1
   lvStroke.Parent    = lvBtn

   local lvText = Instance.new("TextLabel")
   lvText.Size                 = UDim2.new(1,0,1,0)
   lvText.BackgroundTransparency = 1
   lvText.Text                 = "🔗  Linkvertise"
   lvText.TextColor3           = C.WHITE
   lvText.Font                 = Enum.Font.GothamBold
   lvText.TextSize             = 13
   lvText.ZIndex               = 7
   lvText.Parent               = lvBtn

   -- Hover effects for get key buttons
   for _, btn in pairs({llBtn, lvBtn}) do
      local str = btn == llBtn and llStroke or lvStroke
      btn.MouseEnter:Connect(function()
         tween(str, {Color = C.BLUE, Thickness = 1.5}, 0.15)
         tween(btn, {BackgroundColor3 = Color3.fromRGB(0,30,60)}, 0.15)
      end)
      btn.MouseLeave:Connect(function()
         tween(str, {Color = C.BORDER, Thickness = 1}, 0.15)
         tween(btn, {BackgroundColor3 = Color3.fromRGB(10,20,45)}, 0.15)
      end)
   end

   -- Info text below buttons
   local infoText = Instance.new("TextLabel")
   infoText.Size                = UDim2.new(1,-40,0,20)
   infoText.Position            = UDim2.new(0,20,0,336)
   infoText.BackgroundTransparency = 1
   infoText.Text                = "Complete tasks to receive your key. Key saves after first use."
   infoText.TextColor3          = C.MUTED
   infoText.Font                = Enum.Font.Gotham
   infoText.TextSize            = 11
   infoText.ZIndex              = 5
   infoText.Parent              = body

   -- ── DIVIDER 2 ────────────────────────────────────────────
   local div2 = Instance.new("Frame")
   div2.Size             = UDim2.new(1,-40,0,1)
   div2.Position         = UDim2.new(0,20,0,366)
   div2.BackgroundColor3 = C.BORDER
   div2.BorderSizePixel  = 0
   div2.ZIndex           = 5
   div2.Parent           = body

   -- ── SAVED KEY NOTICE ─────────────────────────────────────
   local savedNotice = Instance.new("TextLabel")
   savedNotice.Size                = UDim2.new(1,-40,0,30)
   savedNotice.Position            = UDim2.new(0,20,0,375)
   savedNotice.BackgroundTransparency = 1
   savedNotice.Text                = "💾  Key saves locally — you won't need to re-enter it next time."
   savedNotice.TextColor3          = C.MUTED
   savedNotice.Font                = Enum.Font.Gotham
   savedNotice.TextSize            = 11
   savedNotice.ZIndex              = 5
   savedNotice.Parent              = body

   -- ── FOOTER ───────────────────────────────────────────────
   local footer = Instance.new("TextLabel")
   footer.Size                = UDim2.new(1,-40,0,30)
   footer.Position            = UDim2.new(0,20,0,412)
   footer.BackgroundTransparency = 1
   footer.Text                = "catchthrowhub.com  |  Discord: "..CFG.DISCORD.."  |  "..CFG.VERSION
   footer.TextColor3          = Color3.fromRGB(50,65,100)
   footer.Font                = Enum.Font.Gotham
   footer.TextSize            = 10
   footer.ZIndex              = 5
   footer.Parent              = body

   -- ── BUTTON CALLBACKS ─────────────────────────────────────

   -- Lootlabs → copy URL + notify
   llBtn.MouseButton1Click:Connect(function()
      setclipboard(CFG.LOOTLABS_URL)
      setStatus("Lootlabs URL copied! Paste it in your browser.", C.BLUE)
      tween(llStroke, {Color = C.BLUE}, 0.2)
      task.delay(0.3, function() tween(llStroke, {Color = C.BORDER}, 0.5) end)
      llText.Text = "✓ Copied!"
      task.delay(2, function() if llText then llText.Text = "🔗  Lootlabs" end end)
   end)

   -- Linkvertise → copy URL
   lvBtn.MouseButton1Click:Connect(function()
      setclipboard(CFG.LINKVERTISE_URL)
      setStatus("Linkvertise URL copied! Paste it in your browser.", C.BLUE)
      lvText.Text = "✓ Copied!"
      task.delay(2, function() if lvText then lvText.Text = "🔗  Linkvertise" end end)
   end)

   -- Verify key
   local function doVerify()
      local key = keyInput.Text:match("^%s*(.-)%s*$")
      if key == "" then
         setStatus("Please enter your key first.", C.RED)
         tween(inputStroke, {Color = C.RED}, 0.15)
         task.delay(1, function() tween(inputStroke, {Color = C.BORDER}, 0.3) end)
         return
      end

      setStatus("Fetching key whitelist...", C.BLUE)
      verifyText.Text = "Checking..."

      task.spawn(function()
         -- Fetch latest keys from GitHub
         fetchKeys()

         if isValidKey(key) then
            -- Success!
            setStatus("✓  Key verified! Loading hub...", C.GREEN)
            tween(statusDot, {BackgroundColor3 = C.GREEN}, 0.2)
            tween(inputStroke, {Color = C.GREEN}, 0.2)
            saveKey(key)
            verifyText.Text = "✓ Verified!"
            tween(verifyBtn, {BackgroundColor3 = C.GREEN}, 0.3)

            task.wait(1.2)

            -- Fade out UI
            tween(panel, {BackgroundTransparency = 1, Position = UDim2.new(0.5,-240,0.4,-260)}, 0.4, Enum.EasingStyle.Quad)
            tween(overlay, {BackgroundTransparency = 1}, 0.5)
            tween(blurFX, {Size = 0}, 0.6)

            task.wait(0.6)
            sg:Destroy()
            onSuccess()
         else
            -- Fail
            setStatus("✗  Invalid or expired key. Get a new one.", C.RED)
            tween(inputStroke, {Color = C.RED, Thickness = 1.5}, 0.15)
            task.delay(1, function() tween(inputStroke, {Color = C.BORDER, Thickness = 1}, 0.4) end)
            verifyText.Text = "VERIFY KEY  →"
            tween(verifyBtn, {BackgroundColor3 = C.BLUE}, 0.3)
         end
      end)
   end

   verifyBtn.MouseButton1Click:Connect(doVerify)
   keyInput.FocusLost:Connect(function(pressed) if pressed then doVerify() end end)

   -- Auto-fetch keys in background while user is reading
   task.spawn(fetchKeys)
end

-- ============================================================
-- MAIN SCRIPT — loads after key verification
-- ============================================================
local function loadMainScript()

   -- ── SERVICES / UTILS ───────────────────────────────────
   local function C2()  return LP.Character end
   local function R2()  local c=C2() return c and c:FindFirstChild("HumanoidRootPart") end
   local function H2()  local c=C2() return c and c:FindFirstChild("Humanoid") end

   local _G_STATE = {
      AutoCatch    = false,
      SilentAim    = false,
      ReachBypass  = true,
      PlayerESP    = false,
      KnifeESP     = false,
      NoClip       = false,
      InfJump      = false,
      WalkSpeed    = 16,
      ThrowKey     = Enum.KeyCode.T,
      CatchRange   = 20,
      TargetNearest= true,
   }

   local HLPool    = {}
   local knifeBoxes = {}

   -- ── ESP HELPERS ────────────────────────────────────────
   local function setHL(key, adornee, fill, outline, ft)
      if not HLPool[key] or not HLPool[key].Parent then
         local hl = Instance.new("Highlight")
         hl.DepthMode            = Enum.HighlightDepthMode.AlwaysOnTop
         hl.OutlineTransparency  = 0
         hl.Parent               = game.CoreGui
         HLPool[key]             = hl
      end
      HLPool[key].Adornee          = adornee
      HLPool[key].FillColor        = fill    or Color3.fromRGB(255,60,60)
      HLPool[key].OutlineColor     = outline or Color3.fromRGB(255,255,255)
      HLPool[key].FillTransparency = ft      or 0.45
   end
   local function clearHL(key)
      if HLPool[key] then HLPool[key]:Destroy() HLPool[key]=nil end
   end
   local function clearGroup(prefix)
      for k,v in pairs(HLPool) do
         if tostring(k):sub(1,#prefix)==prefix then
            v:Destroy() HLPool[k]=nil
         end
      end
   end

   -- ── GET NEAREST PLAYER ─────────────────────────────────
   local function getNearestAlivePlayer()
      local root = R2() if not root then return nil end
      local best, bd = nil, math.huge
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LP and p.Character then
            local ph = p.Character:FindFirstChild("Humanoid")
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            if ph and ph.Health > 0 and pr then
               local d = (pr.Position - root.Position).Magnitude
               if d < bd then bd=d best=p end
            end
         end
      end
      return best, bd
   end

   -- ── FIND KNIFE PROJECTILES ─────────────────────────────
   -- Catch and Throw: knife is a BasePart flying through air
   -- Usually named "Knife", "ThrownKnife", "KnifeProj" etc.
   local KNIFE_NAMES = {"Knife","ThrownKnife","KnifeProj","ProjectileKnife","ThrowKnife","Blade"}

   local function findKnifeRemote()
      for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
         if remote:IsA("RemoteEvent") then
            local n = remote.Name:lower()
            if n:find("catch") or n:find("grab") or n:find("pickup") then
               return remote
            end
         end
      end
      return nil
   end

   local function findThrowRemote()
      for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
         if remote:IsA("RemoteEvent") then
            local n = remote.Name:lower()
            if n:find("throw") or n:find("fire") or n:find("launch") then
               return remote
            end
         end
      end
      return nil
   end

   local function getKnivesInAir()
      local knives = {}
      for _, obj in pairs(Workspace:GetDescendants()) do
         if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local n = obj.Name:lower()
            for _, kn in pairs(KNIFE_NAMES) do
               if n:find(kn:lower()) then
                  -- Check it's actually flying (not held by someone)
                  if not obj.Anchored and obj:FindFirstAncestorOfClass("Tool") == nil then
                     table.insert(knives, obj)
                  end
                  break
               end
            end
         end
      end
      return knives
   end

   -- ── AUTO CATCH (20Hz) ───────────────────────────────────
   task.spawn(function()
      local catchRemote = nil
      local REFRESH_REMOTE = 0
      while true do
         task.wait(0.05) -- 20Hz
         if not _G_STATE.AutoCatch then continue end

         local root = R2() if not root then continue end

         -- Refresh remote reference every 5 seconds
         REFRESH_REMOTE = REFRESH_REMOTE - 0.05
         if REFRESH_REMOTE <= 0 then
            catchRemote   = findKnifeRemote()
            REFRESH_REMOTE = 5
         end

         -- Check all knives in air
         for _, knife in pairs(getKnivesInAir()) do
            local dist = (knife.Position - root.Position).Magnitude
            if dist <= _G_STATE.CatchRange then
               -- Fire catch remote with the knife
               if catchRemote then
                  pcall(function() catchRemote:FireServer(knife) end)
                  pcall(function() catchRemote:FireServer(knife.CFrame.Position) end)
               end
               -- Also try simulating F key press
               pcall(function()
                  local vInput = game:GetService("VirtualInputManager")
                  vInput:SendKeyEvent(true,  Enum.KeyCode.F, false, game)
                  vInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
               end)
               -- Fallback: check for ProximityPrompts on knife
               local prompt = knife:FindFirstChildWhichIsA("ProximityPrompt")
                           or (knife.Parent and knife.Parent:FindFirstChildWhichIsA("ProximityPrompt"))
               if prompt then
                  pcall(function() fireproximityprompt(prompt) end)
               end
            end
         end
      end
   end)

   -- ── SILENT AIM + REACH BYPASS ───────────────────────────
   local throwCooldown = false

   UserInputService.InputBegan:Connect(function(input, gp)
      if gp then return end
      if input.KeyCode ~= _G_STATE.ThrowKey then return end
      if not _G_STATE.SilentAim then return end
      if throwCooldown then return end
      throwCooldown = true

      local best = getNearestAlivePlayer()
      if not best or not best.Character then
         throwCooldown = false return
      end

      local root    = R2()
      local target  = best.Character:FindFirstChild("HumanoidRootPart")
      if not root or not target then throwCooldown = false return end

      local throwRemote = findThrowRemote()
      local savedCF     = root.CFrame

      task.spawn(function()
         -- Reach Bypass: teleport close, throw, return
         if _G_STATE.ReachBypass then
            root.CFrame = CFrame.new(target.Position + Vector3.new(0,0,2.5))
            task.wait(0.05) -- let server register position
         end

         -- Fire throw remote toward target
         if throwRemote then
            pcall(function() throwRemote:FireServer(target.Position) end)
            pcall(function() throwRemote:FireServer(target.CFrame) end)
            pcall(function() throwRemote:FireServer(target) end)
         end

         -- Also redirect camera aim
         Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Position)

         -- Simulate mouse click (throw)
         pcall(function()
            local vInput = game:GetService("VirtualInputManager")
            vInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            vInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
         end)

         -- Return to original position
         if _G_STATE.ReachBypass then
            task.wait(0.1)
            root.CFrame = savedCF
         end

         task.wait(0.3)
         throwCooldown = false
      end)
   end)

   -- ── PLAYER ESP LOOP ─────────────────────────────────────
   task.spawn(function()
      while true do
         task.wait(0.3)
         if not _G_STATE.PlayerESP then
            clearGroup("esp_")
            continue
         end
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
               local ph = p.Character:FindFirstChild("Humanoid")
               local alive = ph and ph.Health > 0
               local fill = alive
                  and Color3.fromRGB(220,30,30)
                  or  Color3.fromRGB(100,100,100)
               setHL("esp_"..p.UserId, p.Character, fill, Color3.fromRGB(255,255,255), 0.4)
            end
         end
         -- Clean up disconnected players
         for k,_ in pairs(HLPool) do
            if tostring(k):sub(1,4)=="esp_" then
               local uid = tonumber(tostring(k):sub(5))
               if uid and not Players:GetPlayerByUserId(uid) then
                  clearHL(k)
               end
            end
         end
      end
   end)

   -- ── KNIFE ESP LOOP ──────────────────────────────────────
   task.spawn(function()
      while true do
         task.wait(0.5)
         for _, b in pairs(knifeBoxes) do
            pcall(function() b:Destroy() end)
         end
         knifeBoxes = {}
         if not _G_STATE.KnifeESP then continue end
         for _, knife in pairs(getKnivesInAir()) do
            local sb = Instance.new("SelectionBox")
            sb.Color3              = Color3.fromRGB(0,200,255)
            sb.SurfaceColor3       = Color3.fromRGB(0,200,255)
            sb.LineThickness       = 0.06
            sb.SurfaceTransparency = 0.7
            sb.Adornee             = knife
            sb.Parent              = game.CoreGui
            table.insert(knifeBoxes, sb)
         end
      end
   end)

   -- ── HEARTBEAT LOOP ──────────────────────────────────────
   RunService.Heartbeat:Connect(function()
      local c = C2() if not c then return end

      -- NoClip
      if _G_STATE.NoClip then
         for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
         end
      end

      -- WalkSpeed sync
      local h = H2()
      if h then h.WalkSpeed = _G_STATE.WalkSpeed end
   end)

   -- InfJump
   UserInputService.JumpRequest:Connect(function()
      if _G_STATE.InfJump then
         local h = H2()
         if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
      end
   end)

   -- ── REMOTE DUMP UTILITY ─────────────────────────────────
   local function dumpRemotes()
      local lines = {}
      for _, r in pairs(game:GetDescendants()) do
         if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            table.insert(lines, r.ClassName..": "..r:GetFullName())
         end
      end
      local out = table.concat(lines,"\n")
      pcall(function() writefile("CTH_Remotes.txt", out) end)
      setclipboard(out)
      return #lines
   end

   -- ============================================================
   -- RAYFIELD UI
   -- ============================================================
   local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

   local Window = Rayfield:CreateWindow({
      Name                   = "Catch & Throw Hub  ⚡  "..CFG.VERSION,
      Icon                   = "crosshair",
      LoadingTitle           = "Catch & Throw Hub",
      LoadingSubtitle        = "catchthrowhub.com — Fully Loaded",
      ShowText               = "⚡ CTH Hub",
      Theme                  = "Default",
      ToggleUIKeybind        = "RightShift",
      DisableRayfieldPrompts = false,
      DisableBuildWarnings   = true,
      ConfigurationSaving    = {Enabled=true, FolderName="CTH_Hub", FileName="Config"},
      KeySystem              = false, -- we handle keys ourselves
   })

   -- ── TAB: COMBAT ────────────────────────────────────────
   local CombatTab = Window:CreateTab("Combat", "crosshair")

   CombatTab:CreateSection("⚡ Auto-Catch — 20Hz Knife Protection")

   CombatTab:CreateToggle({
      Name="Auto-Catch Knife",
      CurrentValue=false, Flag="AutoCatch",
      Callback=function(v)
         _G_STATE.AutoCatch = v
         Rayfield:Notify({
            Title   = v and "Auto-Catch ON" or "Auto-Catch OFF",
            Content = v and "Catching knives at 20Hz — even point-blank!" or "Disabled",
            Duration=3, Image = v and "shield" or "info"
         })
      end
   })

   CombatTab:CreateSlider({
      Name="Catch Range (studs)", Range={5,50}, Increment=1,
      CurrentValue=20, Flag="CatchRange",
      Callback=function(v) _G_STATE.CatchRange = v end
   })

   CombatTab:CreateSection("🎯 Silent Aim + Reach Bypass")

   CombatTab:CreateToggle({
      Name="Silent Aim (Press T to throw)",
      CurrentValue=false, Flag="SilentAim",
      Callback=function(v)
         _G_STATE.SilentAim = v
         Rayfield:Notify({
            Title   = v and "Silent Aim ON" or "Silent Aim OFF",
            Content = v and "Press T to auto-throw at nearest alive player" or "Disabled",
            Duration=3, Image = v and "crosshair" or "info"
         })
      end
   })

   CombatTab:CreateToggle({
      Name="Reach Bypass (Auto-TP before throw)",
      CurrentValue=true, Flag="ReachBypass",
      Callback=function(v)
         _G_STATE.ReachBypass = v
         Rayfield:Notify({
            Title   = v and "Reach Bypass ON" or "Reach Bypass OFF",
            Content = v and "Teleports to target and back — bypasses server reach limits" or "Disabled",
            Duration=3, Image="info"
         })
      end
   })

   CombatTab:CreateButton({
      Name="Throw at Nearest (One Shot)",
      Callback=function()
         local best = getNearestAlivePlayer()
         if not best or not best.Character then
            Rayfield:Notify({Title="No Target",Content="No alive players found nearby.",Duration=3,Image="x"})
            return
         end
         local root   = R2()
         local target = best.Character:FindFirstChild("HumanoidRootPart")
         if not root or not target then return end

         local savedCF     = root.CFrame
         local throwRemote = findThrowRemote()

         task.spawn(function()
            if _G_STATE.ReachBypass then
               root.CFrame = CFrame.new(target.Position + Vector3.new(0,0,2.5))
               task.wait(0.05)
            end
            if throwRemote then
               pcall(function() throwRemote:FireServer(target.Position) end)
               pcall(function() throwRemote:FireServer(target) end)
            end
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Position)
            if _G_STATE.ReachBypass then
               task.wait(0.1) root.CFrame = savedCF
            end
         end)

         Rayfield:Notify({Title="Thrown!",Content="Aimed at "..best.Name,Duration=2,Image="crosshair"})
      end
   })

   -- ── TAB: VISUALS ───────────────────────────────────────
   local VisTab = Window:CreateTab("Visuals", "eye")

   VisTab:CreateSection("👥 Player ESP")

   VisTab:CreateToggle({
      Name="Player ESP (Red Highlights)",
      CurrentValue=false, Flag="PlayerESP",
      Callback=function(v)
         _G_STATE.PlayerESP = v
         if not v then clearGroup("esp_") end
      end
   })

   VisTab:CreateToggle({
      Name="Health Bars Above Players",
      CurrentValue=false, Flag="HealthBars",
      Callback=function(v)
         _G_STATE.HealthBars = v
         if v then task.spawn(function()
            while _G_STATE.HealthBars do
               for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LP and p.Character then
                     local head = p.Character:FindFirstChild("Head")
                     local hum  = p.Character:FindFirstChild("Humanoid")
                     if head and hum then
                        if not head:FindFirstChild("CTH_HP") then
                           local bb = Instance.new("BillboardGui")
                           bb.Name="CTH_HP" bb.Size=UDim2.new(3,0,0.5,0)
                           bb.StudsOffset=Vector3.new(0,2.5,0)
                           bb.AlwaysOnTop=true bb.Parent=head
                           local lbl=Instance.new("TextLabel")
                           lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1
                           lbl.Font=Enum.Font.GothamBold lbl.TextScaled=true
                           lbl.Name="HPLabel" lbl.Parent=bb
                        end
                        local lbl=head:FindFirstChild("CTH_HP") and head.CTH_HP:FindFirstChild("HPLabel")
                        if lbl then
                           local pct = hum.Health/math.max(hum.MaxHealth,1)
                           lbl.TextColor3 = pct>0.6 and Color3.fromRGB(0,255,100)
                              or pct>0.3 and Color3.fromRGB(255,200,0)
                              or Color3.fromRGB(255,60,60)
                           lbl.Text = ("♥ %.0f"):format(hum.Health)
                        end
                     end
                  end
               end task.wait(0.2)
            end
         end) end
      end
   })

   VisTab:CreateSection("🔪 Knife Tracking")

   VisTab:CreateToggle({
      Name="Knife Zone ESP (Cyan Outlines)",
      CurrentValue=false, Flag="KnifeESP",
      Callback=function(v)
         _G_STATE.KnifeESP = v
         if not v then
            for _, b in pairs(knifeBoxes) do pcall(function() b:Destroy() end) end
            knifeBoxes = {}
         end
      end
   })

   VisTab:CreateSection("🌅 World")

   VisTab:CreateToggle({
      Name="Full Bright",
      CurrentValue=false, Flag="FullBright",
      Callback=function(v)
         Lighting.Brightness    = v and 10  or 1
         Lighting.ClockTime     = v and 14  or 10
         Lighting.FogEnd        = v and 1e6 or 10000
         Lighting.GlobalShadows = not v
         Lighting.Ambient       = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
      end
   })

   VisTab:CreateToggle({
      Name="Custom Crosshair",
      CurrentValue=false, Flag="Crosshair",
      Callback=function(v)
         local old = game.CoreGui:FindFirstChild("CTH_CH") if old then old:Destroy() end
         if v then
            local sg2 = Instance.new("ScreenGui")
            sg2.Name="CTH_CH" sg2.IgnoreGuiInset=true
            sg2.ResetOnSpawn=false
            pcall(function() sg2.Parent=game.CoreGui end)
            local function mkLine(sz, pos)
               local f=Instance.new("Frame") f.Size=sz f.Position=pos
               f.BackgroundColor3=Color3.fromRGB(0,200,255)
               f.BorderSizePixel=0 f.AnchorPoint=Vector2.new(0.5,0.5)
               f.Parent=sg2
            end
            mkLine(UDim2.new(0,22,0,2), UDim2.new(0.5,0,0.5,0))
            mkLine(UDim2.new(0,2,0,22), UDim2.new(0.5,0,0.5,0))
            local dot=Instance.new("Frame")
            dot.Size=UDim2.new(0,4,0,4) dot.BackgroundColor3=Color3.fromRGB(0,200,255)
            dot.BorderSizePixel=0 dot.AnchorPoint=Vector2.new(0.5,0.5)
            dot.Position=UDim2.new(0.5,0,0.5,0)
            Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
            dot.Parent=sg2
         end
      end
   })

   VisTab:CreateSlider({
      Name="Field of View", Range={30,140}, Increment=5, CurrentValue=70,
      Flag="FOV",
      Callback=function(v) Cam.FieldOfView=v end
   })

   -- ── TAB: PLAYER ────────────────────────────────────────
   local PlrTab = Window:CreateTab("Player", "user")

   PlrTab:CreateSection("⚡ Movement")

   PlrTab:CreateSlider({
      Name="Walk Speed", Range={16,300}, Increment=1, CurrentValue=16,
      Flag="WalkSpeed",
      Callback=function(v) _G_STATE.WalkSpeed=v end
   })

   PlrTab:CreateToggle({
      Name="Infinite Jump", CurrentValue=false, Flag="InfJump",
      Callback=function(v) _G_STATE.InfJump=v end
   })

   PlrTab:CreateToggle({
      Name="No Clip", CurrentValue=false, Flag="NoClip",
      Callback=function(v) _G_STATE.NoClip=v end
   })

   PlrTab:CreateToggle({
      Name="Low Gravity", CurrentValue=false, Flag="LowGrav",
      Callback=function(v) Workspace.Gravity = v and 40 or 196.2 end
   })

   PlrTab:CreateToggle({
      Name="Anti AFK", CurrentValue=true, Flag="AntiAFK",
      Callback=function(v) _G_STATE.AntiAFK=v end
   })
   LP.Idled:Connect(function()
      if _G_STATE.AntiAFK then
         local VU = game:GetService("VirtualUser")
         VU:Button2Down(Vector2.zero, Cam.CFrame) task.wait(1)
         VU:Button2Up(Vector2.zero, Cam.CFrame)
      end
   end)

   PlrTab:CreateButton({
      Name="Reset Character",
      Callback=function()
         local h=H2() if h then h.Health=0 end
      end
   })

   -- ── TAB: SETTINGS ──────────────────────────────────────
   local SettingsTab = Window:CreateTab("Settings", "settings")

   SettingsTab:CreateSection("⚙️ Keybinds")

   SettingsTab:CreateDropdown({
      Name="Throw Key",
      Options={"T","Y","G","H","V","B","N"},
      CurrentOption={"T"}, Flag="ThrowKey",
      Callback=function(opt)
         local keyMap = {T=Enum.KeyCode.T,Y=Enum.KeyCode.Y,G=Enum.KeyCode.G,
                         H=Enum.KeyCode.H,V=Enum.KeyCode.V,B=Enum.KeyCode.B,N=Enum.KeyCode.N}
         _G_STATE.ThrowKey = keyMap[opt[1]] or Enum.KeyCode.T
      end
   })

   SettingsTab:CreateSection("🔧 Advanced")

   SettingsTab:CreateButton({
      Name="📋 Dump All Remotes to Clipboard",
      Callback=function()
         local count = dumpRemotes()
         Rayfield:Notify({
            Title   = "Remotes Dumped",
            Content = count.." remotes found — copied to clipboard + saved as CTH_Remotes.txt",
            Duration=5, Image="terminal"
         })
      end
   })

   SettingsTab:CreateButton({
      Name="🗑️ Clear Saved Key (Force Re-Enter)",
      Callback=function()
         pcall(function() delfile(CFG.SAVE_FILE) end)
         Rayfield:Notify({
            Title="Key Cleared",
            Content="Saved key deleted. Re-enter on next launch.",
            Duration=4, Image="trash"
         })
      end
   })

   SettingsTab:CreateButton({
      Name="📋 Copy Position",
      Callback=function()
         local root=R2() if not root then return end
         local p=root.Position
         setclipboard(("Vector3.new(%.2f,%.2f,%.2f)"):format(p.X,p.Y,p.Z))
         Rayfield:Notify({Title="Copied!",Content=("%.1f, %.1f, %.1f"):format(p.X,p.Y,p.Z),Duration=2,Image="copy"})
      end
   })

   Rayfield:LoadConfiguration()
   Rayfield:Notify({
      Title   = "⚡ Catch & Throw Hub Loaded!",
      Content = "Auto-Catch 20Hz | Silent Aim | Reach Bypass\nPress RightShift to toggle UI",
      Duration= 6,
      Image   = "crosshair"
   })

end -- end loadMainScript()

-- ============================================================
-- ENTRY POINT
-- ============================================================

-- 1. Try to load saved key first (skip UI if valid)
task.spawn(function()
   -- Fetch latest keys
   local fetched = fetchKeys()

   -- Check for saved key
   if fetched then
      local saved = loadSavedKey()
      if saved then
         -- Has valid saved key — skip UI, load directly
         tween(blurFX, {Size = 0}, 0.3)
         loadMainScript()
         return
      end
   end

   -- 2. No valid saved key — show key UI
   buildKeyUI(function()
      loadMainScript()
   end)
end)
