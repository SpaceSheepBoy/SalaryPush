import Foundation

// MARK: - Benefit Summary

public struct BenefitSummary {
    public let title: String
    public let todayAccumulated: Double
    public let monthlyAmount: Double
    public let formulaText: String
}

// MARK: - Next Rest Info & Strip

public struct DayStripItem: Identifiable {
    public var id: Int
    public let dayNumber: String
    public let isToday: Bool
    public let isWorkDay: Bool
    public let isPastOrToday: Bool
}

public struct NextRestInfo {
    public let badgeName: String
    public let countdownSeconds: TimeInterval
    public let startDateFormatted: String
    public let dayStrips: [DayStripItem]
}

// MARK: - Earnings Calculator

struct EarningsCalculator {
    let settings: SalarySettings
    let exchangeRate: Double // from salary currency to display currency

    // MARK: - Working Days Calculation

    var workingDaysPerYear: Double {
        let weeksPerYear = 52.0
        let totalWorkDaysRaw = weeksPerYear * Double(settings.workDaysPerWeek)
        var totalHolidays = Double(settings.annualPaidHolidays + settings.annualPublicHolidays)

        if settings.countrySystem == .france {
            totalHolidays += Double(settings.franceRTTDays)
        }

        return max(1, totalWorkDaysRaw - totalHolidays)
    }

    var workingHoursPerYear: Double {
        workingDaysPerYear * settings.workHoursPerDay
    }

    // MARK: - Earnings in Salary Currency

    var dailyEarningsSalaryCurrency: Double {
        settings.annualSalary / workingDaysPerYear
    }

    var hourlyEarningsSalaryCurrency: Double {
        guard settings.workHoursPerDay > 0 else { return 0 }
        return dailyEarningsSalaryCurrency / settings.workHoursPerDay
    }

    var perSecondEarningsSalaryCurrency: Double {
        hourlyEarningsSalaryCurrency / 3600.0
    }

    // MARK: - Earnings in Display Currency

    var dailyEarnings: Double {
        dailyEarningsSalaryCurrency * exchangeRate
    }

    var hourlyEarnings: Double {
        hourlyEarningsSalaryCurrency * exchangeRate
    }

    var perSecondEarnings: Double {
        perSecondEarningsSalaryCurrency * exchangeRate
    }

    var monthlySalaryDisplay: Double {
        settings.monthlySalary * exchangeRate
    }

    var annualEarnings: Double {
        settings.annualSalary * exchangeRate
    }

    // MARK: - Today's Earnings (Strictly 2 Decimals when Formatted)

    func todayEarnings(at date: Date) -> Double {
        guard settings.isTodayWorkDay else { return 0 }

        let workStart = settings.todayWorkStart
        let workEnd = settings.todayWorkEnd

        guard date >= workStart else { return 0 }

        let effectiveEnd = min(date, workEnd)
        let secondsWorked = max(0, effectiveEnd.timeIntervalSince(workStart))
        return secondsWorked * perSecondEarnings
    }

    // MARK: - Work Status

    func isCurrentlyWorking(at date: Date) -> Bool {
        guard settings.isTodayWorkDay else { return false }
        return date >= settings.todayWorkStart && date <= settings.todayWorkEnd
    }

    func secondsWorkedToday(at date: Date) -> TimeInterval {
        guard settings.isTodayWorkDay else { return 0 }
        let workStart = settings.todayWorkStart
        let workEnd = settings.todayWorkEnd
        guard date >= workStart else { return 0 }
        let effectiveEnd = min(date, workEnd)
        return max(0, effectiveEnd.timeIntervalSince(workStart))
    }

    func secondsUntilEndOfWork(at date: Date) -> TimeInterval {
        let workEnd = settings.todayWorkEnd
        return max(0, workEnd.timeIntervalSince(date))
    }

