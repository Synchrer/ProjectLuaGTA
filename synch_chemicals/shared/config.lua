Config = {
    ShowBlips = false,
    minSkillToShowBlips = 10,
    TesterMode = true
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
    {element = "potassium", chemicalSymbol = "K", value = 0}, -- 75
    {element = "nitrogen", chemicalSymbol = "N", value = 0}, -- 78
    {element = "sodium", chemicalSymbol = "Na", value = 0}, -- 78.1
    {element = "oxygen", chemicalSymbol = "O", value = 0}, -- 79
    {element = "sulfur", chemicalSymbol = "S", value = 0}, -- 83
    {element = "zinc", chemicalSymbol = "Z", value = 0}, -- 90
}

-- el campo components tiene el valor asci de la primera letra de cada elemento
chemicalCompoundItems = {
    {compound = "nitricacid", chemicalSymbol = "H+N+O^3", components = {72,78,79}}, -- H, N, O
    {compound = "sulfuricacid", chemicalSymbol = "H^2+S+O^4", components = {72,79,83}}, -- H, S, O
    {compound = "potassiumnitrate", chemicalSymbol = "K+N+O^3", components = {75,78,79}}, -- K, N, O
    {compound = "sal_quimica", chemicalSymbol = "Na+Cl", components = {67.1,78.1}}, -- Na, Cl
    {compound = "mezclapolvora", chemicalSymbol = "S+C", components = {67,83}}, -- S, C
    {compound = "agua_quimica", chemicalSymbol = "H^2+O", components = {72,79}}, -- H, O
    {compound = "etanol", chemicalSymbol = "C^2+H^5+O", components = {67,72,79}}, -- C, H, O
    {compound = "sodiumhydroxide", chemicalSymbol = "Na+O+H", components = {72,78.1,79}}, -- Na, O, H
    {compound = "ethyl", chemicalSymbol = "C^8+H^9", components = {67,72}}, -- C, H
    {compound = "nitrogendioxyde", chemicalSymbol = "N+O^2", components = {78,79}}, -- N, O
    {compound = "basepegamento", chemicalSymbol = "Z^2+H^35+O^2", components = {72,79,90}}, -- Z, H, O

}

finalItems = {
    --{final = ""},
    {final = "polvora"}, -- potassiumNitrate + mezclaPolvora
    {final = "betadine"}, -- sodiumHydroxide + agua_quimica
    {final = "alcohol"}, -- etanol
    {final = "analgesicos"}, -- ethyl + nitrogenDioxyde
    {final = "adhesivo"}, -- agua_quimica + basePegamento
    {final = "gasmechero"}, -- ethyl
    {final = "baseantiquemaduras"}, -- agua_quimica + etanol
    {final = "basejet"}, -- sal_quimica + nitricAcid + sulfuricAcid
    {final = "fertilizantequimico"}, -- potassiumNitrate
}

options = {
    ['tanque_quimico'] = {
        prop = 'prop_chem_vial_02',
        success_msg = 'Has colocado la probeta',
        start_msg = 'Empezar a sintetizar.',
        name = 'Producto Quimico',
    },
}
