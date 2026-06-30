# Nova
> Bibliothèque utilitaire Luau — Partagée entre les projets Roblox de Lopapon

---

## Patch Notes

### v0.2.0 — Signal:Wait() (current)
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
    ├── init.lua         ← Point d'entrée principal (Nova.Signal, Nova.Math, ...)
    └── Signal/
        ├── init.lua     ← Expose Signal.lua
        └── Signal.lua   ← Classe Signal complète
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

### `Nova.Math` *(à venir)*

Utilitaires mathématiques : `lerp`, `smoothLerp`, `clamp`, `round`, etc.

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
- [ ] v0.3.0 — Nova.Math (lerp, clamp, round)
- [ ] v0.4.0 — Nova.Table (deepCopy, merge, shuffle)