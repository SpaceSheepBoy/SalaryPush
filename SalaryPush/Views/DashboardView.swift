import SwiftUI
import Combine

/// Main dashboard view replicating the exact aesthetic of the reference video in a compact or mini floating widget
struct DashboardView: View {
    @ObservedObject var settings: SalarySettings
    @ObservedObject var exchangeRateService: ExchangeRateService
    @State private var currentDate = Date()
    @State private var motivationalText = "keep going 💪"
    @State private var showSettings = false
    @State private var timer: Timer?
    @State private var quoteTimer: Timer?

    // Color Palette extracted from reference video
    private let cardBackground = Color(red: 0.055, green: 0.125, blue: 0.145) // #0E2024
    private let cardBorder = Color(red: 0.12, green: 0.22, blue: 0.25)
    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let cyanBenefitColor = Color(red: 0.35, green: 0.75, blue: 0.87) // #58BEDD
    private let mintBadgeColor = Color(red: 0.18, green: 0.90, blue: 0.61) // #2EE59C
    private let outerBackground = Color(red: 0.035, green: 0.078, blue: 0.090) // #091417

    private var exchangeRate: Double {
        exchangeRateService.rate(from: settings.salaryCurrency, to: settings.displayCurrency)
    }

    private var calculator: EarningsCalculator {
        EarningsCalculator(settings: settings, exchangeRate: exchangeRate)
    }

