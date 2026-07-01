# Nova
> Bibliothèque utilitaire Luau — Partagée entre les projets Roblox de Lopapon

---

## Patch Notes

### v0.3.0 — Nova.Math (current)
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
    ├── init.lua              ← Point d'entrée principal (Nova.Signal, Nova.Math, ...)
    ├── Signal/
    │   ├── init.lua          ← Expose Signal.lua
    │   └── Signal.lua        ← Classe Signal complète
    └── Math/
        ├── init.lua          ← Agrège tous les sous-modules Math
        ├── Interpolation.lua ← lerp, smoothLerp, easeIn, easeOut, easeInOut
        ├── Clamp.lua         ← clamp, clampMin, clampMax
        ├── Rounding.lua      ← round, floor, ceil, roundTo
        ├── Geometry.lua      ← distance2D, distance3D, angleBetween, normalize2D, isInRange2D
        └── Random.lua        ← randomFloat, randomInt, randomSign, chance, randomAngle
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

### `Nova.Table` *(à venir)*

Utilitaires de manipulation de tables : `deepCopy`, `merge`, `shuffle`, `filter`, etc.

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
- [ ] v0.4.0 — Nova.Table (deepCopy, merge, shuffle, filter)
