# MULAI DARI SINI

Project Roblox Anda tersambung ke agent Arena lewat GitHub + Rojo.
Agent mengedit file di repo `denllowss/my-game`, Anda menariknya, Rojo mengirim
ke Studio yang sedang terbuka.

---

## 1. Setup di PC (sekali saja, ±3 menit)

Buka **PowerShell**, lalu:

```powershell
cd C:\Users\<nama-anda>\Documents        # atau folder mana pun
git clone https://github.com/denllowss/my-game.git
cd my-game

rokit install            # pasang Rojo sesuai rokit.toml
rojo plugin install      # pasang plugin Rojo ke Studio
# kalau gagal (registry error): .\tools\install-plugin.ps1
```

**Restart Roblox Studio** setelah `rojo plugin install`. Akan muncul tombol
**Rojo** di tab Plugins.

---

## 2. Tiap kali mau kerja

Terminal 1 — sync server (biarkan terbuka):
```powershell
cd C:\Users\<nama-anda>\Documents\my-game
rojo serve
```

Terminal 2 — auto-pull dari GitHub (biarkan terbuka):
```powershell
cd C:\Users\<nama-anda>\Documents\my-game
.\tools\autopull.ps1
```

> Kalau PowerShell menolak menjalankan script:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
> ```

Di Studio: buka place → tab **Plugins** → **Rojo** → **Connect**
→ dialog izin → **Allow** → centang **Two-way sync** kalau ada.

Sekarang folder `src/` muncul di Explorer Studio.

---

## 3. Alur kerja

| Arah | Yang terjadi |
|---|---|
| Agent → Anda | agent push → auto-pull 20 dtk → Studio update otomatis |
| Anda → agent | edit di VS Code → `.\tools\push.ps1 "pesan"` → agent pull |
| Anda (di Studio) | dengan Two-way sync, perubahan ikut ditulis ke file → lalu `.\tools\push.ps1 "pesan"` |

Minta agent melakukan sesuatu, misalnya:
> "tambahkan sistem coin pickup dengan sound dan leaderstats"

Agent mengedit file, commit, push. Dalam ±20 detik Studio Anda berubah.

---

## 4. Struktur file

```
my-game/
├── default.project.json   # peta folder -> instance Roblox
├── rokit.toml             # versi Rojo yang dipakai
├── src/
│   ├── ServerScriptService/          -> ServerScriptService
│   │   └── Main.server.lua           (Script / server)
│   ├── ReplicatedStorage/Shared/
│   │   └── Config.lua                (ModuleScript, dipakai server & client)
│   ├── StarterPlayer/StarterPlayerScripts/
│   │   └── Client.client.lua         (LocalScript / client)
│   └── StarterGui/                   -> StarterGui
└── tools/                 # skrip bantu PowerShell
```

Aturan penamaan:
- `Nama.server.lua` → **Script** (server)
- `Nama.client.lua` → **LocalScript** (client)
- `Nama.lua` → **ModuleScript**
- folder biasa → **Folder**

Ingin menambah service baru (mis. `ServerStorage`)? Tambahkan di
`default.project.json` di bawah `tree`, lalu buat foldernya di `src/`.
Minta saja ke agent, dia yang urus.

---

## 5. Yang TIDAK bisa lewat Rojo

- **Terrain** dan hasil sculpting → tetap dikerjakan manual di Studio
- **Model/part buatan tangan** → `Save to File` jadi `.rbxmx`, letakkan di `src/`,
  daftarkan di `default.project.json` sebagai `"$path": "src/Models/NamaModel"`
- **Pengaturan tempat (place settings)**, game settings, dsb.

Agent tidak bisa melihat viewport 3D Studio Anda dan tidak bisa menjalankan
game-nya. Untuk hal visual, kirim screenshot ke chat.

---

## 6. Kalau ada masalah

| Gejala | Solusi |
|---|---|
| `rojo : not recognized` | tutup PowerShell, buka baru. Cek `$env:Path -split ';' \| Select-String rokit` |
| Studio: **Not Found** | `rojo serve` belum jalan. Pastikan port 34872 |
| Tombol Rojo tak muncul | `rojo plugin install` lalu restart Studio |
| `rojo plugin install` → "Couldn't find registry keys" | Rojo tak menemukan Studio via registry. Pakai `.	ools\install-plugin.ps1` (mencari folder Studio langsung di disk) atau install manual dari Creator Store |
| Connection refused | firewall Windows blokir port 34872 → izinkan |
| `.\tools\autopull.ps1` diblokir | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| Pull konflik | `git stash` lalu `git pull`, atau minta agent menyelesaikan |
| Script tidak muncul di Studio | cek akhiran nama file + terdaftar di `default.project.json` |

---

## Catatan keamanan

Token GitHub yang dipakai agent punya scope luas. Sebaiknya **revoke** dan ganti
dengan token fine-grained yang dibatasi ke repo `my-game` saja, permission
`Contents: Read and write`, expiry 7–30 hari. Detail: lihat `SYNC-SETUP.md`.

Jangan commit file berisi token, `.env`, atau DataStore key ke repo ini.
