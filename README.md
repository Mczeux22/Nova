# Nova
> Bibliothèque utilitaire Luau — Partagée entre les projets Roblox de Lopapon

---

## Patch Notes

### v0.4.0 — Nova.Table (current)
- Ajout du module `Table` avec 3 sous-modules : `Copy`, `Mutation`, `Search`
- 11 fonctions utilitaires pour la manipulation de tables
- Mise à jour de `Nova/init.lua` avec `Nova.Table`

### v0.3.0 — Nova.Math
- Ajout du module `Math` avec 5 sous-modules : `Interpolation`, `Clamp`, `Rounding`, `Geometry`, `Random`
- 19 fonctions utilitaires couvrant les besoins d'un survivor-like
- Fix collision de noms sur `Random.new()` (capture du built-in avant déclaration de la table locale)
- Mise à jour de `Nova/init.lua` avec `Nova.Math`

### v0.2.0 — Signal:Wait()
- Ajout de `Signal:Wait()` : bloque le thread courant jusqu'au prochain `:Fire()` via coroutines
- Ajout de `Wait` dans `export type Signal`

### v0.1.0 — Signal
- Ajout du module `Signal` : classe complète avec `Connect`, `Fire`, `Disconnect`, `DisconnectAll`
- Ajout du point d'entrée `Nova/init.lua`
- Structure de dossiers Rojo (pattern `init.lua`) mise en place
- Mode `--!strict` avec types exportés (`Connection`, `Signal`)

---

## Structure

```
ReplicatedStorage/
└── Nova/
    ├── init.lua              ← Point d'entrée principal (Nova.Signal, Nova.Math, Nova.Table)
    ├── Signal/
    │   ├── init.lua          ← Expose Signal.lua
    │   └── Signal.lua        ← Classe Signal complète
    ├── Math/
    │   ├── init.lua          ← Agrège tous les sous-modules Math
    │   ├── Interpolation.lua ← lerp, smoothLerp, easeIn, easeOut, easeInOut
    │   ├── Clamp.lua         ← clamp, clampMin, clampMax
    │   ├── Rounding.lua      ← round, floor, ceil, roundTo
    │   ├── Geometry.lua      ← distance2D, distance3D, angleBetween, normalize2D, isInRange2D
    │   └── Random.lua        ← randomFloat, randomInt, randomSign, chance, randomAngle
    └── Table/
        ├── init.lua          ← Agrège tous les sous-modules Table
        ├── Copy.lua          ← shallowCopy, deepCopy
        ├── Mutation.lua      ← merge, filter, map, reverse, shuffle
        └── Search.lua        ← find, findAll, contains, isEmpty
```

---

## Installation

```lua
local Nova = require(game.ReplicatedStorage.Nova)
```

---

## Modules

### `Nova.Signal`

Système d'événements custom en Luau pur, sans dépendance à des Instances Roblox (`BindableEvent`). Permet de faire communiquer des systèmes indépendants sans couplage direct.

---

#### `Signal.new()` → `Signal`

Crée une nouvelle instance de Signal. Chaque instance possède sa propre liste d'abonnés, indépendante des autres signaux.

```lua
local mySignal = Nova.Signal.new()
```

---

#### `Signal:Connect(callback)` → `Connection`

Abonne une fonction au signal. La fonction sera appelée à chaque `:Fire()` avec les arguments transmis.
Retourne un objet `Connection` qui permet de se désabonner plus tard via `:Disconnect()`.

```lua
local connection = mySignal:Connect(function(data)
	print("Reçu :", data)
end)
```

| Paramètre | Type | Description |
|---|---|---|
| `callback` | `(...any) -> ()` | Fonction appelée à chaque Fire |

---

#### `Signal:Fire(...)` — déclenche l'événement

Notifie tous les abonnés du signal en leur transmettant les arguments fournis.
Accepte un nombre illimité d'arguments via varargs (`...`).

```lua
mySignal:Fire("hello")           -- 1 argument
mySignal:Fire(enemy, player, 42) -- plusieurs arguments
```

---

#### `connection:Disconnect()` — se désabonner

Arrête d'écouter le signal pour ce callback précis. À appeler quand un objet est détruit pour éviter les fuites mémoire (ex : un ennemi mort qui restait abonné à un signal).

Méthode disponible sur l'objet `Connection` retourné par `:Connect()`, pas sur le signal lui-même.

```lua
local conn = mySignal:Connect(function() end)
conn:Disconnect()
```

---

#### `Signal:DisconnectAll()` — vider tous les abonnés

Coupe tous les abonnements du signal d'un coup.
Utile au cleanup d'une run (ex : fin de partie dans `RunManager`, tous les signals de la run sont vidés).

```lua
mySignal:DisconnectAll()
```

---

#### `Signal:Wait()` → `...any`

Bloque le thread courant jusqu'au prochain `:Fire()` et retourne les arguments transmis.
Utilise les coroutines Luau : le thread est mis en pause via `coroutine.yield()` et reprend automatiquement via `coroutine.resume()` quand Fire est appelé.
Utile pour les freeze-time entre vagues ou au levelup (même principe que dans Megabonk).

