import Foundation

// MARK: - App Language

public enum AppLanguage: String, CaseIterable, Identifiable {
    case zh = "zh"
    case fr = "fr"
    case en = "en"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .zh: return "简体中文 (Chinese)"
        case .fr: return "Français (French)"
        case .en: return "English"
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
        }
    }

    public static func statusWorking(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "在岗"
        case .fr: return "En poste"
        case .en: return "Working"
        }
    }

    public static func statusOffDuty(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "休息"
        case .fr: return "Repos"
        case .en: return "Off Duty"
        }
    }

    public static func perSecond(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "每秒进账"
        case .fr: return "Par seconde"
        case .en: return "Per second"
        }
    }

    public static func hourlyRate(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "时薪"
        case .fr: return "Taux horaire"
        case .en: return "Hourly"
        }
    }

    public static func dailyRate(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "日薪"
        case .fr: return "Par jour"
        case .en: return "Daily"
        }
    }

    public static func nextRest(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "下一个休息"
        case .fr: return "Prochain repos"
        case .en: return "Next rest"
        }
    }

    public static func weekendBadge(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "周末"
        case .fr: return "Week-end"
        case .en: return "Weekend"
        }
    }

    public static func holidayBadge(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "假期"
        case .fr: return "Férié"
        case .en: return "Holiday"
        }
    }

    public static func workTenure(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "工作年限"
        case .fr: return "Ancienneté"
        case .en: return "Work tenure"
        }
    }

    public static func tenureFormat(years: Int, months: Int, lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "\(years) 年 \(months) 个月"
        case .fr: return "\(years) ans \(months) mois"
        case .en: return "\(years) yrs \(months) mos"
        }
    }

    public static func yearsUntilRetirement(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "距退休"
        case .fr: return "Avant retraite"
        case .en: return "To retirement"
        }
    }

    public static func yearsUnit(years: Int, lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "\(years) 年"
        case .fr: return "\(years) ans"
        case .en: return "\(years) years"
        }
    }

    public static func workedToday(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "已工作"
        case .fr: return "Travaillé"
        case .en: return "Worked"
        }
    }

    public static func remainingToday(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "距下班"
        case .fr: return "Fin de journée"
        case .en: return "Until off"
        }
    }

    public static func doubleClickHint(_ lang: AppLanguage) -> String {
        switch lang {
        case .zh: return "双击卡片打开设置 · 本地存储"
        case .fr: return "Double-clic pour réglages · Local"
        case .en: return "Double-click for settings · Local"
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
        "摸鱼也在赚 🐟",
        "每一秒都在变现 💵",
        "工资正在到账中... 🏦",
        "老板的每一秒都属于你 ⏰",
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

    static func random(lang: AppLanguage = .zh) -> String {
        switch lang {
        case .zh: return quotesZH.randomElement() ?? "keep going 💪"
        case .fr: return quotesFR.randomElement() ?? "keep going 💪"
        case .en: return quotesEN.randomElement() ?? "keep going 💪"
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
