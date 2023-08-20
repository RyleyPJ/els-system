local currentStage = 0
local isLightsOn = false
local isSirenActive = false

-- Define light patterns for each stage
local lightPatterns = {
    [1] = {1, 0, 1, 0},  -- Stage 1: Alternating lights
    [2] = {1, 1, 0, 0},  -- Stage 2: Flashing lights
    [3] = {1, 0, 0, 1},  -- Stage 3: Wig-wag lights
    -- Add more patterns as needed
}

-- Function to toggle lights based on pattern
local function toggleLights(pattern)
    for i, state in ipairs(pattern) do
        local lightName = "light_" .. i
        if state == 1 then
            SetEntityLightEnabled(GetVehiclePedIsUsing(PlayerPedId()), lightName, true)
        else
            SetEntityLightEnabled(GetVehiclePedIsUsing(PlayerPedId()), lightName, false)
        end
    end
end

-- This is the function to toggle siren
local function toggleSiren(sirenIndex)
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local sirenState = not isSirenActive
    
    if sirenState then
        TriggerServerEvent("els:activateSiren", sirenIndex)
    else
        TriggerServerEvent("els:deactivateSiren")
    end
    
    isSirenActive = sirenState
end

-- This is the function to switch to the next stage
local function nextStage()
    currentStage = currentStage + 1
    if currentStage > #lightPatterns then
        currentStage = 1
    end
    
    toggleLights(lightPatterns[currentStage])
end

-- This is the main key binding function
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if IsControlJustReleased(0, 246) then -- Change this control to your desired key (default: J)
                nextStage()
            end
            
            if IsControlJustReleased(0, 249) then -- Change this control to your desired key (default: K)
                isLightsOn = not isLightsOn
                
                if isLightsOn then
                    currentStage = 1
                    toggleLights(lightPatterns[currentStage])
                else
                    toggleLights({0, 0, 0, 0})
                end
            end
            
            if IsControlJustReleased(0, 47) then -- Change this control to your desired key (default: G)
                local sirenIndex = 1 -- Replace with the appropriate siren index from WM-serverSirens
                
                if isSirenActive then
                    toggleSiren(sirenIndex)
                end
            end
        end
    end
end)
