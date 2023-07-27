function NetworkedScene(coords, rotation, peds, objects, duration)
    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotation, 2, false, false,
        -1,
        0,
        1.0)

    for k, v in pairs(peds) do
        if v.model and not v.ped then
            while not HasModelLoaded(v.model) do
                RequestModel(v.model)
                Wait(1)
            end

            v.ped = CreatePed(23, v.model, coords.x, coords.y, coords.z, 0.0, true, true)
            v.createdByUs = true
        end
        while not HasAnimDictLoaded(v.anim.dict) do
            RequestAnimDict(v.anim.dict)
            Wait(1)
        end
        NetworkAddPedToSynchronisedScene(v.ped, scene, v.anim.dict, v.anim.anim, 1.5,
            -4.0, 1,
            16,
            1148846080, 0)
    end

    for k, v in pairs(objects) do
        if v.model and not v.object then
            while not HasModelLoaded(v.model) do
                RequestModel(v.model)
                Wait(1)
            end
            v.object = CreateObject(v.model, coords, true, true, true)
            v.createdByUs = true
        end
        while not HasAnimDictLoaded(v.anim.dict) do
            RequestAnimDict(v.anim.dict)
            Wait(1)
        end
        NetworkAddEntityToSynchronisedScene(v.object, scene, v.anim.dict, v.anim.anim,
            1.0,
            1.0, 1)
    end

    NetworkStartSynchronisedScene(scene)
    Wait(duration)
    NetworkStopSynchronisedScene(scene)

    for k, v in pairs(peds) do
        if v.createdByUs then
            DeletePed(v.ped)
        end
    end

    for k, v in pairs(objects) do
        if v.createdByUs then
            DeleteEntity(v.object)
        end
    end
end

exports("NetworkedScene", NetworkedScene)