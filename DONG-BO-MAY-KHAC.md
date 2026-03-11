# Đồng bộ thiết lập sang máy Windows khác

Cách để máy tính Windows khác cũng có: **Claude Code Vietnamese IME fix** + lệnh **`claude`** (có sẵn `--dangerously-skip-permissions`).

---

## Yêu cầu trên máy mới

- **Git** – https://git-scm.com/downloads
- **Python 3** – https://python.org/downloads
- **Node.js** – https://nodejs.org (để chạy Claude Code)
- Đã chạy ít nhất một lần: `npx @anthropic-ai/claude-code` (để có bản cli.js trong cache cho patcher)

---

## Cách 1: Chạy một script (khuyến nghị)

Trên **máy mới**, mở PowerShell (không cần Admin) và chạy **một trong hai**:

**A) Nếu bạn copy file `setup-tren-may-moi.ps1` vào máy mới** (qua OneDrive, USB, repo):

```powershell
cd $env:USERPROFILE
# Sau khi thu muc .claude-vn-fix da co tren may (do sync OneDrive hoac copy tay):
& "$env:USERPROFILE\.claude-vn-fix\setup-tren-may-moi.ps1"
```

**B) Nếu bạn đặt script lên web (GitHub, Gist, server của bạn):**

```powershell
irm "https://URL-CUA-BAN/setup-tren-may-moi.ps1" | iex
```

Script sẽ:

1. Clone/cập nhật repo Vietnamese fix vào `%USERPROFILE%\.claude-vn-fix`
2. Tạo `run-patched-claude.ps1` nếu chưa có
3. Chạy patcher (patch cli.js)
4. Thêm function **`claude`** (kèm `--dangerously-skip-permissions`) vào PowerShell profile

Xong: mở lại PowerShell, gõ **`claude`** là dùng được.

---

## Cách 2: Đồng bộ thư mục rồi chạy script (OneDrive / copy tay)

1. **Trên máy hiện tại:** Thư mục đã có sẵn:

   ```
   %USERPROFILE%\.claude-vn-fix
   ```

   Chứa: `patcher.py`, `run-patched-claude.ps1`, `setup-tren-may-moi.ps1`, v.v.

2. **Đưa sang máy mới** bằng một trong các cách:
   - **OneDrive:** Đặt `.claude-vn-fix` trong thư mục OneDrive (ví dụ `OneDrive\Config\.claude-vn-fix`) rồi trên máy mới copy vào `%USERPROFILE%\.claude-vn-fix`, **hoặc** dùng symlink/junction từ `%USERPROFILE%\.claude-vn-fix` → thư mục trong OneDrive.
   - **USB / mạng:** Copy cả thư mục `.claude-vn-fix` vào `%USERPROFILE%\.claude-vn-fix` trên máy mới.

3. **Trên máy mới**, mở PowerShell:

```powershell
& "$env:USERPROFILE\.claude-vn-fix\setup-tren-may-moi.ps1"
```

Script sẽ patch và thêm `claude` vào profile. Không cần clone lại nếu bạn đã copy đủ thư mục.

---

## Cách 3: Làm tay từng bước

Trên máy mới:

1. **Cài Vietnamese fix (theo repo gốc):**

   ```powershell
   irm https://raw.githubusercontent.com/manhit96/claude-code-vietnamese-fix/main/install.ps1 | iex
   ```

2. **Copy nội dung `run-patched-claude.ps1`** từ máy cũ vào `%USERPROFILE%\.claude-vn-fix\run-patched-claude.ps1` (tạo file nếu chưa có).

3. **Thêm vào PowerShell profile** (ví dụ: `notepad $PROFILE`):

   ```powershell
   function claude { & "$env:USERPROFILE\.claude-vn-fix\run-patched-claude.ps1" --dangerously-skip-permissions @args }
   ```

4. Mở lại PowerShell, gõ **`claude`**.

---

## Tóm tắt

| Cách       | Khi nào dùng                                                          |
| ---------- | --------------------------------------------------------------------- |
| **Cách 1** | Chỉ cần chạy 1 script (có file hoặc URL), máy mới có Git/Python/Node. |
| **Cách 2** | Đã đồng bộ/sync thư mục `.claude-vn-fix` (OneDrive, USB).             |
| **Cách 3** | Muốn làm từng bước, không dùng script.                                |

Sau khi xong, trên mọi máy chỉ cần mở PowerShell và gõ **`claude`** là chạy bản đã patch và có `--dangerously-skip-permissions`.
