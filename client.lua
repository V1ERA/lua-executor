local nuiActive = false

Citizen.CreateThread(function()
    closeEditor()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 57) then
            if not nuiActive then
                openEditor()
            end
        end
    end
end)

RegisterCommand('le', function()
    if not nuiActive then
        openEditor()
    end
end, false)

function openEditor()
    nuiActive = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'showEditor' })
end

RegisterNUICallback('executeCode', function(data, cb)
    local code = data.code
    local fn, err = load(code)
    if fn then
        pcall(fn)
    else
        print("Error loading script: " .. err)
    end
    closeEditor()
    cb('ok')
end)

RegisterNUICallback('closeEditor', function(_, cb)
    closeEditor()
    cb('ok')
end)

function closeEditor()
    nuiActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideEditor' })
end
