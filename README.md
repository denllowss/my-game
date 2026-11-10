# game-saya

Project Roblox dengan Rojo. Script ditulis di luar Studio (VS Code), lalu di-sync ke Studio secara live.

## Struktur

```
game-saya/
├── default.project.json      # peta folder -> instance Roblox
├── rokit.toml                # versi tool yang dipakai
├── src/
│   ├── ServerScriptService/
│   │   └── Main.server.lua
│   ├── ReplicatedStorage/
│   │   └── Shared/
│   │       └── Config.lua
│   ├── StarterPlayer/
│   │   └── StarterPlayerScripts/
│   │       └── Client.client.lua
│   └── StarterGui/
└── .vscode/settings.json
```

Aturan nama file:
- `Nama.server.lua` → jadi **Script** (server)
- `Nama.client.lua` → jadi **LocalScript**
- `Nama.lua` (tanpa akhiran) → jadi **ModuleScript**
- Folder biasa → jadi **Folder**

## Pakai

```powershell
# di folder ini
rokit install          # pasang Rojo sesuai rokit.toml (sekali saja)
rojo plugin install    # pasang plugin Studio (sekali saja, lalu restart Studio)
rojo serve             # jalankan sync server, biarkan terminal terbuka
```

Lalu di Roblox Studio: tab **Plugins** → **Rojo** → **Connect** → **Allow**.

## Build ke file place

```powershell
rojo build -o game-saya.rbxlx
```

Lalu buka `game-saya.rbxlx` di Studio.
