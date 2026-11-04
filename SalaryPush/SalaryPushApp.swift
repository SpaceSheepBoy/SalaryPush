import SwiftUI
import Combine

/// Main app entry point
@main
struct SalaryPushApp: App {
    @StateObject private var settings = SalarySettings()
    @StateObject private var exchangeRateService = ExchangeRateService()

    var body: some Scene {
        // Main window
        WindowGroup {
            ContentView(settings: settings, exchangeRateService: exchangeRateService)
                .preferredColorScheme(.dark)
                .onAppear {
                    exchangeRateService.startPeriodicRefresh()
                    configureWindow()
                }
                .onChange(of: settings.alwaysOnTop) { _, newValue in
                    setAlwaysOnTop(newValue)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 350, height: 600)

        // Menu bar extra
        MenuBarExtra("SalaryPush", systemImage: "dollarsign.circle.fill") {
            MenuBarView(settings: settings, exchangeRateService: exchangeRateService)
        }
    }

    private func configureWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let window = NSApplication.shared.windows.first(where: { $0.title.isEmpty || $0.contentView != nil }) {
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden
                window.backgroundColor = NSColor(red: 0.035, green: 0.078, blue: 0.090, alpha: 1.0)
                window.isMovableByWindowBackground = true

                if settings.alwaysOnTop {
                    window.level = .floating
                }
            }
        }
    }

    private func setAlwaysOnTop(_ onTop: Bool) {
        DispatchQueue.main.async {
            for window in NSApplication.shared.windows {
                if window.contentView != nil {
                    window.level = onTop ? .floating : .normal
                }
            }
        }
    }
}

// MARK: - Content View (Router)

/// Routes between setup and dashboard
struct ContentView: View {
    @ObservedObject var settings: SalarySettings
    @ObservedObject var exchangeRateService: ExchangeRateService

    var body: some View {
        if settings.hasCompletedSetup {
            DashboardView(settings: settings, exchangeRateService: exchangeRateService)
        } else {
            SettingsView(settings: settings)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Menu Bar View

/// Content shown when clicking the menu bar icon
struct MenuBarView: View {
    @ObservedObject var settings: SalarySettings
    @ObservedObject var exchangeRateService: ExchangeRateService
    @State private var currentDate = Date()
    @State private var timer: Timer?

    private var exchangeRate: Double {
        exchangeRateService.rate(from: settings.salaryCurrency, to: settings.displayCurrency)
    }

    private var calculator: EarningsCalculator {
        EarningsCalculator(settings: settings, exchangeRate: exchangeRate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Today's earnings
            HStack {
                Circle()
                    .fill(calculator.isCurrentlyWorking(at: currentDate) ? Color.green : Color.gray)
                    .frame(width: 6, height: 6)

                Text("今日已赚")
                    .font(.system(size: 12))

                Spacer()

                Text(calculator.todayEarnings(at: currentDate).currencyString(symbol: settings.displayCurrencySymbol, currency: settings.displayCurrency, decimals: 2))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }

            Divider()

            // Quick stats
            HStack {
                Text(L10n.hourlyRate(settings.appLanguage))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Spacer()
                Text(calculator.hourlyEarnings.currencyString(symbol: settings.displayCurrencySymbol, currency: settings.displayCurrency, decimals: 2))
                    .font(.system(size: 11, design: .rounded))
                    .monospacedDigit()
            }

            HStack {
                Text(L10n.dailyRate(settings.appLanguage))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Spacer()
                Text(calculator.dailyEarnings.currencyString(symbol: settings.displayCurrencySymbol, currency: settings.displayCurrency, decimals: 2))
                    .font(.system(size: 11, design: .rounded))
                    .monospacedDigit()
            }

            if calculator.isCurrentlyWorking(at: currentDate) {
                Divider()
                HStack {
                    Text(L10n.remainingToday(settings.appLanguage))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(calculator.secondsUntilEndOfWork(at: currentDate).hhmmss)
                        .font(.system(size: 11, design: .rounded))
                        .monospacedDigit()
                }
            }

            Divider()

            Button("打开主窗口 Open Window") {
                NSApplication.shared.activate(ignoringOtherApps: true)
                if let window = NSApplication.shared.windows.first(where: { $0.contentView != nil && $0.className != "NSStatusBarWindow" }) {
                    window.makeKeyAndOrderFront(nil)
                }
            }

            Button("退出 Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(8)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                currentDate = Date()
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}
