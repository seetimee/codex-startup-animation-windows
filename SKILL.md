---
name: codex-startup-windows
description: >-
  Installs the Windows Codex startup animation from
  seetimee/codex-startup-animation-windows by git clone or GitHub ZIP, then
  install.ps1 or CodexStartup.exe. Use when the user asks to
  install, set up, or update this Codex startup animation, 启动动画, or Codex
  Animation.
---

# Codex Startup Animation for Windows

Windows 10/11，Microsoft Store 版 `OpenAI.Codex`。先装官方应用。无需管理员权限，无需另装 Node.js。

本仓库以已验证的便携运行时为准：根目录 `CodexStartup.exe` 通过 `windows\launch.ps1` 用 MSIX 官方激活打开 Codex，再注入启动动画。不要改成直接运行 `WindowsApps\ChatGPT.exe`。

完全退出托盘里的 Codex 之后再启动动画入口。官方图标不会播放本动画。

## 取得代码

只使用下面两种方式。

```powershell
git clone https://github.com/seetimee/codex-startup-animation-windows.git
cd codex-startup-animation-windows
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

或者在 GitHub 页面选择 **Code → Download ZIP**。进入能看到 `CodexStartup.exe` 的那一层，再运行上面的 `install.ps1`，或双击 `install.cmd`。`-File` 报“不存在”时，是当前目录不对，不要在解压目录的上一层运行。

安装会创建桌面快捷方式 **Codex Animation** 和 **Codex Image Settings**。也可以直接双击仓库根目录的 `CodexStartup.exe`。项目目录要留在原地；移动后重新运行安装脚本。

## 启动与设置

1. 从托盘完全退出 Codex。
2. 打开桌面 **Codex Animation**，或双击 `CodexStartup.exe`。
3. 换图片：桌面 **Codex Image Settings**，或主窗口 `Ctrl+Alt+B`。

头像：PNG、JPEG、WebP。背景还可以是 GIF。单张不超过 80 MB。GIF 循环播放，线稿只用一帧。