```lua
local choix = LevelUpSignal:Wait()
appliquerUpgrade(player, choix)
relancerVague()
```

---

### `Nova.Math`

Utilitaires mathématiques regroupés en 5 sous-modules. Toutes les fonctions sont accessibles directement via `Nova.Math.nomFonction()`.

---

#### Interpolation

##### `Math.lerp(a, b, t)` → `number`
Interpolation linéaire entre `a` et `b` selon `t` (0 = a, 1 = b).
Usage : smooth des barres de vie, transitions UI.
```lua
Nova.Math.lerp(0, 100, 0.5) -- → 50
```

##### `Math.smoothLerp(a, b, t)` → `number`
Interpolation lissée (courbe en S via formule smoothstep). Plus naturel que lerp pour les mouvements de caméra ou d'UI.
```lua
Nova.Math.smoothLerp(0, 100, 0.5) -- → 50 mais avec accélération/décélération
```

##### `Math.easeIn(a, b, t)` → `number`
Accélération progressive (démarre lentement, finit vite).
Usage : projectile qui accélère, ennemi qui charge.

##### `Math.easeOut(a, b, t)` → `number`
Décélération progressive (démarre vite, finit lentement).
Usage : UI qui glisse et s'arrête, knockback d'ennemi.

##### `Math.easeInOut(a, b, t)` → `number`
Accélération puis décélération (courbe en S plus prononcée que smoothLerp).
Usage : transitions de caméra, animations de levelup.

---

#### Clamp

##### `Math.clamp(value, min, max)` → `number`
Limite une valeur entre `min` et `max`.
```lua
Nova.Math.clamp(hp - damage, 0, maxHp) -- HP ne peut pas descendre sous 0 ni dépasser maxHp
```

##### `Math.clampMin(value, min)` → `number`
Limite une valeur à un minimum seulement.
```lua
Nova.Math.clampMin(damage, 1) -- les dégâts ne peuvent pas descendre sous 1
```

##### `Math.clampMax(value, max)` → `number`
Limite une valeur à un maximum seulement.
```lua
Nova.Math.clampMax(speed, 50) -- vitesse max d'un projectile
```

---

#### Rounding

##### `Math.round(value)` → `number`
Arrondi classique au nombre entier le plus proche.
```lua
Nova.Math.round(12.7) -- → 13
```

##### `Math.floor(value)` → `number`
Arrondi au nombre entier inférieur.
```lua
Nova.Math.floor(12.9) -- → 12
```

##### `Math.ceil(value)` → `number`
Arrondi au nombre entier supérieur.
```lua
Nova.Math.ceil(12.1) -- → 13
```

##### `Math.roundTo(value, decimals)` → `number`
Arrondi à N décimales.
```lua
Nova.Math.roundTo(87.556, 2) -- → 87.56
```

---

#### Geometry

##### `Math.distance2D(a, b)` → `number`
Distance entre deux positions 2D (ignore la hauteur Y).
Usage : vérifier si un ennemi est dans le rayon d'attaque.
```lua
Nova.Math.distance2D(player.Position, enemy.Position) -- → distance en studs
```

##### `Math.distance3D(a, b)` → `number`
Distance entre deux positions 3D (prend en compte Y).
Usage : projectiles, sorts à portée en 3D.

##### `Math.angleBetween(from, to)` → `number`
Angle en radians entre deux positions 2D (X et Z).
Usage : orienter un projectile ou un ennemi vers une cible.

##### `Math.normalize2D(direction)` → `Vector3`
Normalise une direction 2D pour obtenir un vecteur unitaire (longueur = 1).
Usage : déplacement à vitesse constante vers une cible.

##### `Math.isInRange2D(origin, target, range)` → `boolean`
Vérifie si une position est dans un rayon donné (2D).
Usage : détection de portée d'attaque, aggro d'ennemis.
```lua
if Nova.Math.isInRange2D(player.Position, enemy.Position, 10) then
    -- attaque !
end
```

---

#### Random

##### `Math.randomFloat(min, max)` → `number`
Nombre aléatoire décimal entre `min` et `max`.
```lua
Nova.Math.randomFloat(8.5, 12.3) -- variance des dégâts
```

##### `Math.randomInt(min, max)` → `number`
Nombre entier aléatoire entre `min` et `max` (inclus).
```lua
Nova.Math.randomInt(3, 7) -- nombre d'ennemis dans une vague
```

##### `Math.randomSign()` → `number`
Retourne aléatoirement `1` ou `-1`.
Usage : direction aléatoire, variation de position de spawn.

##### `Math.chance(probability)` → `boolean`
Retourne `true` avec une probabilité donnée (entre 0 et 1).
```lua
Nova.Math.chance(0.15) -- 15% de chance de coup critique
Nova.Math.chance(0.25) -- 25% de chance de drop
```

##### `Math.randomAngle()` → `number`
Angle aléatoire en radians entre 0 et 2π.
Usage : direction de spawn d'ennemi autour du joueur.

---

### `Nova.Table`