    func dayProgress(at date: Date) -> Double {
        guard settings.isTodayWorkDay else { return 0 }
        let totalWorkSeconds = settings.workHoursPerDay * 3600.0
        guard totalWorkSeconds > 0 else { return 0 }
        let worked = secondsWorkedToday(at: date)
        return min(1.0, worked / totalWorkSeconds)
    }

    // MARK: - Social Benefit Summary (Localized & Locale Separators)

    func benefitSummary(at date: Date) -> BenefitSummary {
        let curr = settings.displayCurrency
        let sym = settings.displayCurrencySymbol
        let secondsWorked = secondsWorkedToday(at: date)
        let lang = settings.appLanguage

        switch settings.countrySystem {
        case .china:
            let rate = settings.chinaHousingFundRate / 100.0
            let socialExtra = settings.chinaIncludeSocialSecurity ? 0.10 : 0.0
            let totalMonthly = settings.monthlySalary * (rate * 2.0 + socialExtra)
            let perSecond = (totalMonthly * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
            let accumulated = secondsWorked * perSecond
            let monthlyDisplay = totalMonthly * exchangeRate

            let title: String
            switch lang {
            case .zh: title = settings.chinaIncludeSocialSecurity ? "公积金+社保" : "公积金"
            case .fr: title = "Fonds Logement"
            default: title = "Housing Fund"
            }

            let monthlyFormatted = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)
            let rateText = "\(Int(settings.chinaHousingFundRate))%×2"
            let formula: String
            switch lang {
            case .zh: formula = "月入 \(sym)\(monthlyFormatted) · \(rateText)"
            case .fr: formula = "Mois: \(monthlyFormatted) \(sym) · \(rateText)"
            default: formula = "Monthly: \(sym)\(monthlyFormatted) · \(rateText)"
            }

            return BenefitSummary(
                title: title,
                todayAccumulated: accumulated,
                monthlyAmount: monthlyDisplay,
                formulaText: formula
            )

        case .france:
            let cotisationRate = settings.franceStatus.defaultCotisationRate / 100.0

            switch settings.franceDisplayFocus {
            case .cotisations:
                let monthlyCotisation = settings.monthlySalary * cotisationRate
                let perSecond = (monthlyCotisation * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
                let accumulated = secondsWorked * perSecond
                let monthlyDisplay = monthlyCotisation * exchangeRate
                let statusLabel = settings.franceStatus == .cadre ? "Cadre" : (settings.franceStatus == .nonCadre ? "Non-cadre" : "Fonctionnaire")
                let monthlyFormatted = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

                let title: String
                switch lang {
                case .zh: title = "社保 Cotisations"
                case .fr: title = "Cotisations"
                default: title = "Cotisations"
                }

                let formula: String
                switch lang {
                case .zh: formula = "月缴 \(sym)\(monthlyFormatted) · \(statusLabel) (-\(Int(cotisationRate * 100))%)"
                case .fr: formula = "\(monthlyFormatted) \(sym)/mois · \(statusLabel) (-\(Int(cotisationRate * 100))%)"
                default: formula = "\(sym)\(monthlyFormatted)/mo · \(statusLabel) (-\(Int(cotisationRate * 100))%)"
                }

                return BenefitSummary(
                    title: title,
                    todayAccumulated: accumulated,
                    monthlyAmount: monthlyDisplay,
                    formulaText: formula
                )

            case .net:
                let netMonthly = settings.monthlySalary * (1.0 - cotisationRate)
                let perSecond = (netMonthly * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
                let accumulated = secondsWorked * perSecond
                let monthlyDisplay = netMonthly * exchangeRate
                let brutDisplay = settings.monthlySalary * exchangeRate
                let brutFmt = CurrencyFormatter.format(value: brutDisplay, currency: curr, decimals: 0)
                let netFmt = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

                let title: String
                switch lang {
                case .zh: title = "净到手 Net"
                case .fr: title = "Net à payer"
                default: title = "Net Pay"
                }

                let formula: String
                switch lang {
                case .zh: formula = "毛薪 \(sym)\(brutFmt) → 净 \(sym)\(netFmt)"
                case .fr: formula = "Brut \(brutFmt) \(sym) → Net \(netFmt) \(sym)"
                default: formula = "Gross \(sym)\(brutFmt) → Net \(sym)\(netFmt)"
                }

                return BenefitSummary(
                    title: title,
                    todayAccumulated: accumulated,
                    monthlyAmount: monthlyDisplay,
                    formulaText: formula
                )

            case .avantages:
                let workingDaysMonth = workingDaysPerYear / 12.0
                let monthlyTickets = settings.franceDailyTicketRestaurant * workingDaysMonth
                let monthlyTotal = monthlyTickets + settings.franceMonthlyTransport
                let perSecond = (monthlyTotal * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
                let accumulated = secondsWorked * perSecond
                let monthlyDisplay = monthlyTotal * exchangeRate
                let ticketFmt = CurrencyFormatter.format(value: settings.franceDailyTicketRestaurant * exchangeRate, currency: curr, decimals: 1)

                let title: String
                switch lang {
                case .zh: title = "饭补福利"
                case .fr: title = "Tickets Resto"
                default: title = "Meal & Transit"
                }

                let formula: String
                switch lang {
                case .zh: formula = "餐券 \(sym)\(ticketFmt)/天 + 交通50%"
                case .fr: formula = "Tickets: \(ticketFmt) \(sym)/j + Navigo 50%"
                default: formula = "Meal: \(sym)\(ticketFmt)/day + Transit"
                }

                return BenefitSummary(
                    title: title,
                    todayAccumulated: accumulated,
                    monthlyAmount: monthlyDisplay,
                    formulaText: formula
                )
            }

        case .germany:
            let pensionRate = settings.germanyPensionRate / 100.0
            let totalMonthly = settings.monthlySalary * pensionRate * 2.0 // 9.3% AN + 9.3% AG
            let perSecond = (totalMonthly * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
            let accumulated = secondsWorked * perSecond
            let monthlyDisplay = totalMonthly * exchangeRate
            let monthlyFmt = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

            let title = lang == .zh ? "德国法定养老" : (lang == .de ? "Rentenbeitrag" : "German Pension")
            let formula = "\(monthlyFmt) \(sym)/M · 9.3% AN + 9.3% AG"

            return BenefitSummary(
                title: title,
                todayAccumulated: accumulated,
                monthlyAmount: monthlyDisplay,
                formulaText: formula
            )

        case .uk:
            let empRate = settings.ukPensionRate / 100.0
            let matchRate = settings.ukEmployerMatchRate / 100.0
            let totalMonthly = settings.monthlySalary * (empRate + matchRate)
            let perSecond = (totalMonthly * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
            let accumulated = secondsWorked * perSecond
            let monthlyDisplay = totalMonthly * exchangeRate
            let monthlyFmt = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

            let title = lang == .zh ? "职业年金 Pension" : "Workplace Pension"
            let formula = "\(sym)\(monthlyFmt)/mo · 5% + 3% Match"

            return BenefitSummary(
                title: title,
                todayAccumulated: accumulated,
                monthlyAmount: monthlyDisplay,
                formulaText: formula
            )

        case .japan:
            let rate = settings.japanSocialInsuranceRate / 100.0
            let totalMonthly = settings.monthlySalary * rate * 2.0
            let perSecond = (totalMonthly * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
            let accumulated = secondsWorked * perSecond
            let monthlyDisplay = totalMonthly * exchangeRate
            let monthlyFmt = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

            let title = lang == .zh ? "日本社会保険" : (lang == .ja ? "社会保険(年金+健康)" : "Social Insurance")
            let formula = "\(sym)\(monthlyFmt)/月 · 厚生年金+健康 折算"

            return BenefitSummary(
                title: title,
                todayAccumulated: accumulated,
                monthlyAmount: monthlyDisplay,
                formulaText: formula
            )

        case .us, .custom:
            let rate = settings.customBenefitRate / 100.0
            let multiplier = settings.customEmployerMatch ? 2.0 : 1.0
            let monthlyTotal = settings.monthlySalary * rate * multiplier
            let perSecond = (monthlyTotal * 12.0 / workingDaysPerYear / settings.workHoursPerDay / 3600.0) * exchangeRate
            let accumulated = secondsWorked * perSecond
            let monthlyDisplay = monthlyTotal * exchangeRate
            let matchText = settings.customEmployerMatch ? "×2" : ""
            let monthlyFmt = CurrencyFormatter.format(value: monthlyDisplay, currency: curr, decimals: 0)

            let title = settings.countrySystem == .us ? "401(k) / Benefits" : settings.customBenefitName
            let formula = "\(sym)\(monthlyFmt)/mo · \(Int(settings.customBenefitRate))%\(matchText)"

            return BenefitSummary(
                title: title,
                todayAccumulated: accumulated,
                monthlyAmount: monthlyDisplay,
                formulaText: formula
            )
        }
    }

    // MARK: - Tenure & Retirement

    func workTenure(at date: Date) -> (years: Int, months: Int) {
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month], from: settings.workStartDate, to: date)
        return (
            max(0, components.year ?? 0),
            max(0, components.month ?? 0)
        )
    }

    func yearsUntilRetirement(at date: Date) -> Int {
        let cal = Calendar.current
        guard let retirementDate = cal.date(byAdding: .year, value: settings.retirementAge, to: settings.birthday) else {
            return 30
        }
        let interval = retirementDate.timeIntervalSince(date)
        return max(0, Int(round(interval / (365.25 * 24 * 3600))))
    }

    // MARK: - Next Rest Calculation & 7-Day Calendar Strip

    func nextRestInfo(from date: Date) -> NextRestInfo {
        let cal = Calendar.current
        let lang = settings.appLanguage

        var strips: [DayStripItem] = []
        for i in 0..<7 {
            if let d = cal.date(byAdding: .day, value: i, to: date) {
                let dayNum = "\(cal.component(.day, from: d))"
                let weekday = cal.component(.weekday, from: d)
                let isWork = settings.workDays.contains(weekday)
                strips.append(DayStripItem(
                    id: i,
                    dayNumber: dayNum,
                    isToday: i == 0,
                    isWorkDay: isWork,
                    isPastOrToday: i == 0
                ))
            }
        }

        var foundOffset: Int?
        var restLength = 1

        for dayOffset in 0...14 {
            guard let d = cal.date(byAdding: .day, value: dayOffset, to: date) else { continue }
            let weekday = cal.component(.weekday, from: d)

            if !settings.workDays.contains(weekday) {
                foundOffset = dayOffset
                for nextOffset in (dayOffset + 1)...(dayOffset + 14) {
                    guard let nd = cal.date(byAdding: .day, value: nextOffset, to: date) else { break }
                    let nw = cal.component(.weekday, from: nd)
                    if !settings.workDays.contains(nw) {
                        restLength += 1
                    } else {
                        break
                    }
                }
                break
            }
        }

        let offset = foundOffset ?? 1
        guard let restStartDate = cal.date(byAdding: .day, value: offset, to: date) else {
            return NextRestInfo(badgeName: L10n.weekendBadge(lang), countdownSeconds: 0, startDateFormatted: "", dayStrips: strips)
        }

        let weekday = cal.component(.weekday, from: restStartDate)
        let isWeekend = (weekday == 1 || weekday == 7)
        let badge = isWeekend ? L10n.weekendBadge(lang) : L10n.holidayBadge(lang)

        let month = cal.component(.month, from: restStartDate)
        let day = cal.component(.day, from: restStartDate)

        let dateFormatted: String
        switch lang {
        case .zh:
            dateFormatted = "\(month)/\(day) 起 · 共 \(restLength) 天"
        case .ja:
            dateFormatted = "\(month)/\(day) から · 計 \(restLength) 日"
        case .fr:
            dateFormatted = "Dès le \(day)/\(month) · \(restLength) jours"
        case .de:
            dateFormatted = "Ab \(day).\(month). · \(restLength) Tage"
        case .en:
            dateFormatted = "From \(month)/\(day) · \(restLength) days"
        }

        var targetDate: Date
        if offset == 0 {
            targetDate = date
        } else {
            if let lastWorkDay = cal.date(byAdding: .day, value: -1, to: restStartDate) {
                targetDate = lastWorkDay.withTime(hour: settings.workEndHour, minute: settings.workEndMinute)
                if targetDate < date {
                    targetDate = restStartDate.startOfDay
                }
            } else {
                targetDate = restStartDate.startOfDay
            }
        }

        let countdown = max(0, targetDate.timeIntervalSince(date))

        return NextRestInfo(
            badgeName: badge,
            countdownSeconds: countdown,
            startDateFormatted: dateFormatted,
            dayStrips: strips
        )
    }

    // MARK: - Payday Countdown
    public struct PaydayInfo {
        public let days: Int
        public let hours: Int
        public let isEndOfMonth: Bool
        public let displayLabel: String
    }

    public func paydayCountdown(now: Date = Date()) -> PaydayInfo {
        let cal = Calendar.current
        let rawDay = settings.paydayDay
        let isEndOfMonth = rawDay == 0 || rawDay > 30

        var target: Date
        if isEndOfMonth {
            let year = cal.component(.year, from: now)
            let month = cal.component(.month, from: now)
            var comps = DateComponents(year: year, month: month + 1, day: 0, hour: 23, minute: 59, second: 59)
            let lastDayCurrent = cal.date(from: comps) ?? now
            if now.timeIntervalSince1970 >= lastDayCurrent.timeIntervalSince1970 - 86400 {
                comps = DateComponents(year: year, month: month + 2, day: 0, hour: 0, minute: 0, second: 0)
                target = cal.date(from: comps) ?? now
            } else {
                comps = DateComponents(year: year, month: month + 1, day: 0, hour: 0, minute: 0, second: 0)
                target = cal.date(from: comps) ?? now
            }
        } else {
            let year = cal.component(.year, from: now)
            let month = cal.component(.month, from: now)
            var comps = DateComponents(year: year, month: month, day: rawDay, hour: 0, minute: 0, second: 0)
            let targetThisMonth = cal.date(from: comps) ?? now
            if cal.component(.day, from: now) >= rawDay {
                comps = DateComponents(year: year, month: month + 1, day: rawDay, hour: 0, minute: 0, second: 0)
                target = cal.date(from: comps) ?? now
            } else {
                target = targetThisMonth
            }
        }

        let diffSec = max(0, target.timeIntervalSince(now))
        let days = Int(diffSec / 86400)
        let hours = Int((Int(diffSec) % 86400) / 3600)

        let label: String
        if isEndOfMonth {
            switch settings.appLanguage {
            case .zh: label = "每月月底"
            case .fr: label = "Fin de mois"
            case .de: label = "Monatsende"
            case .ja: label = "月末"
            case .en: label = "End of Month"
            }
        } else {
            switch settings.appLanguage {
            case .zh: label = "每月\(rawDay)号"
            case .fr: label = "Le \(rawDay) du mois"
            case .de: label = "Am \(rawDay). des Monats"
            case .ja: label = "毎月\(rawDay)日"
            case .en: label = "Day \(rawDay)"
            }
        }

        return PaydayInfo(days: days, hours: hours, isEndOfMonth: isEndOfMonth, displayLabel: label)
    }

    // MARK: - Custom Wishlist Goal
    public struct CustomWishlistInfo {
        public let name: String
        public let price: Double
        public let formattedPrice: String
        public let rawPrice: Double
        public let rawCurrency: String
        public let todayEarned: Double
        public let progressPercent: Double
    }

    public func customWishlistGoal(todayEarned: Double, exchangeRateService: ExchangeRateService? = nil) -> CustomWishlistInfo {
        let name = settings.customWishlistName.isEmpty ? "我的心愿" : settings.customWishlistName
        let rawPrice = max(1.0, settings.customWishlistPrice)
        let wishlistCurr = settings.customWishlistCurrency.isEmpty ? settings.displayCurrency : settings.customWishlistCurrency
        let displayCurr = settings.displayCurrency

        let rate: Double
        if wishlistCurr == displayCurr {
            rate = 1.0
        } else if let svc = exchangeRateService {
            rate = svc.rate(from: wishlistCurr, to: displayCurr)
        } else if wishlistCurr == settings.salaryCurrency {
            rate = exchangeRate
        } else {
            rate = 1.0
        }

        let convertedPrice = rawPrice * rate
        let progress = min(100.0, (todayEarned / max(0.01, convertedPrice)) * 100.0)
        let formattedBase = CurrencyFormatter.format(value: convertedPrice, currency: displayCurr, decimals: 2)
        let formattedPrice = wishlistCurr != displayCurr ? "\(formattedBase) (\(CurrencyFormatter.format(value: rawPrice, currency: wishlistCurr, decimals: 0)) \(SupportedCurrencies.symbol(for: wishlistCurr)))" : formattedBase

        return CustomWishlistInfo(
            name: name,
            price: convertedPrice,
            formattedPrice: formattedPrice,
            rawPrice: rawPrice,
            rawCurrency: wishlistCurr,
            todayEarned: todayEarned,
            progressPercent: progress
        )
    }

    // MARK: - Month-to-Date Earnings
    public struct MonthEarningsInfo {
        public let pastDaysEarned: Double
        public let todayEarned: Double
        public let totalEarned: Double
        public let totalExpected: Double
        public let progressPercent: Double
        public let pastWorkDays: Int
        public let totalWorkDaysInMonth: Int
    }

    public func monthToDateEarnings(at date: Date = Date()) -> MonthEarningsInfo {
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let currentDay = cal.component(.day, from: date)

        // Range of days in current month
        guard let range = cal.range(of: .day, in: .month, for: date) else {
            let t = todayEarnings(at: date)
            return MonthEarningsInfo(pastDaysEarned: 0, todayEarned: t, totalEarned: t, totalExpected: max(1, monthlySalaryDisplay), progressPercent: 0, pastWorkDays: 0, totalWorkDaysInMonth: 22)
        }

        var pastWorkDays = 0
        var totalWorkDaysInMonth = 0

        for d in range {
            let comps = DateComponents(year: year, month: month, day: d)
            if let dayDate = cal.date(from: comps) {
                let weekday = cal.component(.weekday, from: dayDate) // 1=Sun, 2=Mon...
                if settings.workDays.contains(weekday) {
                    totalWorkDaysInMonth += 1
                    if d < currentDay {
                        pastWorkDays += 1
                    }
                }
            }
        }

        let pastDaysEarned = Double(pastWorkDays) * dailyEarnings
        let isTodayWork = settings.workDays.contains(cal.component(.weekday, from: date))
        let todayEarned = isTodayWork ? todayEarnings(at: date) : 0
        let totalEarned = pastDaysEarned + todayEarned
        let totalExpected = max(1.0, Double(totalWorkDaysInMonth) * dailyEarnings)
        let progressPercent = min(100.0, max(0.0, (totalEarned / totalExpected) * 100.0))

        return MonthEarningsInfo(
            pastDaysEarned: pastDaysEarned,
            todayEarned: todayEarned,
            totalEarned: totalEarned,
            totalExpected: totalExpected,
            progressPercent: progressPercent,
            pastWorkDays: pastWorkDays,
            totalWorkDaysInMonth: totalWorkDaysInMonth
        )
    }
}
