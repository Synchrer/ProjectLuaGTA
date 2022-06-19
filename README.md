# SCRIPTS GRAND THEFT AUTO V (GTA) LUA

![Escudo Virgen del Carmen del Departamento de Informática](https://images2.imgbox.com/da/87/loS8hphC_o.png)

## ÍNDICE

1. [INTRODUCIÓN](#intro)
2. [MATERIAL](#mater)
3. [OBJETIVOS](#obj)
4. [DIAGRAMAS](#diag)
5. [METODOLOGÍA](#metod)
    1. [LENGUAJE DE PROGRAMACIÓN - LUA](#leng)
    2. [ESTRUCTURA DEL PROYECTO](#estrc)
    3. [BASE DE DATOS](#bd)
    4. [MANIFEST](#manf)
    5. [CONFIG.LUA](#conf) 
    6. [SERVER.LUA](#serv) 
    7. [CLIENT.LUA](#client) 
6. [RESULTADOS](#res)
7. [PROPUESTA DE MEJORA](#prop)
8. [BIBLIOGRAFÍA](#bibl)

<a name="intro"></a>
## INTRODUCIÓN

  Mi proyecto consiste en una **serie de scripts o mods para el juego Grand Theft Auto V (GTA V)**. **Un mod**, como su propio nombre dice **es una modificación que se implementa en el juego**, es decir, en el juego no existen los caballos por ejemplo, pues mediante el script por código crearemos la modificación que queremos implementar en el juego, en este caso un caballo y luego lo insertaremos en el juego, de manera resumida de esta forma obtendremos un caballo en el juego.
  
  Más específicamente, mis scripts son un **mod de habilidades (Añade al jugador una serie de habilidades que irán subiendo del nivel 0 al 100)** y un **mod de química (Permite al jugador crear compuestos químicos para obtener objetos a partir de ellos, aumenta la rama de Química del mod de habilidades)**.
  
  La idea de realizar este proyecto surgió de que yo, juego a este juego en cuestión y cuando empecé la FP de programación, empecé a trastear todo este tema de crear modificaciones para el juego, hasta que hace un par de meses unos amigos querían abrir un servidor de GTA y yo entré en el proyecto como programador para crear los scripts del servidor.

<a name="mater"></a>
## MATERIAL

- #### **Grand Theft Auto V:** Videojuego donde implemento los scripts que he creado.

- #### **Visual Studio Code (LUA):** entorno de desarrollo que he usado para programar los scripts con el lenguaje LUA.

- #### **XAMPP (MySQL):** sistema de gestión de base de datos, que he usado para crear la base de datos que uso en MySQL

- #### **HeidiSQL:** gestor de base de datos que he usado para gestionar e administrar mi base de datos

- #### **TxAdmin:** es un panel de administración web, usado para crear servidores de Grand Theft Auto V, donde se le pasa los scripts del servidor y los introduce en tu juego.

- #### **GitHub:** software usado para almacenar el proyecto. Además del proyecto un readme, que es la documentación del mismo

- #### **Markdown:** lenguaje usado para la creación de la documentación

- #### **Creately:** herramienta orientada para la creación y diseño de diagramas de todo tipo

- #### **M2pdf:** herramienta usada para transformar README a PDF 

<a name="obj"></a>
## OBJETIVOS

- Creación de una seria de mods para el juego Grand Theft Auto V
    - Mod de habilidades
    - Mod de química
- Conexión entre mods
    - Al realizar mezclas aumentará el nivel de química del jugador
- Implementación de los mods en el juego para su uso
    - Obtener los elementos químicos buscándolos o comprándolos
    - Realizar mezclas a partir de los elementos (Estas deben fallar si la cantidad introducida es errónea)
    - Obtener compuestos químicos a partir de las mezclas de elementos
    - Realizar mezclas a partir de los compuestos (Estas deben fallar si la cantidad introducida es errónea)
    - Obtener objetos útiles para el jugador a partir de la mezcla de compuestos químicos

<a name="diag"></a>
## DIAGRAMAS

![Diagrama de Estados del Mod](https://images2.imgbox.com/e4/73/ySZUTxNH_o.png)
*Diagrama de Estados del Mod*

<a name="metod"></a>
## METODOLOGÍA

<a name="leng"></a>
### LENGUAJE DE PROGRAMACIÓN - LUA 
![Logo Lua](https://images2.imgbox.com/6e/75/abM5UKeV_o.png)

*Logo Lua*

**Lua** es un lenguaje de programación **multiparadigma** (Su semántica puede ser extendida y modificada redefiniendo funciones), **imperativo** (El código define paso por paso lo que debe hacer el equipo para lograr el objetivo) y **estructurado** (Programación orientada a la claridad, se desarrolla únicamente usando funciones), que fue diseñado como un lenguaje interpretado con una semántica extendible. Está diseñado principalmente para ser utilizado de manera incorporada en aplicaciones. Lua es un lenguaje multiplataforma y su intérprete está escrito en ANSI C, el mismo que se usa en el lenguaje de programación **C**.

#### Variables
Lua es un **lenguaje no tipado**, es decir, las variables puedes declararlas como local y puedes introducir cualquier tipo en ellas (boolean, string, int, float)
```
local variable1 = "soy un string"
local variable2 = 26
variable3 = 26.66 
variable4, variable5 = true, false
```

#### Comentarios
Los comentarios en Lua se realizan con dos guiones, similar a los comentarios de SQL.

**Comentario en linea**
```
-- Un comentario en Lua empieza con doble guion hasta la siguiente línea
```
**Comentario en bloque**
```
--[[ Los strings y comentarios multilínea
     se adornan con doble corchete 
  ]]
```

#### Estructuras de datos
Además todas las estructuras de datos como **vectores**, **conjuntos**, **listas**, **arrays**, en Lua se usa una única estructura de datos, **table**. Las tablas no tienen unos huecos definidos, además la posición podrás llamarla a tu gusto, cuando se elimina una de las posiciones de la tabla mueven el objeto que tienen abajo a esa posición a la posición liberada, esto hace que la tabla nunca tenga huecos vacíos.
```
table = {}

table.insert(table, "hueco1")
table["index2"] = "hueco2"
table[3] = "hueco3"
table.remove(table, "hueco2")
```

#### Bucles
En Lua existen cuatro tipos de bucles: **while**, **for numerico**, **for generico** y **repeat**. De todos estos al menos en mi caso, el más usado sería el for genérico y luego bucles while, for numerico no he usado apenas y bucles repeat ni siquiera me han hecho falta.
```
for clave, valor in pairs(table) do
   print(clave)
end
```

#### Aplicación
Sus principales ámbitos de aplicación son los **videojuegos y los motores de juego**, como en mi caso, aunque también se usa para desarrollar **programas de redes y sistemas**.

Personalmente, ha sido un lenguaje sencillo de aprender, aunque tiene ciertas carencias como las tablas, por lo demás un lenguaje muy interesante para aprenderlo o tener conocimientos básicos de él.

<a name="estrc"></a>
### ESTRUCTURA
![Estructura del proyecto](https://images2.imgbox.com/ef/fb/SWMsyu4w_o.png)

*Estructura del proyecto*

La estructura del proyecto sigue el patrón de la estructura hexagonal, donde se busca separar el código orientado al servidor del código orientado al cliente. 

Cada script tiene una estructura básica, en la que tenemos el archivo Manifest y luego tenemos el archivo del servidor, del cliente y el archivo de Configuración, que normalmente cuando un script se pone en venta, el único archivo que puede modificar el cliente sería la configuración, por ello siempre hay que orientar el código a que sea ampliable sin tener que modificar el código.

![Estructura del script](https://images2.imgbox.com/1c/60/1SuMDRN3_o.png)

*Estructura del script*

<a name="bd"></a>
### BASE DE DATOS
![Base de datos | HeidiSQL](https://images2.imgbox.com/e0/21/VvjhJXmw_o.png)

*Base de datos | HeidiSQL*

Para la base de datos he usado MySQL. Las tablas no son relacionales, es decir, no tienen una relación entre ellas pero hay ciertas tablas que necesitan estar conectadas porque comparten información, por ello estas tablas suelen tener una columna en común, que suele ser el id del jugador normalmente. Un ejemplo es la conexión entre la tabla **user**, que son los jugadores y la tabla **habilidades**, que es la tabla que utilizo con el mod de habilidades y donde se guarda el nivel de cada jugado. En la tabla user, cada jugador tiene un id único y luego para realizar la conexión en la tabla habilidades, tenemos una columna en común que sería el id del jugador, así una vez cada que se modifica el nivel del jugador mediante el script de las habilidades, se iría guardando en base de datos según el jugador que haya subido el nivel.

![Tabla User](https://images2.imgbox.com/0e/0c/M8CiDJlL_o.png)

*Tabla User*

![Tabla habilidades](https://images2.imgbox.com/2b/dc/5FTRJmun_o.png)

*Tabla Habilidades*

<a name="manf"></a>
### MANIFEST
El ***manifest***, es el archivo más importante de los scripts, es el primer archivo que el servidor lee de un script. En este archivo es donde se especifica que tiene que leer el servidor para que lo recursos funcionen con éxito. La conexión con la base de datos se realiza en este archivo, para que despues en el archivo del Server podamos modificar las tablas.

#### Manifest del mod de habilidades
Le declaramos que lea todos los archivos que contenga en toda la raíz del script y declaramos la conexión con MySQL, que se encuentra en el archivo de MySQL.lua
```
shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}
```

<a name="conf"></a>
### ARCHIVO CONFIG.LUA
El ***config*** es el archivo orientado a ser modificado por el cliente y como su propio nombre dice es el archivo de configuración. 

Por ejemplo, el config del mod de química es donde agregaremos todos los elementos químicos que queramos;
```
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
```
todos los compuestos químicos;
```
chemicalCompoundItems = {
    {compound = "nitricacid", chemicalSymbol = "HNO3", components = {72,78,79}, value = 0, pos = 1},
    {compound = "sulfuricacid", chemicalSymbol = "H2SO4", components = {72,79,83}, value = 0, pos = 2}, 
    {compound = "potassiumnitrate", chemicalSymbol = "KNO3", components = {75,78,79}, value = 0, pos = 3}, 
    {compound = "sal_quimica", chemicalSymbol = "NaCl", components = {67.1,78.1}, value = 0, pos = 4}, 
    {compound = "mezclapolvora", chemicalSymbol = "SC2", components = {67,83}, value = 0, pos = 5}, 
    {compound = "agua_quimica", chemicalSymbol = "H2O", components = {72,79}, value = 0, pos = 6}, 
    {compound = "etanol", chemicalSymbol = "C2H5O", components = {67,72,79}, value = 0, pos = 7}, 
    {compound = "sodiumhydroxide", chemicalSymbol = "NaOH", components = {72,78.1,79}, value = 0, pos = 8}, 
    {compound = "ethyl", chemicalSymbol = "C8H9", components = {67,72}, value = 0, pos = 9}, 
    {compound = "nitrogendioxyde", chemicalSymbol = "NO2", components = {78,79}, value = 0, pos = 10}, 
    {compound = "basepegamento", chemicalSymbol = "Z2H35O2", components = {72,79,90}, value = 0, pos = 11}, 
    {compound = "oleicacid", chemicalSymbol = "PO2", components = {79, 80}, value = 0, pos = 12},
    {compound = "solucionyodo", chemicalSymbol = "I2C", components = {67, 73}, value = 0, pos = 13},
}
```
y todos los objetos finales;
```
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
```
Como yo he orientado el código a que sea incrementable, se podría añadir nuevos objetos en este archivo sin tener que modificar nada de código.

<a name="serv"></a>
### ARCHIVO SERVER.LUA
El ***servidor*** es el archivo donde se escribe el código que se ejecuta en el servidor y donde haremos el código para modificar o obtener datos de la base de datos.

Una matiz importante es el **ESX**, es un framework básico de GTA el cuál incluye todas las funciones nativas del juego que nos serán útiles, como obtener la posición del jugador o el id de un jugador entre otras. Las funciones más usadas de ESX en el archivo del servidor normalmente son **RegisterServerCallback**, para regitrar funciones asíncronas, **RegisterServerEvent**, para registrar funciones normales, **TriggerClientEvent**, para ejecutar algo en el cliente.

Ejemplos;

#### Obtener el nivel de un jugador
Como he comentado antes usamos el framework ESX, para registrar una funcion de servidor (**ESX.RegisterServerCallback()**) y también lo usamos para obtener el id del jugador (**ESX.GetPlayerFromId()**), una hemos obtenido el id del jugador lo que haremos será buscar la fila de la tabla habilidades que pertenezca a ese jugador, por lo tanto haremos un Select donde el identificador sea igual al que nosotros tenemos, es importante que todas las peticiones a base de datos se realizan con callbacks, puesto que el fetch que realizamos a la base de datos puede ser fallido.
```
ESX.RegisterServerCallback('io_chemicals:getSkillChemicals', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    while xPlayer == nil do
        Citizen.Wait(0)
       xPlayer = ESX.GetPlayerFromId(_source)
    end

    MySQL.Async.fetchAll("SELECT * FROM habilidades WHERE identifier=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data)
        for _,v in pairs(data) do
            skillquimica = v.quimica
        end
        cb(skillquimica)
    end)
end)
```

#### Aumentar el nivel de química
Sería igual que la función anterior, pero despues de obtener la fila de la tabla habilidades, realizaremos otra sentencia, que será un update donde actualizaremos la química o la rama que se quiera aumentar. Por último, envió una notificación al cliente, informando que ha adquirido un nivel.
```
RegisterServerEvent('io_chemicals:addChemicalLvl')
AddEventHandler('io_chemicals:addChemicalLvl', function(puntos)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `quimica` = @quimica WHERE `identifier` = @identifier', {
            ['@quimica'] = (skillInfo[1].quimica + puntos),
			['@identifier'] = xPlayer.identifier
		})
	end)
    TriggerClientEvent("pNotify:SendNotification", source, {text = "Has adquirido habilidades de quimica. Puntos adquiridos: " .. puntos, type = "info", timeout = 4000, layout = "centerLeft"})
end)
```

<a name="client"></a>
### ARCHIVO CLIENT.LUA
Por último, el ***client*** es el archivo donde escribe todo el código que se ejecuta de forma individual por cada jugador del servidor, por lo tanto cada jugador que haga mezclas químicas será independiente de las mezclas químicas que haga otro jugador.

El código del cliente es muy extenso, por lo que mostraré la función final que es usada para obtener los objetos finales, que son aquellos que pueden ser usados de manera activa por los jugadores.

Por ejemplo;

Un jugador quiere obtener **aceite**, el aceite se obtiene a partir de mezclar **etil** (se consigue mezclando **carbono** y **hidrógeno**) y **ácido oleico** (se consigue mezclando **fósforo** y **oxígeno**). Yo para poder comparar las recetas lo que hago es creo un array dentro de cada objeto que es la posición de los compuestos que lo forman, en el aceite sería 9 y 12 (etil y ácido oleico).
```
{final = "aceite", components = {9, 12}}

{compound = "ethyl", chemicalSymbol = "C8H9", components = {67,72}, value = 0, pos = 9}
{compound = "oleicacid", chemicalSymbol = "PO2", components = {79, 80}, value = 0, pos = 12}
```
Declaro la función final y lo que le paso es una lista solo de los compuestos que se hayan introducido en la probeta, entonces lo que hago en una nueva tabla introduzco el index de los compuestos que se encuentra y ordeno esa table, es decir, si queremos hacer aceite e introducimos sus ingrediente, cogera el valor 9 y 12 de esos ingredientes y los guardara en un array.
```
function checkFinalRecipes(compounds)
	centrifugedCompounds = {}
	local finalResult = ''

	for k, v in pairs(compounds) do
		table.insert(centrifugedCompounds, v.posi)
	end

	table.sort(centrifugedCompounds)
```
Una vez tengo la table de los ingrediente solo me queda recorrer cada item final y comparar el table que hemos generado con los ingredientes que hemos introducido con el table que tiene cada item final. Para ello con un for recorro la lista de items finales y voy comparando las dos tables, cuando un table coincida, significa que es la receta que buscamos.
```
local encaja = false
local notEnoughQuantity = false
local finalQuantity = 2
local expQuantity = 0.1

for key, value in pairs(finalItems) do
	if #centrifugedCompounds == #value.components then
		if #centrifugedCompounds == 1 then	
			if centrifugedCompounds[1] == value.components[1] then				
				encaja = true
				finalResult = value.final

				if compounds[1].value >= 99 then
					finalQuantity = 4
					expQuantity = 0.16
				elseif compounds[1].value >= 85 and (compounds[1].value < 99) then
					finalQuantity = 3
					expQuantity = 0.15
				elseif compounds[1].value < 50 then
					notEnoughQuantity = true
				end

			end
		elseif #centrifugedCompounds == 2 then
			if centrifugedCompounds[1] == value.components[1] and centrifugedCompounds[2] == value.components[2] then
				encaja = true
				finalResult = value.final
				if compounds[1].value >= 99 and compounds[2].value >= 99 then
					finalQuantity = 4
					expQuantity = 0.18
				elseif compounds[1].value >= 85 and compounds[2].value >= 85 and (compounds[1].value < 99 or compounds[2].value < 99) then
					finalQuantity = 3
					expQuantity = 0.17
				elseif compounds[1].value < 50 or compounds[2].value < 50 then
					notEnoughQuantity = true
				end
			end			
		elseif #centrifugedCompounds == 3 then
			if centrifugedCompounds[1] == value.components[1] and centrifugedCompounds[2] == value.components[2] and centrifugedCompounds[3] == value.components[3] then
				encaja = true
				finalResult = value.final

				if compounds[1].value >= 99 and compounds[2].value >= 99 and compounds[3].value >= 99 then
					finalQuantity = 4
					expQuantity = 0.20
				elseif compounds[1].value >= 85 and compounds[2].value >= 85 and compounds[3].value >= 85 and (compounds[1].value < 99 or compounds[2].value < 99 or compounds[3].value < 99) then
					finalQuantity = 3
					expQuantity = 0.19
				elseif compounds[1].value < 50 or compounds[2].value < 50 or compounds[3].value < 50 then
					notEnoughQuantity = true
				end

			end
			end
		end
	end
```
A su vez hice un control de las posibles diferentes salidas que podía haber al final del programa:
* Si la salida es correcta (encaja es true) y no se ha superado 100 de quimico (fallo = false), ni introducido menos de 50 de quimico (notEnoughQuantity = false), entonces el jugador recibirá el objeto final y aumentará el nivel de químico
* Si la salida es correcta, pero se ha introducido menos de 50 de químico (se consideran insuficientes, notEnoughQuantity = true), será una salida errónea, notificará al jugador con un mensaje y aumentará el nivel de químico un poco.
* Si la salida es correcta, pero se ha introducido más de 100 de químico (se considera excendencia, fallo = true), será una salida errónea, notificará al jugador con un mensaje y aumentará el nivel de químico un poco.
* Si la salida es incorrecta (los ingredientes introducidos no forman ningún item final, encaja = false), será una salida errónea, notificará al jugador con un mensaje y aumentará el nivel de químico un poco.
```
if encaja then
		if not fallo and not notEnoughQuantity then		
			TriggerServerEvent('io_chemicals:addItem', finalResult, finalQuantity)
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', expQuantity) end
		elseif notEnoughQuantity then
			exports.pNotify:SendNotification({text = "Has introducido pocos compuestos y la mezcla no se ha podido sintentizar", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.05) end
			fallo = false
			notEnoughQuantity = false
		else 
			exports.pNotify:SendNotification({text = "Te has pasado y el resultado es inútil", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
			fallo = false
			notEnoughQuantity = false
		end
	else
		exports.pNotify:SendNotification({text = "La mezcla ha fallado", type = "error", timeout = 4000, layout = "centerLeft"})
		if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
		fallo = false
		notEnoughQuantity = false
	end
end
```


<a name="res"></a>
## RESULTADOS

- Creación de una seria de mods para el juego Grand Theft Auto V&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Mod de habilidades&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Mod de química&nbsp;&nbsp;&nbsp;&nbsp;**✓**
- Conexión entre mods&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Al realizar mezclas aumentará el nivel de química del jugador&nbsp;&nbsp;&nbsp;&nbsp;**✓**
- Implementación de los mods en el juego para su uso&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Obtener los elementos químicos buscándolos o comprándolos&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Realizar mezclas a partir de los elementos (Estas deben fallar si la cantidad introducida es errónea)&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Obtener compuestos químicos a partir de las mezclas de elementos&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Realizar mezclas a partir de los compuestos (Estas deben fallar si la cantidad introducida es errónea)&nbsp;&nbsp;&nbsp;&nbsp;**✓**
    - Obtener objetos útiles para el jugador a partir de la mezcla de compuestos químicos&nbsp;&nbsp;&nbsp;&nbsp;**✓**

<a name="prop"></a>
## PROPUESTA DE MEJORA

- Desprocesamiento de materiales, es decir, desde un objeto final llegar a comseguir sus compuestos o elementos químicos
- Obtención de los elementos de forma natural, mediante minería, etc
- Diferentes tipos de probetas (para distintos tipos de fusión y de distintos tamaños para obtener menor o mayor cantidad de materiales) y mesas de laboratorio para el sintetizado de materiales
- Separar las recetas respecto al nivel del jugador
- Implementar explosión y gas tóxico si se hacen mezclas con cantidades excesivas
- Implementar nuevos crafteos

<a name="bibl"></a>
## BIBLIOGRAFÍA

- [Información sobre Lua](https://www.lua.org/pil/contents.html#P1)
- [Funciones nativas del juego](https://docs.fivem.net/natives/)
- [Documentación Markdown](https://www.markdownguide.org/basic-syntax)
- [Creately](https://creately.com/)
- [Convertidor de MD a PDF](https://md2pdf.netlify.app/)