Utilitaires de manipulation de tables regroupés en 3 sous-modules. Toutes les fonctions sont accessibles via `Nova.Table.nomFonction()`.

---

#### Copy

##### `Table.shallowCopy(t)` → `table`
Copie superficielle : duplique uniquement le premier niveau de la table. Les sous-tables sont partagées par référence.
Usage : dupliquer une liste simple sans sous-tables.
```lua
local copy = Nova.Table.shallowCopy(myTable)
```

##### `Table.deepCopy(t)` → `table`
Copie profonde : duplique récursivement toute la structure, y compris les sous-tables.
Usage : dupliquer un template d'ennemi depuis `WaveConfig` sans modifier l'original.
```lua
local enemy = Nova.Table.deepCopy(WaveConfig.Enemies.Goblin)
```

---

#### Mutation

##### `Table.merge(a, b)` → `table`
Fusionne deux tables dans une nouvelle table. En cas de clé identique, `b` écrase `a`.
Usage : fusionner stats de base + bonus d'upgrade au levelup.
```lua
local stats = Nova.Table.merge(baseStats, upgradeBonus)
```

##### `Table.filter(t, predicate)` → `table`
Retourne une nouvelle table ne contenant que les éléments où `predicate` retourne `true`.
Usage : garder uniquement les ennemis vivants dans une liste.
```lua
activeEnemies = Nova.Table.filter(activeEnemies, function(e)
    return e.Humanoid.Health > 0
end)
```

##### `Table.map(t, transform)` → `table`
Retourne une nouvelle table où chaque élément est transformé par `transform`.
Usage : extraire les positions de tous les ennemis, convertir des valeurs.
```lua
local positions = Nova.Table.map(enemies, function(e)
    return e.HumanoidRootPart.Position
end)
```

##### `Table.reverse(t)` → `table`
Retourne une nouvelle table avec les éléments dans l'ordre inverse.
Usage : itérer et supprimer des éléments sans décaler les indices.
```lua
local reversed = Nova.Table.reverse(myTable)
```

##### `Table.shuffle(t)` → `table`
Mélange aléatoirement les éléments de la table en place (modifie la table originale).
Usage : ordre de spawn aléatoire, mélanger les choix d'upgrades au levelup.
```lua
local upgrades = Nova.Table.shuffle(availableUpgrades)
```

---

#### Search

##### `Table.find(t, predicate)` → `any?`
Retourne le premier élément où `predicate` retourne `true`, `nil` sinon.
Usage : retrouver un ennemi précis dans une liste par propriété.
```lua
local boss = Nova.Table.find(enemies, function(e)
    return e.Name == "Boss"
end)
```

##### `Table.findAll(t, predicate)` → `table`
Retourne tous les éléments où `predicate` retourne `true`.
Usage : trouver tous les ennemis dans un certain rayon.
```lua
local nearbyEnemies = Nova.Table.findAll(enemies, function(e)
    return Nova.Math.isInRange2D(player.Position, e.Position, 15)
end)
```

##### `Table.contains(t, target)` → `boolean`
Vérifie si une valeur est présente dans une table (comparaison directe).
Usage : vérifier si un joueur est déjà dans une run.
```lua
if Nova.Table.contains(activePlayers, player) then
    -- joueur déjà en run
end
```

##### `Table.isEmpty(t)` → `boolean`
Vérifie si une table est vide.
Usage : vérifier si une vague est terminée (plus d'ennemis vivants).
```lua
if Nova.Table.isEmpty(activeEnemies) then
    WaveCompleted:Fire()
end
```

---

## Exemple complet

```lua
local Nova = require(game.ReplicatedStorage.Nova)

-- Créer un signal
local EnemyDied = Nova.Signal.new()

-- S'abonner
local conn = EnemyDied:Connect(function(enemy, killer)
	print(killer, "a tué", enemy.Name)
end)

-- Déclencher
EnemyDied:Fire(enemyInstance, playerInstance)

-- Se désabonner
conn:Disconnect()

-- Tout couper d'un coup
EnemyDied:DisconnectAll()
```

---

## Roadmap

- [x] v0.1.0 — Signal (Connect, Fire, Disconnect, DisconnectAll)
- [x] v0.2.0 — Signal:Wait()
- [x] v0.3.0 — Nova.Math (Interpolation, Clamp, Rounding, Geometry, Random)
- [x] v0.4.0 — Nova.Table (Copy, Mutation, Search)

---

## Modules connexes

### `DevTools` (frère de Nova, pas un sous-module)

Vit à côté de Nova dans `ReplicatedStorage/DevTools`, mais reste **volontairement séparé** : contient des outils de dev/test (sprint, fly) qui dépendent d'API **client uniquement** (`UserInputService`, `BodyVelocity`, caméra). Nova doit rester utilisable depuis un `Script` serveur ou un `LocalScript` sans distinction — un module qui casse cette garantie ne peut pas vivre dans Nova, même s'il suit le même pattern de dossier-as-module et de README versionné.

Voir `DevTools/README.md` pour la doc complète (`DevTools.Movement.Sprint`, `DevTools.Movement.Fly`).
