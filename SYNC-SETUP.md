# Sync realtime: Arena ⇄ GitHub ⇄ Roblox Studio

Tujuan: saya (agent) mengedit file di workspace ini → Anda menarik perubahan →
Rojo langsung mengirim perubahan itu ke Studio yang sedang terbuka.

```
Arena workspace  --git push-->  GitHub repo  --git pull-->  PC Anda  --rojo serve-->  Studio
     (saya)                                                    (Anda)
```

Rojo `serve` memantau perubahan di folder. Begitu `git pull` mengubah file,
Studio ter-update dalam hitungan detik. Tidak perlu connect ulang.

---

## Setup sekali saja (5 menit)

### 1. Buat repo GitHub
Buat repository **private** (mis. `game-saya`). Jangan di-init dengan README
supaya tidak konflik — biarkan kosong.

### 2. Di PC Anda, hubungkan folder project ke repo
Dari dalam folder `game-saya`:

```powershell
git init
git add .
git commit -m "init: rojo project"
git branch -M main
git remote add origin https://github.com/<USERNAME>/game-saya.git
git push -u origin main
```

### 3. Beri saya akses tulis
Dua pilihan — pilih salah satu.

**A. Deploy key (lebih aman, hanya repo ini)**
1. GitHub repo → **Settings → Deploy keys → Add deploy key**
2. Title: `arena-agent`
3. Key: tempel public key yang saya kirim di chat
4. ✅ centang **Allow write access**
5. Add key

**B. Personal Access Token (fine-grained)**
1. GitHub → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**
2. Repository access: **Only select repositories** → pilih repo `game-saya`
3. Permissions → Repository permissions → **Contents: Read and write**
4. Expiration: 7–30 hari
5. Generate, lalu kirim token-nya ke saya

### 4. Kirim ke saya
- URL repo: `https://github.com/<USERNAME>/game-saya.git`
- Public key (opsi A) sudah saya berikan di chat / atau token (opsi B)

Saya akan menyimpan kredensial di `~/.cache/` (di luar snapshot workspace,
jadi tidak ikut tersimpan di file project Anda).

---

## Alur kerja setelah setup

### Anda (sekali per sesi)
```powershell
cd C:\path\ke\game-saya
.\tools\update.ps1         # = git pull, ambil perubahan terbaru dari saya
rojo serve                 # biarkan terbuka
```
Di Studio: **Plugins → Rojo → Connect**.

### Saya
Saya edit file di workspace ini → commit → push ke `main`.
Anda jalankan `.\tools\update.ps1` (atau `git pull`) → Studio langsung berubah.

### Sebaliknya (Anda → saya)
Kalau Anda mengubah script di Studio lalu ingin saya melihatnya:
- Simpan perubahan dari Studio ke file: di panel Rojo ada opsi **"Sync in progress / Two-way sync"**
  atau jalankan `rojo sourcemap`/`rojo build` lalu commit.
- Lebih mudah: edit file di VS Code (bukan di Studio), lalu `git commit` + `git push`.
  Saya `git pull` di workspace ini dan langsung melihat versi terbaru.

> Catatan: sync dua arah Rojo (Studio → file) perlu diaktifkan di plugin
> (**Connect** → centang *Two-way sync* pada versi plugin terbaru). Kalau tidak,
> perubahan dari Studio tidak akan kembali ke file.

---

## Batasan yang perlu diketahui

| Hal | Bisa? |
|---|---|
| Saya edit script/struktur instance | ✅ realtime (setelah git pull) |
| Saya lihat viewport 3D Studio Anda | ❌ |
| Saya edit terrain / hasil sculpting | ❌ (tetap manual di Studio) |
| Saya jalankan/test game Anda | ❌ harus Anda Play sendiri |
| Perubahan muncul tanpa `git pull` | ❌ perlu pull manual (atau GitHub Actions + rojo di PC Anda) |

Kalau ingin benar-benar otomatis tanpa `git pull` manual, tambahkan penjadwal
di PC Anda:
```powershell
# jalankan sekali, biarkan di background: pull tiap 20 detik
while ($true) { git pull --rebase --autostash | Out-Null; Start-Sleep 20 }
```
Simpan sebagai `tools\autopull.ps1` lalu jalankan di terminal terpisah.
