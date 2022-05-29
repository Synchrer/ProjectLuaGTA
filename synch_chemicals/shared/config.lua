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
    {element = "hydrogen", chemicalSymbol = "H", value = 0}, 
    {element = "nitrogen", chemicalSymbol = "N", value = 0}, 
    {element = "sulfur", chemicalSymbol = "S", value = 0},
    {element = "oxygen", chemicalSymbol = "O", value = 0},
    {element = "agua_quimica", chemicalSymbol = "Na", value = 0},
    {element = "chloride", chemicalSymbol = "Cl", value = 0},
    {element = "carbon", chemicalSymbol = "C", value = 0},
    {element = "potassium", chemicalSymbol = "K", value = 0},
}

-- el campo components tiene el valor asci de la primera letra de cada elemento, ordenados N-78 H-72 Na-78 O-79 C-67 Cl-67 S-83 K-75
  
chemicalCompoundItems = {
    --{compound = "", chemicalSymbol = "", components = {}},
    {compound = "nitrogenHydride", chemicalSymbol = "N+H^3", components = {72,78}}, -- H, N
    {compound = "hydrogenOxide", chemicalSymbol = "H^2+O", components = {72,79}}, -- H, O
    {compound = "prueba", chemicalSymbol = "N^2+H", components = {72,78.1}}, -- H, Na
    {compound = "sodiumChloride", chemicalSymbol = "Na+Cl", components = {67,78.1}}, -- Na, Cl
    {compound = "nitricAcid", chemicalSymbol = "H+N+O^3", components = {72,78,79}}, -- H, N, O
    {compound = "oleicAcid", chemicalSymbol = "C^18+H^34-O^2", components = {67,72,79}}, -- C, H, O
    {compound = "sodiumHydroxide", chemicalSymbol = "Na+O+H", components = {72,78.1,79}}, -- Na, O, H
    {compound = "sulfuricAcid", chemicalSymbol = "H^2+S+O^4", components = {72,79,83}}, -- H, S, O
    {compound = "sulfurousAcid", chemicalSymbol = "H^2+S+O^3", components = {72,79,83}}, -- H, S, O
    {compound = "sodiumCarbonate", chemicalSymbol = "Na^2+C+O^3", components = {67,78.1,79}}, -- Na, C, O
    {compound = "potassiumNitrate", chemicalSymbol = "K+N+O^3", components = {75,78,79}}, -- K, N, O
}

--crear nuevo array

options = {
    ['tanque_quimico'] = {
        prop = 'prop_chem_vial_02',
        success_msg = 'Has colocado la probeta',
        start_msg = 'Empezar a sintetizar.',
        name = 'Producto Quimico',
    },
}
