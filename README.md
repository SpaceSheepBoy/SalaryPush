# ⚡️ SalaryPush 上班加油器

<div align="center">

![macOS 14.0+](https://img.shields.io/badge/macOS-14.0%2B-blue?logo=apple&style=for-the-badge)
![Universal Binary](https://img.shields.io/badge/arch-Apple%20Silicon%20%7C%20Intel-success?style=for-the-badge)
![License MIT](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
[![Web Demo](https://img.shields.io/badge/Live%20Web%20App-Online-ff69b4?style=for-the-badge)](https://salary-push-web.vercel.app)

**专为打工人打造的实时进账跳动、带薪摸鱼计算与薪酬加油神器**  
*A sleek, motivational macOS & Web real-time salary ticker that turns work into visible progress.*

[📥 下载 macOS 安装包 (.dmg)](#-下载与安装) • [🌐 在线网页版体验](https://salary-push-web.vercel.app) • [✨ 核心特性](#-核心特性) • [⚙️ 本地构建](#-本地构建与开发)

</div>

---

## 📥 下载与安装

### 🍎 macOS 原生客户端 (MacBook / Mac Desktop)
1. 前往 **[Releases 页面](https://github.com/SpaceSheepBoy/SalaryPush/releases/latest)**。
2. 点击下载最新版 **`SalaryPush-1.0.0.dmg`**。
3. 双击打开 `.dmg` 镜像，将 **SalaryPush.app** 拖入 **Applications (应用程序)** 目录即可使用。
4. 首次打开如遇到系统安全提示，请前往 `系统设置` -> `隐私与安全性` -> 点击 `仍要打开`。

> 💡 **架构支持**：原生编译 Universal 2 双架构（Apple Silicon M1/M2/M3/M4 + Intel Core），在任何 Mac 设备上均极致流畅省电。

### 🌐 跨平台 Web / PWA 版本
- **在线点开即用**：**[https://salary-push-web.vercel.app](https://salary-push-web.vercel.app)**
- 支持 Windows、MacBook、iPad、手机浏览器，可在地址栏点击 **“安装到桌面”** 作为独立应用脱离浏览器运行。

---

## ✨ 核心特性

- ⏱ **高频实时进账跳动**：工作时间内以 30fps 丝滑跳动显示当前分秒赚到的每一分钱，严格精确到小数点后两位。
- 🌏 **深入适配多国社保与公积金国情**：
  - 🇨🇳 **中国体系**：住房公积金比例（5%~12%）与单位 1:1 双倍进账实时折算。
  - 🇫🇷 **法国体系**：Cadre / Non-cadre 社保分摊（~25% / 22%）、RTT 年休天数、Tickets Restaurant 饭补与 Navigo 交通补贴。
  - 🇺🇸 **美国体系**：401(k) Employer Match、联邦假日、PTO 自定义。
  - 🌐 **自定义体系**：可根据自身合同自由定义社保比例与额外雇主补贴。
- 🏖 **精密工时与假期联动算法**：
  - 扣除所有法定节假日、带薪年假与 RTT 天数，精确算出每年实际工作日。
  - 假期越多，分摊到每个具体上班日的日薪、时薪与每秒进账就越高！
- 🎁 **丰富实物激励与大件心愿单**：
  - **日常小确幸**：星巴克拿铁、喜茶/霸王茶姬、豪华午餐、IMAX电影票、10L汽车汽油、Steam 3A游戏、泰式SPA等。
  - **大件目标与心愿单**：AirPods Pro、iPhone 16 Pro、度假机票，实时显示今天赚取进度的百分比进度条！
- 🪟 **迷你悬浮便签模式 (Mini Mode)**：
  - 点击右上角缩小图标或**双击主卡片**，即可一键收缩为仅保留核心进账与实物的小巧便签，悬浮在屏幕边角，工作时丝毫不遮挡视线。
- ⌨️ **ESC 老板键 (Stealth Mode)**：
  - 在紧急时刻按下 `ESC` 键，界面瞬间伪装成极简黑白工作日历时钟，再按 ESC 或双击恢复。
- ☕️ **带薪摸鱼计时器**：
  - 内置摸鱼/如厕/咖啡计时功能，实时折算本次摸鱼赚取的老板薪水，并伴随庆祝动画。
- 💾 **全自动离线记忆**：
  - 无需注册登录，配置全自动存储在本地，退出刷新 100% 还原。

---

## ⚙️ 本地构建与开发

如果你想在本地基于源码编译开发：

### macOS 原生工程
- **系统要求**：macOS 14.0+, Xcode 15.0+
- **构建方式**：
```bash
git clone https://github.com/SpaceSheepBoy/SalaryPush.git
cd SalaryPush
# 使用 Xcode 编译
xcodebuild build -project SalaryPush.xcodeproj -scheme SalaryPush -configuration Release
```

### 网页端源码
- 网页端完整源码开源于：[https://github.com/SpaceSheepBoy/salary-push-web](https://github.com/SpaceSheepBoy/salary-push-web)

---

## 📄 开源许可 (License)

本项目采用 [MIT License](LICENSE) 开源协议。允许全球打工人免费下载、使用、分发与二次开发。

上班不易，加油进账！💪✨
