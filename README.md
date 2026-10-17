# Codex Startup Animation for Windows

给 Microsoft Store 版 Codex 添加启动动画和应用内图片背景。基于已验证的便携运行时（`CodexStartup.exe` + MSIX 官方激活），支持更换头像、背景和文字，背景支持大图与 GIF。

这是非官方项目，官方应用需要另行安装。

## 安装

适用于 Windows 10/11、Microsoft Store 版 `OpenAI.Codex`。无需管理员权限，无需单独安装 Node.js。

用下面任一方式取得代码：

**git clone**

```powershell
git clone https://github.com/seetimee/codex-startup-animation-windows.git
cd codex-startup-animation-windows
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

先确认当前目录里能看到 `CodexStartup.exe`。如果提示 `install.ps1` 不存在，说明还在解压目录的上一层，需要再进入仓库文件夹。也可以直接双击仓库根目录的 `install.cmd`。

**GitHub 压缩包**

1. 打开仓库页面，点击 **Code → Download ZIP**，解压到一个固定目录。
2. 进入解压出来的、里面有 `CodexStartup.exe` 的那一层，打开 PowerShell，运行：

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
   ```

安装会在桌面创建两个快捷方式，都指向本仓库的 `CodexStartup.exe`：

- **Codex Animation**：启动动画
- **Codex Image Settings**：打开图片设置

不要用官方 Codex 的开始菜单、任务栏或桌面图标。官方入口没有动画。项目文件夹需要保留；移动后请重新运行安装脚本。

## 使用

1. 先安装 Microsoft Store 版官方 Codex。
2. 从托盘完全退出 Codex。
3. 打开桌面 **Codex Animation**，或双击 `CodexStartup.exe`。
4. 换图片：桌面 **Codex Image Settings**，或主窗口 `Ctrl+Alt+B`。

头像支持 PNG、JPEG、WebP；背景还可以使用 GIF，单张不超过 80 MB。GIF 保存后继续循环，线稿取其中一帧。设置保存在本机，不会上传。

## 常见问题

**直接点官方图标没有动画：** 官方快捷方式不能用来开启动画。请用桌面上的 **Codex Animation**，或双击本仓库的 `CodexStartup.exe`。没有这个快捷方式时，在仓库根目录运行 `install.ps1`，它会创建到桌面。

**提示应用正在运行：** 从托盘完全退出 Codex 后，再用动画入口打开。

**想停用：** 完全退出 Codex，之后使用官方入口打开。删除本项目的两个快捷方式即可。

日志：`%LOCALAPPDATA%\CodexStartupWindows\launcher.log`。

给其他 agent 的安装说明见 [SKILL.md](SKILL.md)。来源见 [references.md](references.md)。
