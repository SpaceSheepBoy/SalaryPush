import Foundation
import SwiftUI
import Combine

// MARK: - Country / Social System Enum

public enum CountrySystem: String, CaseIterable, Identifiable {
    case china = "china"
    case france = "france"
    case us = "us"
    case custom = "custom"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .china: return "中国 🇨🇳 (五险一金 · 住房公积金)"
        case .france: return "法国 🇫🇷 (Cotisations · RTT · 饭补)"
        case .us: return "美国 🇺🇸 (401k · PTO · 联邦假)"
        case .custom: return "其他/自定义 🌐 (Custom)"
        }
    }
}

// MARK: - France Specific Enums

public enum FranceStatus: String, CaseIterable, Identifiable {
    case cadre = "cadre"
    case nonCadre = "non_cadre"
    case fonctionnaire = "fonctionnaire"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .cadre: return "Cadre (管理/技术干部 ~25% 社保)"
        case .nonCadre: return "Non-cadre (普通雇员 ~22% 社保)"
        case .fonctionnaire: return "Fonctionnaire (公职人员 ~15% 社保)"
        }
    }

    public var defaultCotisationRate: Double {
        switch self {
        case .cadre: return 25.0
        case .nonCadre: return 22.0
        case .fonctionnaire: return 15.0
        }
    }
}

public enum FranceDisplayFocus: String, CaseIterable, Identifiable {
    case cotisations = "cotisations"
    case net = "net"
    case avantages = "avantages"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .cotisations: return "社保缴费 (Cotisations)"
        case .net: return "净薪到手 (Net avant impôt)"
        case .avantages: return "餐补+福利 (Tickets Resto + Navigo)"
        }
    }
}

// MARK: - Salary Input Mode

public enum SalaryInputMode: String, CaseIterable {
    case monthly = "monthly"
    case annual = "annual"

    func label(lang: AppLanguage) -> String {
        switch lang {
        case .zh:
            return self == .monthly ? "月薪 Monthly" : "年薪 Annual"
        case .fr:
            return self == .monthly ? "Mensuel (Mois)" : "Annuel (An)"
        case .en:
            return self == .monthly ? "Monthly" : "Annual"
        }
    }
}

// MARK: - Observable Settings Model Backed by UserDefaults

final class SalarySettings: ObservableObject {
    // MARK: - Language
    @AppStorage("appLanguage") var appLanguage: AppLanguage = .zh

    // MARK: - Country / Social System
    @AppStorage("countrySystem") var countrySystem: CountrySystem = .china

    // MARK: - China Specifics
    @AppStorage("chinaHousingFundEnabled") var chinaHousingFundEnabled: Bool = true
    @AppStorage("chinaHousingFundRate") var chinaHousingFundRate: Double = 12.0
    @AppStorage("chinaIncludeSocialSecurity") var chinaIncludeSocialSecurity: Bool = false

    // MARK: - France Specifics
    @AppStorage("franceStatus") var franceStatus: FranceStatus = .cadre
    @AppStorage("franceDisplayFocus") var franceDisplayFocus: FranceDisplayFocus = .cotisations
    @AppStorage("franceDailyTicketRestaurant") var franceDailyTicketRestaurant: Double = 6.0
    @AppStorage("franceMonthlyTransport") var franceMonthlyTransport: Double = 43.20
    @AppStorage("franceRTTDays") var franceRTTDays: Int = 10

    // MARK: - Custom Specifics
    @AppStorage("customBenefitName") var customBenefitName: String = "401(k) / 福利"
    @AppStorage("customBenefitRate") var customBenefitRate: Double = 10.0
    @AppStorage("customEmployerMatch") var customEmployerMatch: Bool = true

    // MARK: - Salary
    @AppStorage("salaryInputMode") var salaryInputMode: SalaryInputMode = .monthly
    @AppStorage("salaryAmount") var salaryAmount: Double = 10000
    @AppStorage("salaryCurrency") var salaryCurrency: String = "CNY"
    @AppStorage("displayCurrency") var displayCurrency: String = "CNY"

