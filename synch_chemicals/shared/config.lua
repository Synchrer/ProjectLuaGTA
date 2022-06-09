Config = {
    ShowBlips = false,
    SkillSystem = true,
    minSkillToShowBlips = 10,
    TesterMode = false
}

labBlips = {
    {x = 2432.68, y = 4966.36, z = 42.35},
    {x = 1841.53, y = 3660.64, z = 34.22}
}

chemicalPureItems = {
    --{element = , chemicalSymbol = ""},
    {element = "carbon", chemicalSymbol = "C", value = 0}, -- 67
    {element = "chloride", chemicalSymbol = "Cl", value = 0}, -- 67.1
    {element = "hydrogen", chemicalSymbol = "H", value = 0}, -- 72
    {element = "iodo", chemicalSymbol = "I", value = 0}, -- 73
    {element = "potassium", chemicalSymbol = "K", value = 0}, -- 75
    {element = "nitrogen", chemicalSymbol = "N", value = 0}, -- 78
    {element = "sodium", chemicalSymbol = "Na", value = 0}, -- 78.1
    {element = "oxygen", chemicalSymbol = "O", value = 0}, -- 79
    {element = "phosphorus", chemicalSymbol = "P", value = 0}, -- 80
    {element = "sulfur", chemicalSymbol = "S", value = 0}, -- 83
    {element = "zinc", chemicalSymbol = "Z", value = 0}, -- 90
}

-- el campo components tiene el valor asci de la primera letra de cada elemento
chemicalCompoundItems = {
    {compound = "nitricacid", chemicalSymbol = "HNO3", components = {72,78,79}, value = 0, pos = 1}, -- H, N, O  //  H+N+O^3
    {compound = "sulfuricacid", chemicalSymbol = "H2SO4", components = {72,79,83}, value = 0, pos = 2}, -- H, S, O // H^2+S+O^4
    {compound = "potassiumnitrate", chemicalSymbol = "KNO3", components = {75,78,79}, value = 0, pos = 3}, -- K, N, O // K+N+O^3
    {compound = "sal_quimica", chemicalSymbol = "NaCl", components = {67.1,78.1}, value = 0, pos = 4}, -- Na, Cl //  Na+Cl
    {compound = "mezclapolvora", chemicalSymbol = "SC2", components = {67,83}, value = 0, pos = 5}, -- S, C // S+C
    {compound = "agua_quimica", chemicalSymbol = "H2O", components = {72,79}, value = 0, pos = 6}, -- H, O // H^2+O
    {compound = "etanol", chemicalSymbol = "C2H5O", components = {67,72,79}, value = 0, pos = 7}, -- C, H, O // C^2+H^5+O
    {compound = "sodiumhydroxide", chemicalSymbol = "NaOH", components = {72,78.1,79}, value = 0, pos = 8}, -- Na, O, H // Na+O+H
    {compound = "ethyl", chemicalSymbol = "C8H9", components = {67,72}, value = 0, pos = 9}, -- C, H // C^8+H^9
    {compound = "nitrogendioxyde", chemicalSymbol = "NO2", components = {78,79}, value = 0, pos = 10}, -- N, O // N+O^2
    {compound = "basepegamento", chemicalSymbol = "Z2H35O2", components = {72,79,90}, value = 0, pos = 11}, -- Z, H, O // Z^2+H^35+O^2
    {compound = "oleicacid", chemicalSymbol = "PO2", components = {79, 80}, value = 0, pos = 12}, -- P, O // P+O^2
    {compound = "solucionyodo", chemicalSymbol = "I2C", components = {67, 73}, value = 0, pos = 13}, -- I, C // I^2+C
}

-- el campo components tiene el campo pos, de la lista de chemicalCompoundItems
finalItems = {
    --{final = "", components = {}},
    {final = "polvora", components = {3, 5}}, -- potassiumnitrate + mezclapolvora
    {final = "betadine", components = {13}}, -- solucionyodo
    {final = "alcohol", components = {7}}, -- etanol
    {final = "analgesicos", components = {9, 10}}, -- ethyl + nitrogendioxyde
    {final = "adhesivo", components = {6, 11}}, -- agua_quimica + basepegamento
    {final = "gasmechero", components = {9}}, -- ethyl
    {final = "baseantiquemaduras", components = {6, 7}}, -- agua_quimica + etanol
    {final = "basejet", components = {1, 2, 4}}, -- sal_quimica + nitricacid + sulfuricacid
    {final = "fertilizantequimico", components = {3}}, -- potassiumnitrate
    {final = "aceite", components = {9, 12}}, -- ethyl + oleicacid
}

options = {
    ['tanque_quimico'] = {
        prop = 'prop_chem_vial_02',
        success_msg = 'Has colocado la probeta',
        start_msg = 'Empezar a sintetizar',
        name = 'Sintetizando elementos',
    },
}

