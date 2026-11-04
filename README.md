# ⚡️ 上班加油器 (SalaryPush)

<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="SalaryPush Icon" style="border-radius: 28px; box-shadow: 0 8px 24px rgba(0,0,0,0.3); margin-bottom: 16px;" />
<br/>

![macOS 14.0+](https://img.shields.io/badge/macOS-14.0%2B-blue?logo=apple&style=for-the-badge)
![Universal Binary](https://img.shields.io/badge/arch-Apple%20Silicon%20%7C%20Intel-success?style=for-the-badge)
![License MIT](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
[![Live Web App](https://img.shields.io/badge/Web%20App-Online-ff69b4?style=for-the-badge)](https://salary-push-web.vercel.app)
[![Release](https://img.shields.io/badge/Download%20DMG-v1.0.0-orange?style=for-the-badge)](https://github.com/SpaceSheepBoy/SalaryPush/releases/latest)

**每一秒呼吸都在变现，让打工人的每一点努力和付出都清晰可见**  
*Turn work into visible progress. Real-time salary ticker & workplace motivation for modern professionals.*

[📥 下载 macOS 安装包 (.dmg) / Download Mac DMG](#-下载与安装--download--installation) • [🌐 在线网页版体验 / Web Live Demo](https://salary-push-web.vercel.app) • [✨ 核心特性 / Features](#-核心特性--features) • [⚙️ 本地构建 / Build](#-本地构建与开发--local-build)

</div>

---

## 📥 下载与安装 / Download & Installation

### 🍎 macOS 原生客户端 (MacBook / Mac Desktop)
1. 前往 **[GitHub Releases 页面](https://github.com/SpaceSheepBoy/SalaryPush/releases/latest)**。
2. 点击下载最新版 **[`SalaryPush-1.0.0.dmg`](https://github.com/SpaceSheepBoy/SalaryPush/releases/download/v1.0.0/SalaryPush-1.0.0.dmg)**。
3. 双击打开 `.dmg` 镜像，将 **上班加油器 (SalaryPush.app)** 拖入 **Applications (应用程序)** 目录即可使用。
4. 首次打开如遇到系统未签名提示，请前往 `系统设置` -> `隐私与安全性` -> 点击 `仍要打开`。

> 💡 **架构支持 (Universal 2)**：原生编译包含 `arm64` 与 `x86_64`，完美支持 Apple Silicon (M1/M2/M3/M4 系列 MacBook Air / Pro / Mac mini / Studio) 以及 Intel 芯片 Mac。

### 🌐 跨平台 Web / PWA 版本 (Cross-Platform Web Version)
- **在线秒开即用**：**[https://salary-push-web.vercel.app](https://salary-push-web.vercel.app)**
- 适配 Windows、MacBook、iPad、手机浏览器，可在地址栏点击 **“安装到桌面”** 作为无边框应用独立运行。

---

## ✨ 核心特性 / Features

### 🇨🇳 中文特性概览

- ⏱ **高频实时进账跳动**：工作时间内以 30fps 丝滑跳动显示当前分秒赚到的每一分钱，严格精确到小数点后两位。
- ☕️ **工间休息 / 能量补给计时器**：实时换算并记录工间休息、喝咖啡期间由公司支付的薪资进账，伴随礼花动画与战报结算。
- 🌏 **深度适配 Tier 1 全球主流国情**：
  - 🇨🇳 **中国**：住房公积金（5%~12% 个人+单位 1:1 双倍进账）实时折算，预设真实中位数（¥8,000/月）。
  - 🇫🇷 **法国**：Cadre / Non-cadre 社保分摊（~25%/22%）、RTT 调休假、Tickets Resto 饭补（€6/天）与 Navigo 50% 交通补贴折算，预设中位数（2 500 €/月）。
  - 🇩🇪 **德国**：法定养老保险 Rentenversicherung（雇员 9.3% + 雇主 9.3% 统筹）、28 天全额年假，预设中位数（3 500 €/月）。
  - 🇬🇧 **英国**：职业年金 Workplace Pension（员工 5% + 雇主 3% 强制匹配）、法定 28 天休假（含 Bank Holidays），预设中位数（£2,900/月）。
  - 🇯🇵 **日本**：社会保険（厚生年金 + 健康险劳资对半）、16 天法定国民祝日（G7 最高），预设中位数（¥350,000/月）。
  - 🇺🇸 **美国**：401(k) 养老匹配、10 天联邦假与标准 PTO，预设中位数（$4,500/月）。
- 📊 **真实中位数薪资与精密假期联动**：
  - 提供“↺ 填入该国真实中位数”按钮，杜绝不切实际的虚高默认值。
  - 扣除所有法定节假日、带薪年假与 RTT 天数，精确算出每年实际工作日——假期越多，分摊到每个具体出勤日的日薪和时薪就越高！
- 🎁 **丰富实物激励与大件心愿单**：
  - **日常小确幸**：星巴克拿铁、奶茶、豪华午餐、IMAX电影票、10L汽油、Steam 3A游戏、泰式SPA。
  - **大件心愿进度**：AirPods Pro、iPhone 18 Pro、度假机票、自定义心愿单，实时展示今天赚出的百分比进度条！
- 🪟 **迷你悬浮便签模式 (Mini Mode)**：
  - 一键收起为极简小巧便签，悬浮在屏幕边角，工作时丝毫不遮挡视线。
- ⌨️ **ESC 老板键 (Stealth Mode)**：
  - 紧急时刻按下 `ESC` 键，界面瞬间伪装成极简黑白工作日历时钟，再按 ESC 或双击恢复。
- 💾 **100% 离线隐私**：
  - 所有数据仅保存在本地设备中，完全离线可用，不上传任何隐私。

---

### 🇬🇧 English Feature Highlights

- ⏱ **30fps Real-Time Salary Ticker**: Smooth, fluid animation showing your earned income tick up every fraction of a second, strictly formatted to 2 decimal places.
- ☕️ **Break & Energy Recharge Tracker**: Calculates exactly how much is earned during your coffee and recharge breaks, complete with confetti animations and summary reports.
- 🌏 **Tier-1 Global Social & Pension Systems**:
  - 🇨🇳 **China**: Housing Provident Fund (5%~12% with 1:1 employer match) calculated in real time, default median ¥8,000/mo.
  - 🇫🇷 **France**: Cadre / Non-cadre cotisations (~25%/22%), RTT days, Tickets Resto (€6/day), Navigo 50%, default median €2,500/mo.
  - 🇩🇪 **Germany**: Statutory Pension Rentenversicherung (9.3% employee + 9.3% employer match), 28 paid vacation days, default median €3,500/mo.
  - 🇬🇧 **United Kingdom**: Workplace Pension Auto-Enrolment (5% employee + 3% employer match), 28 days statutory leave, default median £2,900/mo.
  - 🇯🇵 **Japan**: Social Insurance (Welfare Pension + Health Insurance 14.5% split), 16 national public holidays, default median ¥350,000/mo.
  - 🇺🇸 **United States**: 401(k) with company match, federal holidays & PTO, default median $4,500/mo.
- 📊 **Realistic Medians & Exact Holiday Linkage**:
  - One-click "↺ Reset to National Median" button to prevent misleadingly high salary benchmarks.
  - Subtracts statutory holidays and vacation from total working days—having more holidays mathematically increases your hourly and daily earnings!
- 🎁 **Real-World Rewards & Milestone Wishlists**:
  - Daily rewards: Starbucks Latte, Boba Tea, Deluxe Lunch, IMAX Movie Tickets, 10L Gasoline, Steam 3A Games, Thai Massage.
  - Big goals with progress bars: AirPods Pro, iPhone 18 Pro, Flight Tickets, Custom Wishlist.
- 🪟 **Mini Floating Widget Mode**:
  - One-click collapse into a compact widget showing only earnings and rewards, ideal for keeping in a screen corner while working.
- ⌨️ **Stealth Boss Key (ESC)**:
  - Hit `ESC` to instantly disguise the interface as a clean minimalist calendar clock.
- 💾 **100% Privacy & Local Storage**:
  - All configurations are stored locally on your Mac; zero tracking, completely offline and private.

---

## ⚙️ 本地构建与开发 / Local Build

### macOS 原生工程 (Xcode)
- **要求**：macOS 14.0+, Xcode 15.0+
```bash
git clone https://github.com/SpaceSheepBoy/SalaryPush.git
cd SalaryPush

# 构建 Universal Release 版本
xcodebuild build -project SalaryPush.xcodeproj -scheme SalaryPush -configuration Release ARCHS="arm64 x86_64" ONLY_ACTIVE_ARCH=NO
```

### 网页端源码 (Web Version)
- 网页端完整源码开源于：[https://github.com/SpaceSheepBoy/salary-push-web](https://github.com/SpaceSheepBoy/salary-push-web)

---

## 📄 开源许可证 / License

本项目采用 [MIT License](LICENSE) 开源协议。欢迎全球打工人自由下载、使用与二开。  
*This project is licensed under the MIT License.*
