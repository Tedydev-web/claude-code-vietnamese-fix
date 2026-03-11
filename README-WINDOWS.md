# Windows: Gõ tiếng Việt khi dùng Claude Code

## Bạn đang chạy Claude Code bằng gì?

### 1. Ứng dụng standalone `claude.exe` (trong PATH, ví dụ `.local\bin\claude.exe`)

File `.exe` **không** dùng bản `cli.js` đã patch. Để gõ tiếng Việt được:

- **Cách A (khuyến nghị):** Chạy Claude Code bằng **launcher đã patch**:

  ```powershell
  & "C:\Users\Hieud\.claude-vn-fix\run-patched-claude.ps1"
  ```

  Hoặc (CMD):

  ```cmd
  "C:\Users\Hieud\.claude-vn-fix\claude-vn.cmd"
  ```

  Có thể tạo shortcut hoặc alias để gọi lệnh trên thay vì gõ `claude`.

- **Cách B:** Chạy qua npx (dùng bản npm đã patch):
  ```powershell
  npx @anthropic-ai/claude-code
  ```
  Lần đầu npx sẽ dùng cache đã được patch.

### 2. Chạy bằng `npx @anthropic-ai/claude-code` hoặc `npm run` / script gọi npm

Bản `cli.js` trong npm cache đã được patch. Chỉ cần **khởi động lại terminal** và chạy lại lệnh. Nếu vẫn lỗi, chạy lại patch:

```powershell
$env:PYTHONIOENCODING = 'utf-8'; python "C:\Users\Hieud\.claude-vn-fix\patcher.py" --all
```

### 3. Gõ tiếng Việt trong **Cursor IDE** (ô chat trong Cursor)

Fix này chỉ áp dụng cho **Claude Code CLI** (ứng dụng/terminal), **không** áp dụng cho ô chat trong Cursor. Nếu bạn gõ tiếng Việt trong Cursor và bị lỗi, đó là do Cursor/Electron, không phải Claude Code CLI. Có thể thử:

- Gõ tiếng Việt ở nơi khác (Notepad) rồi dán vào Cursor.
- Báo lỗi cho Cursor: https://cursor.com hoặc forum Cursor.

## Tóm tắt lệnh

| Mục đích                               | Lệnh                                                                                     |
| -------------------------------------- | ---------------------------------------------------------------------------------------- |
| Chạy Claude Code đã patch (PowerShell) | `& "C:\Users\Hieud\.claude-vn-fix\run-patched-claude.ps1"`                               |
| Chạy Claude Code đã patch (CMD)        | `"C:\Users\Hieud\.claude-vn-fix\claude-vn.cmd"`                                          |
| Patch lại sau khi update Claude Code   | `$env:PYTHONIOENCODING='utf-8'; python "C:\Users\Hieud\.claude-vn-fix\patcher.py" --all` |