    // MARK: - Work Schedule
    @AppStorage("workStartHour") var workStartHour: Int = 9
    @AppStorage("workStartMinute") var workStartMinute: Int = 0
    @AppStorage("workEndHour") var workEndHour: Int = 18
    @AppStorage("workEndMinute") var workEndMinute: Int = 0

    // MARK: - Work Days (stored as comma-separated weekday indices, 1=Sun..7=Sat)
    @AppStorage("workDays") var workDaysString: String = "2,3,4,5,6" // Mon-Fri

    // MARK: - Holidays & Tenure
    @AppStorage("annualPaidHolidays") var annualPaidHolidays: Int = 5
    @AppStorage("annualPublicHolidays") var annualPublicHolidays: Int = 11
    @AppStorage("workStartDate") var workStartDateInterval: Double = {
        Calendar.current.date(byAdding: .month, value: -64, to: Date())?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }()
    @AppStorage("retirementAge") var retirementAge: Int = 60
    @AppStorage("birthdayInterval") var birthdayInterval: Double = {
        Calendar.current.date(byAdding: .year, value: -29, to: Date())?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }()

    // MARK: - UI & Behavior
    @AppStorage("isMiniMode") var isMiniMode: Bool = false
    @AppStorage("alwaysOnTop") var alwaysOnTop: Bool = false
    @AppStorage("showMenuBarExtra") var showMenuBarExtra: Bool = true
    @AppStorage("hasCompletedSetup") var hasCompletedSetup: Bool = false

    // MARK: - Auto-fill Country Defaults (Still allows manual modifications)

    func applyCountryDefaults(_ country: CountrySystem) {
        countrySystem = country
        switch country {
        case .china:
            salaryCurrency = "CNY"
            displayCurrency = "CNY"
            annualPaidHolidays = 5
            annualPublicHolidays = 11
            retirementAge = 60
            appLanguage = .zh
        case .france:
            salaryCurrency = "EUR"
            displayCurrency = "EUR"
            annualPaidHolidays = 25 // 5 weeks CP
            annualPublicHolidays = 11 // 11 jours fériés
            franceRTTDays = 10
            retirementAge = 64
            appLanguage = .fr
        case .us:
            salaryCurrency = "USD"
            displayCurrency = "USD"
            annualPaidHolidays = 15 // Standard PTO
            annualPublicHolidays = 10 // Federal Holidays
            retirementAge = 67
            appLanguage = .en
        case .custom:
            break
        }
    }

    // MARK: - Computed Properties

    var workDays: Set<Int> {
        get {
            Set(workDaysString.split(separator: ",").compactMap { Int($0) })
        }
        set {
            workDaysString = newValue.sorted().map(String.init).joined(separator: ",")
        }
    }

    var workStartDate: Date {
        get { Date(timeIntervalSince1970: workStartDateInterval) }
        set { workStartDateInterval = newValue.timeIntervalSince1970 }
    }

    var birthday: Date {
        get { Date(timeIntervalSince1970: birthdayInterval) }
        set { birthdayInterval = newValue.timeIntervalSince1970 }
    }

    var monthlySalary: Double {
        switch salaryInputMode {
        case .monthly: return salaryAmount
        case .annual: return salaryAmount / 12.0
        }
    }

    var annualSalary: Double {
        switch salaryInputMode {
        case .monthly: return salaryAmount * 12.0
        case .annual: return salaryAmount
        }
    }

    var workDaysPerWeek: Int {
        workDays.count
    }

    var workHoursPerDay: Double {
        let startMinutes = Double(workStartHour * 60 + workStartMinute)
        let endMinutes = Double(workEndHour * 60 + workEndMinute)
        return max(0, (endMinutes - startMinutes) / 60.0)
    }

    var todayWorkStart: Date {
        Date().withTime(hour: workStartHour, minute: workStartMinute)
    }

    var todayWorkEnd: Date {
        Date().withTime(hour: workEndHour, minute: workEndMinute)
    }

    var isTodayWorkDay: Bool {
        workDays.contains(Date().weekdayIndex)
    }

    var salaryCurrencySymbol: String {
        SupportedCurrencies.symbol(for: salaryCurrency)
    }

    var displayCurrencySymbol: String {
        SupportedCurrencies.symbol(for: displayCurrency)
    }
}
