Config = {}

Config.itemConfig = {
    ["removeitem"] = true,  -- true/false If true then remove value in ["item"]
    ["item"] = "lockpick",  -- Item need to use cart
    ["command"] = "hostage" -- Item need to use cart
}

Config.pedsModel = {
    'CSB_Mimi',
    'a_m_y_bevhills_01',
    -- U can add more
}

Config.hostageConfig = {
    ["FreezePed"] = true,             -- true/false
    ["InvinciblePed"] = true,         -- true/false
    ["BlockTemporaryEvents"] = true,  -- true/false
    ["PedDiesWhenInjured"] = false,   -- true/false
}

Config.locales = {
    ['success_createhostage'] = "Pomyślnie użyto karty zakładnika!",
    ['letout_hostage'] = "Wypuść zakładnika",
    ['hostage_out'] = "Wypuściłeś zakładnika!",
    ['no_item'] = "Nie masz wymaganego przedmiotu!",
    ['helpnotification'] = "~INPUT_CONTEXT~ aby ustawić zakładnika~n~~INPUT_VEH_DUCK~ aby anulować",
}
