-- // Pequeno Bypass
game:GetService("ReplicatedStorage").ExploitEvent2:Destroy()
game:GetService("ReplicatedStorage").WebhookEvent:Destroy()

-- // Variáveis
_G.LoopLights = false
_G.LoopDoor = false
_G.LoopTower = false
_G.AutoSprint = false
_G.Version = "2.4"
_G.Developer = "Ruan C. (oruancss#0290)"
_G.Supporter = "Gabriel B. (Atryous#6471)"

-- // Funções
function InfStamina()
	for _,v in pairs(getloadedmodules()) do 
		if v.Name == "M_H" then
			local module = require(v)
			local old; old = hookfunction(module.TakeStamina, function(smth, amount)
				if amount > 0 then return old(smth, -0.5) end 
				return old(smth, amount)
			end)
		end
	end
end

function FullBright()
	game:GetService("Lighting").Brightness = 2
	game:GetService("Lighting").FogEnd = 999999
	game:GetService("ReplicatedStorage").CurrentLightingProperties.Brightness.Value = 2
	game:GetService("ReplicatedStorage").CurrentLightingProperties.FogEnd.Value = 999999
	for _,v in pairs(game:GetService("ReplicatedStorage").DayProperties:GetChildren()) do 
		game:GetService("Lighting")[v.Name] = v.Value
		if game:GetService("ReplicatedStorage").CurrentLightingProperties:FindFirstChild(v.Name) then 
			game:GetService("ReplicatedStorage").CurrentLightingProperties[v.Name].Value = v.Value
		end
	end
end

function Velocidade()
	if _G.AutoSprint == true then
		game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 25
	end
end

function LoopVelocidade()
	game:GetService("RunService").RenderStepped:Connect(function()
		Velocidade()
	end)
end

function CriaESP(texto, r, g, b, fontSize)
	local Herades = Instance.new("BillboardGui", parent)
	Herades.Name = ("HeraGUI")
	Herades.AlwaysOnTop = true
	Herades.ExtentsOffset = Vector3.new(0, 0, 0)
	Herades.Size = UDim2.new(1, 0, 1, 0)
	local nam = Instance.new("TextLabel", Herades)
	nam.Text = texto
	nam.BackgroundTransparency = 1
	nam.TextSize = fontSize
	nam.Font = Enum.Font.GothamSemibold
	nam.TextColor3 = Color3.fromRGB(r, g, b)
	nam.Size = UDim2.new(1, 0, 1, 0)
end

-- // Base dos comandos
game:GetService("Players").LocalPlayer.Chatted:Connect(function(HeraComando)
	if (string.lower(HeraComando) == ";door") then -- Comando de abrir/fechar a porta.
        	game:GetService("Workspace").Map.SafeHouse.Door.RemoteEvent:FireServer("Door")
	elseif (string.lower(HeraComando) == ";lights") then -- Comando de acender/apagar luz.
		game:GetService("Workspace").Map.SafeHouse.Door.RemoteEvent:FireServer("Light")
	elseif (string.lower(HeraComando) == ";tlights") then -- Comando de acender/apagar luz da torre.
        	game:GetService("Workspace").Map.ObservationTower.Lights.RemoteEvent:FireServer("Light")
	elseif (string.lower(HeraComando) == ";nofall") then -- Comando que tira o dano de queda.
		game:GetService("ReplicatedStorage")["FD_Event"]:Destroy()
	elseif (string.lower(HeraComando) == ";infstamina") then -- Comando que deixa a stamina infinita.
		InfStamina()
	elseif (string.lower(HeraComando) == ";fullbright") then -- Comando de fullbright.
		game:GetService("RunService").RenderStepped:Connect(FullBright)
	end
	if (string.lower(HeraComando) == ";autosprint" and _G.AutoSprint == false) then -- Comando de correr automaticamente
		_G.AutoSprint = true
		LoopVelocidade()
	elseif (string.lower(HeraComando) == ";unautosprint" and _G.AutoSprint == true) then -- Comando que desativa o correr automaticamente
		_G.AutoSprint = false
	end
	if (string.lower(HeraComando) == ";looplights" and _G.LoopLights == false) then -- Comando que coloca as luzes em loop de acender e apagar.
		_G.LoopLights = true
		repeat
			game:GetService("Workspace").Map.SafeHouse.Door.RemoteEvent:FireServer("Light")
			wait(2)
		until _G.LoopLights == false
	elseif (string.lower(HeraComando) == ";unlooplights" and _G.LoopLights == true) then -- Comando que desativa o loop das luzes.
		_G.LoopLights = false
	end
	if (string.lower(HeraComando) == ";loopdoor" and _G.LoopDoor == false) then -- Comando de loop para fechar e abrir a porta.
		_G.LoopDoor = true
		repeat
			game:GetService("Workspace").Map.SafeHouse.Door.RemoteEvent:FireServer("Door")
			wait(2)
		until _G.LoopDoor == false
	elseif (string.lower(HeraComando) == ";unloopdoor" and _G.LoopDoor == true) then -- Comando que desativa o loop para fechar e abrir a porta.
		_G.LoopDoor = false
	end
	if (string.lower(HeraComando) == ";looptlights" and _G.LoopTower == false) then -- Comando de loop das luzes da torre.
		_G.LoopTower = true
		repeat
			game:GetService("Workspace").Map.ObservationTower.Lights.RemoteEvent:FireServer("Light")
			wait(2)
		until _G.LoopTower == false
	elseif (string.lower(HeraComando) == ";unlooptlights" and _G.LoopTower == true) then -- Comando que desativa o loop das luzes da torre.
		_G.LoopTower = false
	end
	if (string.lower(HeraComando) == ";scrapesp") then -- Comando de ESP para scraps.
		for _,HeraScrap in pairs(game:GetService("Workspace").Filter.ScrapSpawns:GetDescendants()) do
			if HeraScrap:IsA("Model") and HeraScrap:FindFirstChild("Scrap") then
				for _,HS in pairs(HeraScrap:GetChildren()) do
					HS.ChildAdded:Connect(function(objeto)
						CriaESP("Scrap", 128, 0, 128, 18)
					end)
				end
			end
		end
	end
end)
