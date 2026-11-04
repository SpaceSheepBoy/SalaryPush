import Foundation

// MARK: - App Language

public enum AppLanguage: String, CaseIterable, Identifiable {
    case zh = "zh"
    case en = "en"
    case fr = "fr"
    case de = "de"
    case ja = "ja"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .zh: return "简体中文 (Chinese)"
        case .en: return "English"
        case .fr: return "Français (French)"
        case .de: return "Deutsch (German)"
        case .ja: return "日本語 (Japanese)"
        }
    }
}

// MARK: - Localization Dictionary (L10n)

public enum L10n {
    public static func todayEarned(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "今日已赚"
        case .fr: return "Gains du jour"
        case .en: return "Earned Today"
        case .de: return "Heute verdient"
        case .ja: return "本日の稼ぎ"
        }
    }

    public static func statusWorking(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "在岗"
        case .fr: return "En poste"
        case .en: return "Working"
        case .de: return "Bei der Arbeit"
        case .ja: return "勤務中"
        }
    }

    public static func statusOffDuty(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "休息"
        case .fr: return "Repos"
        case .en: return "Off Duty"
        case .de: return "Feierabend"
        case .ja: return "退勤済"
        }
    }

    public static func perSecond(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "每秒进账"
        case .fr: return "Par seconde"
        case .en: return "Per second"
        case .de: return "Pro Sekunde"
        case .ja: return "毎秒の稼ぎ"
        }
    }

    public static func hourlyRate(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "时薪"
        case .fr: return "Taux horaire"
        case .en: return "Hourly"
        case .de: return "Stundensatz"
        case .ja: return "時給換算"
        }
    }

    public static func dailyRate(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "日薪"
        case .fr: return "Par jour"
        case .en: return "Daily"
        case .de: return "Tagessatz"
        case .ja: return "日給換算"
        }
    }

    public static func annualRate(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "年薪"
        case .fr: return "Par an"
        case .en: return "Annual"
        case .de: return "Pro Jahr"
        case .ja: return "年収"
        }
    }

    public static func todayContribution(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "今日进账"
        case .fr: return "Gains du jour"
        case .en: return "Today"
        case .de: return "Heute"
        case .ja: return "本日進捗"
        }
    }

    public static func targetLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "目标"
        case .fr: return "Objectif"
        case .en: return "Goal"
        case .de: return "Ziel"
        case .ja: return "目標"
        }
    }

    public static func paydayLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "发薪日"
        case .fr: return "Jour de paie"
        case .en: return "Payday"
        case .de: return "Zahltag"
        case .ja: return "給料日"
        }
    }

    public static func monthEarned(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "本月已赚"
        case .fr: return "Ce mois"
        case .en: return "This Month"
        case .de: return "Diesen Monat"
        case .ja: return "今月の稼ぎ"
        }
    }

    public static func monthProgress(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "完成"
        case .fr: return "Progression"
        case .en: return "Progress"
        case .de: return "Fortschritt"
        case .ja: return "達成率"
        }
    }

    public static func nextRest(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "下一个休息"
        case .fr: return "Prochain repos"
        case .en: return "Next rest"
        case .de: return "Nächste Pause"
        case .ja: return "次の休日"
        }
    }

    public static func weekendBadge(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "周末"
        case .fr: return "Week-end"
        case .en: return "Weekend"
        case .de: return "Wochenende"
        case .ja: return "週末"
        }
    }

    public static func holidayBadge(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "假期"
        case .fr: return "Férié"
        case .en: return "Holiday"
        case .de: return "Feiertag"
        case .ja: return "祝日"
        }
    }

    public static func restingNow(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "享受周末中"
        case .fr: return "Bon week-end !"
        case .en: return "Enjoying weekend!"
        case .de: return "Schönes Wochenende!"
        case .ja: return "週末を満喫中！"
        }
    }

    public static func workTenure(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "工作年限"
        case .fr: return "Ancienneté"
        case .en: return "Work tenure"
        case .de: return "Betriebszugehörigkeit"
        case .ja: return "勤続年数"
        }
    }

    public static func tenureFormat(years: Int, months: Int, lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "\(years) 年 \(months) 个月"
        case .fr: return "\(years) ans \(months) mois"
        case .en: return "\(years) yrs \(months) mos"
        case .de: return "\(years) J \(months) M"
        case .ja: return "\(years) 年 \(months) ヶ月"
        }
    }

    public static func yearsUntilRetirement(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "距退休"
        case .fr: return "Avant retraite"
        case .en: return "To retirement"
        case .de: return "Bis zur Rente"
        case .ja: return "定年まで"
        }
    }

    public static func yearsUnit(years: Int, lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "\(years) 年"
        case .fr: return "\(years) ans"
        case .en: return "\(years) years"
        case .de: return "\(years) Jahre"
        case .ja: return "\(years) 年"
        }
    }

    public static func workedToday(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "已工作"
        case .fr: return "Travaillé"
        case .en: return "Worked"
        case .de: return "Gearbeitet"
        case .ja: return "本日の勤務"
        }
    }

    public static func remainingToday(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "距下班"
        case .fr: return "Fin de journée"
        case .en: return "Until off"
        case .de: return "Bis Feierabend"
        case .ja: return "退勤まで"
        }
    }

    public static func doubleClickHint(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "双击卡片打开设置 · 本地存储"
        case .fr: return "Double-clic pour réglages · Local"
        case .en: return "Double-click for settings · Local"
        case .de: return "Doppelklick für Einstellungen · Lokal"
        case .ja: return "ダブルクリックで設定 · ローカル保存"
        }
    }
}

