---
name: codex-startup-windows
description: >-
  Installs the Windows Codex startup animation from
  seetimee/codex-startup-animation-windows by git clone or GitHub ZIP, then
  tools/install-windows.ps1 or CodexStartup.exe. Use when the user asks to
  install, set up, or update this Codex startup animation, 启动动画, Codex
  Animation, or import the 4k红瞳少女动态壁纸 GIF background.
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\install-windows.ps1
```

或者在 GitHub 页面选择 **Code → Download ZIP**，解压后在该目录运行同一条 `install-windows.ps1`。

安装会创建桌面快捷方式 **Codex Animation** 和 **Codex Image Settings**。也可以直接双击仓库根目录的 `CodexStartup.exe`。项目目录要留在原地；移动后重新运行安装脚本。

## 启动与设置

1. 从托盘完全退出 Codex。
2. 打开桌面 **Codex Animation**，或双击 `CodexStartup.exe`。
3. 换图片：桌面 **Codex Image Settings**，或主窗口 `Ctrl+Alt+B`。

头像：PNG、JPEG、WebP。背景还可以是 GIF。单张不超过 80 MB。GIF 循环播放，线稿只用一帧。

## 4k红瞳少女动态壁纸

可选背景示例。用户自行从网盘保存后再导入。仓库不包含该文件。

```
https://www.alipan.com/s/dakiZZ9nPLq
提取码: i0u9
点击链接保存，或者复制本段内容，打开「阿里云盘」APP ，无需下载极速在线查看，视频原画倍速播放。
```
