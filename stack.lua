local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StockBotGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, -225, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 45)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
header.Text = "🌱 Stock Bot v1.1"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 26
header.Parent = frame

local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 45, 0, 45)
btnMinimize.Position = UDim2.new(0, 0, 0, 0)
btnMinimize.BackgroundColor3 = Color3.fromRGB(30, 90, 220)
btnMinimize.Text = "_"
btnMinimize.TextColor3 = Color3.new(1,1,1)
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 30
btnMinimize.Parent = frame

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 45, 0, 45)
btnClose.Position = UDim2.new(1, -45, 0, 0)
btnClose.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
btnClose.Text = "X"
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 26
btnClose.Parent = frame

-- Webhook input
local webhookBox = Instance.new("TextBox")
webhookBox.Size = UDim2.new(0.9, 0, 0, 45)
webhookBox.Position = UDim2.new(0.05, 0, 0, 65)
webhookBox.PlaceholderText = "Wklej URL webhooka Discord tutaj"
webhookBox.Text = ""
webhookBox.TextColor3 = Color3.fromRGB(230, 230, 230)
webhookBox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
webhookBox.BorderSizePixel = 0
webhookBox.ClearTextOnFocus = false
webhookBox.Font = Enum.Font.Gotham
webhookBox.TextSize = 18
webhookBox.Parent = frame

-- Role ID input
local roleBox = Instance.new("TextBox")
roleBox.Size = UDim2.new(0.9, 0, 0, 40)
roleBox.Position = UDim2.new(0.05, 0, 0, 115)
roleBox.PlaceholderText = "Wpisz ID roli do pingowania (np. 1234567890)"
roleBox.Text = ""
roleBox.TextColor3 = Color3.fromRGB(230, 230, 230)
roleBox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
roleBox.BorderSizePixel = 0
roleBox.ClearTextOnFocus = false
roleBox.Font = Enum.Font.Gotham
roleBox.TextSize = 16
roleBox.Parent = frame

-- Przełącznik Auto-send
local autoSendLabel = Instance.new("TextLabel")
autoSendLabel.Size = UDim2.new(0.5, 0, 0, 30)
autoSendLabel.Position = UDim2.new(0.05, 0, 0, 165)
autoSendLabel.BackgroundTransparency = 1
autoSendLabel.Text = "Automatyczne wysyłanie"
autoSendLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
autoSendLabel.Font = Enum.Font.Gotham
autoSendLabel.TextSize = 18
autoSendLabel.TextXAlignment = Enum.TextXAlignment.Left
autoSendLabel.Parent = frame

local autoSendToggle = Instance.new("TextButton")
autoSendToggle.Size = UDim2.new(0.3, 0, 0, 30)
autoSendToggle.Position = UDim2.new(0.55, 0, 0, 165)
autoSendToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoSendToggle.Text = "OFF"
autoSendToggle.TextColor3 = Color3.new(1,1,1)
autoSendToggle.Font = Enum.Font.GothamBold
autoSendToggle.TextSize = 18
autoSendToggle.Parent = frame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: oczekiwanie"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 16
statusLabel.TextWrapped = true
statusLabel.Parent = frame

-- Manual send button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.9, 0, 0, 50)
sendBtn.Position = UDim2.new(0.05, 0, 0, 260)
sendBtn.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
sendBtn.Text = "Wyślij stock ręcznie"
sendBtn.TextColor3 = Color3.new(1,1,1)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 22
sendBtn.Parent = frame

local minimized = false
btnMinimize.MouseButton1Click:Connect(function()
	if minimized then
		frame.Size = UDim2.new(0, 450, 0, 320)
		frame.Position = UDim2.new(0.5, -225, 0.5, -160)
		for _, child in ipairs(frame:GetChildren()) do
			if child ~= btnMinimize and child ~= btnClose and child ~= header then
				child.Visible = true
			end
		end
		minimized = false
	else
		frame.Size = UDim2.new(0, 140, 0, 50)
		frame.Position = UDim2.new(0, 10, 0, 10)
		for _, child in ipairs(frame:GetChildren()) do
			if child ~= btnMinimize and child ~= btnClose and child ~= header then
				child.Visible = false
			end
		end
		minimized = true
	end
end)

btnClose.MouseButton1Click:Connect(function()
	screenGui:Destroy()
	warn("[StockBot] Skrypt wyłączony")
end)

-- TU TWÓJ ORYGINALNY KOD DO STOCKA I WEBHOOKA (skrócony i dostosowany):

local function MakeStockString(Stock)
	local str = ""
	for i, v in pairs(Stock) do
		if type(v) == "table" and v.Stock and v.EggName then
			str = str .. v.EggName .. " **x" .. v.Stock .. "**\n"
		end
	end
	return str
end

local function GetDataPacket(Data, Target)
	for i,v in pairs(Data) do
		if v[1] == Target then
			return v[2]
		end
	end
	return nil
end

local function sendWebhook(url, roleId, stockString)
	if url == "" then
		statusLabel.Text = "Status: Wpisz URL webhooka!"
		return
	end

	local ping = ""
	if roleId ~= "" then
		ping = "<@&"..roleId.."> "
	end

	local body = {
		embeds = {{
			color = 7506394,
			fields = {
				{
					name = "Stock Update",
					value = ping..stockString,
					inline = false,
				},
			},
			footer = {text = "StockBot by Bartosz"},
			timestamp = DateTime.now():ToIsoDate()
		}},
		username = "StockBot",
	}

	local json = HttpService:JSONEncode(body)

	local success, err = pcall(function()
		request({
			Url = url,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = json,
		})
	end)

	if success then
		statusLabel.Text = "Status: Webhook wysłany pomyślnie! 🚀"
	else
		statusLabel.Text = "Status: Błąd wysyłki webhooka: " .. tostring(err)
	end
end

-- Funkcja która pobiera stock i wyśle webhook

local function fetchAndSendStock()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local stockGui = playerGui:FindFirstChild("StockGui") -- Dopasuj nazwę jeśli inna
	if not stockGui then
		statusLabel.Text = "Status: Nie znaleziono StockGui"
		return
	end

	local stockDataRaw = stockGui:FindFirstChild("Stock") and stockGui.Stock:GetChildren() or {}
	local stock = {}

	for _, v in pairs(stockDataRaw) do
		if v:IsA("Frame") then
			local eggName = v:FindFirstChild("EggName")
			local stockAmount = v:FindFirstChild("Stock")

			if eggName and stockAmount then
				local eggNameText = eggName.Text or "Unknown"
				local stockNum = tonumber(stockAmount.Text) or 0
				table.insert(stock, {Stock = stockNum, EggName = eggNameText})
			end
		end
	end

	local stockString = MakeStockString(stock)
	sendWebhook(webhookBox.Text, roleBox.Text, stockString)
end

sendBtn.MouseButton1Click:Connect(fetchAndSendStock)

local autoSending = false
local autoSendCoroutine

autoSendToggle.MouseButton1Click:Connect(function()
	autoSending = not autoSending
	if autoSending then
		autoSendToggle.Text = "ON"
		autoSendToggle.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
		statusLabel.Text = "Status: Automatyczne wysyłanie WŁĄCZONE"

		autoSendCoroutine = coroutine.create(function()
			while autoSending do
				fetchAndSendStock()
				wait(60) -- co 60 sekund
			end
		end)
		coroutine.resume(autoSendCoroutine)
	else
		autoSendToggle.Text = "OFF"
		autoSendToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		statusLabel.Text = "Status: Automatyczne wysyłanie WYŁĄCZONE"
		autoSending = false
	end
end)