// MARK: - Currency Number Formatter

public enum CurrencyFormatter {
    /// Formats amount using dot for RMB/USD and comma for European currencies (EUR/CHF)
    public static func format(value: Double, currency: String, decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals

        let isEuropean = ["EUR", "CHF", "SEK", "NOK", "DKK"].contains(currency.uppercased())
        if isEuropean {
            // European standard: comma as decimal separator, space as thousands grouping
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = " "
        } else {
            // Standard RMB/USD/GBP/JPY: dot as decimal separator, comma as thousands grouping
            formatter.decimalSeparator = "."
            formatter.groupingSeparator = ","
        }

        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.\(decimals)f", value)
    }
}

// MARK: - Motivational Quotes

enum MotivationalQuotes {
    static let quotesZH: [String] = [
        "keep going 💪",
        "money is flowing 💰",
        "钱在路上了 🚀",
        "加油打工人 💼",
        "专注进账 ⚡️",
        "每一秒都在变现 💵",
        "工资正在到账中... 🏦",
        "每一刻付出都算数 ⏰",
        "又赚了一点点 🤑",
        "今天也要元气满满 ☀️",
    ]

    static let quotesFR: [String] = [
        "keep going 💪",
        "L'argent rentre 💰",
        "Chaque seconde compte ⏱",
        "Patience, ça monte 🚀",
        "En pause café payée ☕️",
        "Bientôt le week-end 🏖",
        "Objectif liberté financière 📈",
    ]

    static let quotesEN: [String] = [
        "keep going 💪",
        "money is flowing 💰",
        "you're doing great! ✨",
        "every second counts ⏱",
        "earning while breathing 🌬",
        "getting closer to freedom 📈",
        "paycheck loading... 🏦",
    ]

    static let quotesDE: [String] = [
        "Weiter so! 💪",
        "Das Geld fließt 💰",
        "Jede Sekunde zählt ⏱",
        "Schritt für Schritt zur Freiheit 🚀",
        "Bezahlte Kaffeepause ☕️",
        "Bald ist Wochenende 🏖",
        "Das Gehalt wächst kontinuierlich 📈",
    ]

    static let quotesJA: [String] = [
        "一歩ずつ前進 💪",
        "お給料チャージ中 💰",
        "毎秒があなたの価値 ⏱",
        "給料日へカウントダウン 🚀",
        "有給コーヒーブレイク中 ☕️",
        "もうすぐ週末 🏖",
        "今日も一日お疲れ様です ✨",
    ]

    static func random(lang: AppLanguage = .zh) -> String {
        switch lang {
        case .zh: return quotesZH.randomElement() ?? "keep going 💪"
        case .fr: return quotesFR.randomElement() ?? "keep going 💪"
        case .en: return quotesEN.randomElement() ?? "keep going 💪"
        case .de: return quotesDE.randomElement() ?? "Weiter so! 💪"
        case .ja: return quotesJA.randomElement() ?? "一歩ずつ前進 💪"
        }
    }
}

// MARK: - Supported Currencies

struct CurrencyInfo: Identifiable, Hashable {
    let id: String // ISO code
    let symbol: String
    let name: String
    let localName: String

    var displayLabel: String {
        "\(symbol) \(id) - \(localName)"
    }
}

enum SupportedCurrencies {
    static let all: [CurrencyInfo] = [
        CurrencyInfo(id: "CNY", symbol: "¥", name: "Chinese Yuan", localName: "人民币"),
        CurrencyInfo(id: "EUR", symbol: "€", name: "Euro", localName: "欧元"),
        CurrencyInfo(id: "USD", symbol: "$", name: "US Dollar", localName: "美元"),
        CurrencyInfo(id: "GBP", symbol: "£", name: "British Pound", localName: "英镑"),
        CurrencyInfo(id: "JPY", symbol: "¥", name: "Japanese Yen", localName: "日元"),
        CurrencyInfo(id: "CHF", symbol: "Fr", name: "Swiss Franc", localName: "瑞士法郎"),
        CurrencyInfo(id: "HKD", symbol: "HK$", name: "Hong Kong Dollar", localName: "港币"),
        CurrencyInfo(id: "TWD", symbol: "NT$", name: "Taiwan Dollar", localName: "新台币"),
        CurrencyInfo(id: "SGD", symbol: "S$", name: "Singapore Dollar", localName: "新加坡元"),
        CurrencyInfo(id: "CAD", symbol: "C$", name: "Canadian Dollar", localName: "加元"),
        CurrencyInfo(id: "AUD", symbol: "A$", name: "Australian Dollar", localName: "澳元"),
        CurrencyInfo(id: "KRW", symbol: "₩", name: "South Korean Won", localName: "韩元"),
    ]

    static func currency(for code: String) -> CurrencyInfo? {
        all.first { $0.id == code }
    }

    static func symbol(for code: String) -> String {
        currency(for: code)?.symbol ?? code
    }
}