    var body: some View {
        VStack(spacing: settings.isMiniMode ? 6 : 8) {
            // Subtle top window bar with app title, mini toggle, and settings gear
            HStack {
                Text(appTitle)
                    .font(.system(size: settings.isMiniMode ? 11 : 12, weight: .medium))
                    .foregroundColor(grayTeal)

                Text("SalaryPush · 上班加油")
                    .font(.system(size: 9, weight: .regular))
                    .foregroundColor(grayTeal.opacity(0.6))

                Spacer()

                // Mini Mode Toggle Icon
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        settings.isMiniMode.toggle()
                    }
                    updateWindowSize(mini: settings.isMiniMode)
                }) {
                    Image(systemName: settings.isMiniMode ? "arrow.up.left.and.arrow.down.right" : "arrow.down.right.and.arrow.up.left")
                        .font(.system(size: 11))
                        .foregroundColor(grayTeal)
                }
                .buttonStyle(.plain)
                .help(settings.isMiniMode ? "展开完整面板 (Expand)" : "切换至迷你模式 (Mini Mode)")

                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 12))
                        .foregroundColor(grayTeal)
                }
                .buttonStyle(.plain)
                .help("设置 (Settings)")
            }
            .padding(.horizontal, 2)
            .padding(.top, 2)

            // The Main Sleek Compact Card (Supports Full and Mini Modes)
            VStack(spacing: settings.isMiniMode ? 6 : 10) {
                let monthInfo = calculator.monthToDateEarnings(at: currentDate)

                // 1. Today's earnings counter + month capsule + status badge + motivational quote (Shown in both Full and Mini)
                EarningsCounterView(
                    earnings: calculator.todayEarnings(at: currentDate),
                    monthInfo: monthInfo,
                    currencySymbol: settings.displayCurrencySymbol,
                    currencyCode: settings.displayCurrency,
                    isWorking: calculator.isCurrentlyWorking(at: currentDate),
                    motivationalText: motivationalText,
                    language: settings.appLanguage
                )

                if !settings.isMiniMode {
                    // 2. Stats row: per-second, hourly, daily, annual
                    StatsRowView(
                        perSecond: calculator.perSecondEarnings,
                        hourly: calculator.hourlyEarnings,
                        daily: calculator.dailyEarnings,
                        annual: calculator.annualEarnings,
                        currencySymbol: settings.displayCurrencySymbol,
                        currencyCode: settings.displayCurrency,
                        language: settings.appLanguage
                    )

                    // 3. Social Benefit / Housing Fund Row
                    let benefit = calculator.benefitSummary(at: currentDate)
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(alignment: .firstTextBaseline) {
                            HStack(spacing: 5) {
                                Text(benefit.title)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(grayTeal)

                                Text(formatBenefitAmount(benefit.todayAccumulated))
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(cyanBenefitColor)
                                    .monospacedDigit()
                            }

                            Spacer()

                            Text(benefit.formulaText)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(grayTeal.opacity(0.85))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }

                        let clarificationText: String = {
                            switch settings.appLanguage {
                            case .zh: return "💡 员工个人代扣社保（上方今日已赚已扣除，为实发到手，无需再减）"
                            case .fr: return "💡 Part salariale déduite (Le montant en haut est déjà votre Net réel)"
                            default: return "💡 Employee deductions (Top amount is already Net take-home, no extra deduction)"
                            }
                        }()

                        Text(clarificationText)
                            .font(.system(size: 9))
                            .foregroundColor(grayTeal.opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(.top, -3)

                    // 4. Subtle divider
                    Rectangle()
                        .fill(Color(white: 1.0, opacity: 0.07))
                        .frame(height: 1)
                        .padding(.vertical, 1)

                    // 5. Next Rest Countdown & 7-Day Pill Strip
                    let restInfo = calculator.nextRestInfo(from: currentDate)
                    CountdownView(
                        nextRestInfo: restInfo,
                        language: settings.appLanguage
                    )

                    // 6. Work Tenure, Retirement, and Bottom Progress Bar
                    WorkProgressView(
                        calculator: calculator,
                        currentDate: currentDate,
                        language: settings.appLanguage
                    )

                    // 7. Dedicated Custom Wishlist Milestone & Payday Card
                    let wishlist = calculator.customWishlistGoal(todayEarned: calculator.todayEarnings(at: currentDate), exchangeRateService: exchangeRateService)
                    let payday = calculator.paydayCountdown(now: currentDate)

                    VStack(spacing: 5) {
                        HStack {
                            Text("🎯 \(wishlist.name)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()

                            Button(action: { showSettings = true }) {
                                HStack(spacing: 3) {
                                    Text("\(String(format: "%.1f", wishlist.progressPercent))%")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(mintBadgeColor)
                                    Image(systemName: "pencil")
                                        .font(.system(size: 9))
                                        .foregroundColor(grayTeal)
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        // Multi-segment Progress Bar: Saved (Mint) + Today (Gold)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 5)
                                // Segment 1: Saved
                                Capsule()
                                    .fill(mintBadgeColor)
                                    .frame(width: max(0, geo.size.width * CGFloat(min(1.0, wishlist.savedPercent / 100.0))), height: 5)
                                // Segment 2: Today (offset by saved)
                                Capsule()
                                    .fill(Color(red: 0.98, green: 0.75, blue: 0.14))
                                    .frame(width: max(0, geo.size.width * CGFloat(min(1.0, wishlist.todayPercent / 100.0))), height: 5)
                                    .offset(x: geo.size.width * CGFloat(min(1.0, wishlist.savedPercent / 100.0)))
                            }
                        }
                        .frame(height: 5)

                        HStack {
                            Text("\(wishlist.saved > 0 ? "已存 \(wishlist.formattedSaved) + " : "")今日 \(formatBenefitAmount(wishlist.todayEarned)) / 目标 \(wishlist.formattedPrice)\(wishlist.remaining > 0 ? " (余 \(wishlist.formattedRemaining))" : "")")
                                .font(.system(size: 8.5))
                                .foregroundColor(grayTeal)

                            Spacer()

                            let daysSuffix = settings.appLanguage == .zh ? "天" : (settings.appLanguage == .fr ? "j" : (settings.appLanguage == .de ? "T" : (settings.appLanguage == .ja ? "日" : "d")))
                            Text("💰 \(L10n.paydayLabel(settings.appLanguage)): \(payday.displayLabel) (\(payday.days) \(daysSuffix))")
                                .font(.system(size: 8.5, weight: .medium))
                                .foregroundColor(Color(red: 0.95, green: 0.77, blue: 0.25))
                        }
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.035))
                    .cornerRadius(8)
                }
            }
            .padding(settings.isMiniMode ? 10 : 14)
            .background(
                RoundedRectangle(cornerRadius: settings.isMiniMode ? 14 : 18)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: settings.isMiniMode ? 14 : 18)
                    .stroke(cardBorder, lineWidth: 1)
            )
            .onTapGesture(count: 2) {
                if settings.isMiniMode {
                    withAnimation {
                        settings.isMiniMode = false
                    }
                    updateWindowSize(mini: false)
                } else {
                    showSettings = true
                }
            }

            // Bottom subtle note (Full mode only)
            if !settings.isMiniMode {
                HStack {
                    if settings.salaryCurrency != settings.displayCurrency {
                        Text("1 \(settings.salaryCurrency) = \(exchangeRate.formatted(currency: settings.displayCurrency, decimals: 4)) \(settings.displayCurrency)")
                            .font(.system(size: 9, design: .rounded))
                            .foregroundColor(grayTeal.opacity(0.7))
                            .monospacedDigit()
                    } else {
                        Text(L10n.doubleClickHint(settings.appLanguage))
                            .font(.system(size: 9))
                            .foregroundColor(grayTeal.opacity(0.55))
                    }

                    Spacer()

                    Text(currentDate, style: .time)
                        .font(.system(size: 9, design: .rounded))
                        .foregroundColor(grayTeal.opacity(0.55))
                        .monospacedDigit()
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 2)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, settings.isMiniMode ? 6 : 8)
        .frame(width: showSettings ? 450 : (settings.isMiniMode ? 260 : 346))
        .background(outerBackground)
        .onAppear {
            motivationalText = MotivationalQuotes.random(lang: settings.appLanguage)
            startTimers()
            updateWindowSize(mini: settings.isMiniMode)
        }
        .onDisappear {
            stopTimers()
        }
        .onChange(of: settings.isMiniMode) { _, mini in
            updateWindowSize(mini: mini)
        }
        .onChange(of: showSettings) { _, isShowing in
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first(where: { $0.contentView != nil && $0.className != "NSStatusBarWindow" }) {
                    if isShowing {
                        window.setContentSize(CGSize(width: 450, height: 700))
                    } else {
                        updateWindowSize(mini: settings.isMiniMode)
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
                .preferredColorScheme(.dark)
                .frame(width: 440, height: 680)
        }
    }

    private var appTitle: String {
        switch settings.appLanguage {
        case .zh: return "上班加油器"
        case .fr: return "Booster Salaire"
        case .de: return "GehaltsRechner"
        case .ja: return "給料チャージャー"
        case .en: return "Work Fuel"
        }
    }

    private func formatBenefitAmount(_ value: Double) -> String {
        let numStr = CurrencyFormatter.format(value: value, currency: settings.displayCurrency, decimals: 2)
        let isEuropean = ["EUR", "CHF"].contains(settings.displayCurrency.uppercased())
        return isEuropean ? "\(numStr) \(settings.displayCurrencySymbol)" : "\(settings.displayCurrencySymbol)\(numStr)"
    }

    private func updateWindowSize(mini: Bool) {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first(where: { $0.contentView != nil && $0.className != "NSStatusBarWindow" }) {
                let targetSize = mini ? CGSize(width: 260, height: 165) : CGSize(width: 346, height: 590)
                window.setContentSize(targetSize)
            }
        }
    }

    private func startTimers() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            currentDate = Date()
        }

        quoteTimer = Timer.scheduledTimer(withTimeInterval: 12.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                motivationalText = MotivationalQuotes.random(lang: settings.appLanguage)
            }
        }
    }

    private func stopTimers() {
        timer?.invalidate()
        timer = nil
        quoteTimer?.invalidate()
        quoteTimer = nil
    }
}
