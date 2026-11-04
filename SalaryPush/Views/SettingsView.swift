import SwiftUI

/// Settings view allowing users to configure Country, Language, Social Security, Salary, Schedule, and Leave
struct SettingsView: View {
    @ObservedObject var settings: SalarySettings
    @Environment(\.dismiss) private var dismiss

    @State private var workStartDate: Date
    @State private var birthdayDate: Date

    init(settings: SalarySettings) {
        self.settings = settings
        _workStartDate = State(initialValue: settings.workStartDate)
        _birthdayDate = State(initialValue: settings.birthday)
    }

    private let cardBackground = Color(red: 0.055, green: 0.125, blue: 0.145)
    private let cardBorder = Color(red: 0.12, green: 0.22, blue: 0.25)
    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let coralColor = Color(red: 0.92, green: 0.44, blue: 0.46)
    private let outerBackground = Color(red: 0.035, green: 0.078, blue: 0.090)

    private var calc: EarningsCalculator {
        EarningsCalculator(settings: settings, exchangeRate: 1.0)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                ZStack(alignment: .trailing) {
                    VStack(spacing: 4) {
                        Text("⚙️ \(settingsTitle)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text(settingsSubtitle)
                            .font(.system(size: 11))
                            .foregroundColor(grayTeal)
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        settings.hasCompletedSetup = true
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(grayTeal.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 4)
                }
                .padding(.top, 12)

                // 1. Language & Country Section
                settingsSection(title: "🌐 语言与国家制度 (Language & Country)") {
                    // Language Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("界面语言 (Language)")
                            .font(.system(size: 11))
                            .foregroundColor(grayTeal)

                        Picker("", selection: $settings.appLanguage) {
                            ForEach(AppLanguage.allCases) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }

                    // Country Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("国家/地区社会福利制度 (Country System)")
                            .font(.system(size: 11))
                            .foregroundColor(grayTeal)

                        Picker("", selection: $settings.countrySystem) {
                            ForEach(CountrySystem.allCases) { c in
                                Text(c.displayName).tag(c)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .onChange(of: settings.countrySystem) { _, newCountry in
                            // Auto-input holidays, currency, retirement according to country
                            settings.applyCountryDefaults(newCountry)
                        }
                    }

                    Text("💡 切换国家会自动推荐填入该国的年假、法定节假日与退休年龄，您依然可以在下方手动随意修改。")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.35, green: 0.75, blue: 0.87))

                    // Country-Specific Details Card
                    if settings.countrySystem == .china {
                        chinaSection
                    } else if settings.countrySystem == .france {
                        franceSection
                    } else if settings.countrySystem == .germany {
                        germanySection
                    } else if settings.countrySystem == .uk {
                        ukSection
                    } else if settings.countrySystem == .japan {
                        japanSection
                    } else if settings.countrySystem == .us {
                        usSection
                    } else {
                        customCountrySection
                    }
                }

                // 2. Holidays & Leave (Auto-filled by country, but manually adjustable)
                settingsSection(title: "🏖 假期制度 (Holidays & Leave - 可手动调整)") {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("带薪年假 (Paid Holidays)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                            Text(settings.countrySystem == .france ? "法国法定 25 天 (5周)" : (settings.countrySystem == .china ? "国内一般 5~15 天" : "年假天数"))
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                        }

                        Spacer()

                        Stepper("\(settings.annualPaidHolidays) 天", value: $settings.annualPaidHolidays, in: 0...50)
                    }

                    if settings.countrySystem == .france {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("RTT 调休假 (35h工时制)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("法国 37.5h/39h 周制通常补 8~12 天")
                                    .font(.system(size: 10))
                                    .foregroundColor(grayTeal)
                            }

                            Spacer()

                            Stepper("\(settings.franceRTTDays) 天", value: $settings.franceRTTDays, in: 0...30)
                        }
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("法定公共节假日 (Public Holidays)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                            Text(settings.countrySystem == .france ? "法国每年 11 个法定节假日" : (settings.countrySystem == .china ? "中国每年 11 天法定节假日" : "法定休假天数"))
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                        }

                        Spacer()

                        Stepper("\(settings.annualPublicHolidays) 天", value: $settings.annualPublicHolidays, in: 0...40)
                    }

                    HStack {
                        Text("法定退休年龄")
                            .foregroundColor(.white)
                            .font(.system(size: 12))

                        Spacer()

                        Stepper("\(settings.retirementAge) 岁", value: $settings.retirementAge, in: 50...75)
                    }

                    HStack {
                        Text("每月发薪日 (Payday)")
                            .foregroundColor(.white)
                            .font(.system(size: 12))

                        Spacer()

                        Picker("", selection: $settings.paydayDay) {
                            Text("📅 每月月底 (默认)").tag(0)
                            ForEach([1, 5, 8, 10, 15, 20, 25, 28, 30], id: \.self) { d in
                                Text("每月 \(d) 号").tag(d)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                }

                // 3. Custom Wishlist Milestone
                settingsSection(title: "🎯 私人心愿目标 (Milestone Goal)") {
                    HStack {
                        Text("心愿名称")
                            .foregroundColor(grayTeal)
                            .font(.system(size: 11))
                            .frame(width: 60, alignment: .leading)

                        TextField("例如 PS5 / 旅行机票", text: $settings.customWishlistName)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Text("目标金额")
                            .foregroundColor(grayTeal)
                            .font(.system(size: 11))
                            .frame(width: 60, alignment: .leading)

                        TextField("金额", value: $settings.customWishlistPrice, format: .number)
                            .textFieldStyle(.roundedBorder)

                        Picker("", selection: $settings.customWishlistCurrency) {
                            ForEach(SupportedCurrencies.all) { c in
                                Text("\(c.symbol) \(c.id)").tag(c.id)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .frame(width: 90)
                    }

                    HStack {
                        Text("已存金额")
                            .foregroundColor(grayTeal)
                            .font(.system(size: 11))
                            .frame(width: 60, alignment: .leading)

                        TextField("已攒本金 (例如 1000)", value: $settings.customWishlistSaved, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }

                    if settings.customWishlistCurrency != settings.displayCurrency {
                        HStack {
                            Text("💡 折合显示币种 (\(settings.displayCurrency)):")
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                            Spacer()
                            let convRate = (settings.customWishlistCurrency == settings.salaryCurrency ? calc.exchangeRate : 1.0)
                            Text("\(SupportedCurrencies.symbol(for: settings.displayCurrency))\(CurrencyFormatter.format(value: settings.customWishlistPrice * convRate, currency: settings.displayCurrency, decimals: 2)) \(settings.displayCurrency)")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .foregroundColor(Color(red: 0.18, green: 0.90, blue: 0.61))
                        }
                    }
                }

                // 3. Salary & Currency
                settingsSection(title: "💰 薪酬与货币 (Salary & Currency)") {
                    Picker("", selection: $settings.salaryInputMode) {
                        ForEach(SalaryInputMode.allCases, id: \.self) { mode in
                            Text(mode.label(lang: settings.appLanguage)).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settings.salaryInputMode) { oldMode, newMode in
                        if oldMode == .monthly && newMode == .annual {
                            settings.salaryAmount = (settings.salaryAmount * 12.0).rounded()
                        } else if oldMode == .annual && newMode == .monthly {
                            settings.salaryAmount = (settings.salaryAmount / 12.0).rounded()
                        }
                    }

                    Picker("", selection: $settings.salaryTaxMode) {
                        ForEach(SalaryTaxMode.allCases, id: \.self) { mode in
                            Text(mode.label(lang: settings.appLanguage)).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Text(settings.salaryInputMode == .monthly ? "月薪" : "年薪")
                            .foregroundColor(grayTeal)
                            .frame(width: 45, alignment: .leading)

                        TextField("金额", value: $settings.salaryAmount, format: .number)
                            .textFieldStyle(.roundedBorder)

                        Stepper("", value: $settings.salaryAmount, in: 0...100_000_000, step: salaryStep)
                            .labelsHidden()

                        Button("↺ 填入中位数") {
                            settings.applyCountryDefaults(settings.countrySystem)
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 10))
                        .foregroundColor(coralColor)
                        .padding(.horizontal, 2)
                    }

                    // Quick adjustment pills
                    HStack(spacing: 4) {
                        Text("微调:")
                            .font(.system(size: 9.5))
                            .foregroundColor(grayTeal)

                        ForEach(salaryPills, id: \.label) { pill in
                            Button(action: {
                                settings.salaryAmount = max(0, settings.salaryAmount + pill.delta)
                            }) {
                                Text(pill.label)
                                    .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(4)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    HStack {
                        Text("合同币种")
                            .foregroundColor(grayTeal)
                            .frame(width: 60, alignment: .leading)

                        Picker("", selection: $settings.salaryCurrency) {
                            ForEach(SupportedCurrencies.all) { c in
                                Text(c.displayLabel).tag(c.id)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                    }

                    HStack {
                        Text("显示币种")
                            .foregroundColor(grayTeal)
                            .frame(width: 60, alignment: .leading)

                        Picker("", selection: $settings.displayCurrency) {
                            ForEach(SupportedCurrencies.all) { c in
                                Text(c.displayLabel).tag(c.id)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                    }

                    if ["EUR", "CHF"].contains(settings.displayCurrency) {
                        Text("💡 欧元/欧洲货币将以逗号作为小数分隔符 (例: 2 593,91 €)")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.35, green: 0.75, blue: 0.87))
                    } else {
                        Text("💡 人民币及美元以小数点作为分隔符 (例: ¥2,593.91)")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.35, green: 0.75, blue: 0.87))
                    }
                }

                // 3.1 Live Calculation Breakdown (Holiday-linked)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("📊 实时工时与时薪换算 (已关联假期)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("自动精密计算")
                            .font(.system(size: 9))
                            .foregroundColor(coralColor)
                    }

                    VStack(spacing: 5) {
                        HStack {
                            Text("实际年工作日:")
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                            Spacer()
                            Text("\(Int(calc.workingDaysPerYear)) 天 / 年")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }

                        HStack {
                            Text("法定节假 + 年假扣除:")
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                            Spacer()
                            Text("-\(settings.annualPublicHolidays + settings.annualPaidHolidays + (settings.countrySystem == .france ? settings.franceRTTDays : 0)) 天 (已全额扣除)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color(red: 0.18, green: 0.90, blue: 0.61))
                        }

                        HStack {
                            Text("折算日薪:")
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                            Spacer()
                            Text("\(SupportedCurrencies.symbol(for: settings.salaryCurrency))\(CurrencyFormatter.format(value: calc.dailyEarningsSalaryCurrency, currency: settings.salaryCurrency, decimals: 2))")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(coralColor)
                        }

                        HStack {
                            Text("折算时薪:")
                                .font(.system(size: 10))
                                .foregroundColor(grayTeal)
                            Spacer()
                            Text("\(SupportedCurrencies.symbol(for: settings.salaryCurrency))\(CurrencyFormatter.format(value: calc.hourlyEarningsSalaryCurrency, currency: settings.salaryCurrency, decimals: 2))")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(8)
                    .background(Color(red: 0.03, green: 0.08, blue: 0.10))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(cardBorder, lineWidth: 1))

                    Text("💡 逻辑核验：您的假期越多，年实际工作天数越少，分摊到每个工作日的日薪与时薪就越高！")
                        .font(.system(size: 9))
                        .foregroundColor(grayTeal)
                }
                .padding(10)
                .background(cardBackground)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(cardBorder, lineWidth: 1))

                // 4. Work Schedule
                settingsSection(title: "🕐 工时安排 (Work Schedule)") {
                    HStack {
                        Text("上班")
                            .foregroundColor(grayTeal)
                            .frame(width: 50, alignment: .leading)

                        Picker("", selection: $settings.workStartHour) {
                            ForEach(0..<24, id: \.self) { h in
                                Text(String(format: "%02d", h)).tag(h)
                            }
                        }
                        .labelsHidden()
                        .frame(width: 55)

                        Text(":")
                            .foregroundColor(grayTeal)

                        Picker("", selection: $settings.workStartMinute) {
                            ForEach([0, 15, 30, 45], id: \.self) { m in
                                Text(String(format: "%02d", m)).tag(m)
                            }
                        }
                        .labelsHidden()
                        .frame(width: 55)

                        Spacer()
                    }

                    HStack {
                        Text("下班")
                            .foregroundColor(grayTeal)
                            .frame(width: 50, alignment: .leading)

                        Picker("", selection: $settings.workEndHour) {
                            ForEach(0..<24, id: \.self) { h in
                                Text(String(format: "%02d", h)).tag(h)
                            }
                        }
                        .labelsHidden()
                        .frame(width: 55)

                        Text(":")
                            .foregroundColor(grayTeal)

                        Picker("", selection: $settings.workEndMinute) {
                            ForEach([0, 15, 30, 45], id: \.self) { m in
                                Text(String(format: "%02d", m)).tag(m)
                            }
                        }
                        .labelsHidden()
                        .frame(width: 55)

                        Spacer()
                    }

                    // Workdays
                    HStack(spacing: 6) {
                        ForEach(workDayOptions, id: \.weekday) { opt in
                            Button(action: {
                                var days = settings.workDays
                                if days.contains(opt.weekday) {
                                    days.remove(opt.weekday)
                                } else {
                                    days.insert(opt.weekday)
                                }
                                settings.workDays = days
                            }) {
                                Text(opt.label)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(settings.workDays.contains(opt.weekday) ? .white : grayTeal)
                                    .frame(width: 30, height: 30)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(settings.workDays.contains(opt.weekday) ? coralColor : Color.white.opacity(0.06))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // 5. Personal Info
                settingsSection(title: "👤 个人工龄 (Tenure & Retirement)") {
                    DatePicker("入职/参工日期", selection: $workStartDate, displayedComponents: .date)
                        .foregroundColor(grayTeal)
                        .onChange(of: workStartDate) { _, nv in settings.workStartDate = nv }

                    DatePicker("出生日期", selection: $birthdayDate, displayedComponents: .date)
                        .foregroundColor(grayTeal)
                        .onChange(of: birthdayDate) { _, nv in settings.birthday = nv }
                }

                // 6. Display
                settingsSection(title: "🖥 窗口显示 (Display)") {
                    Toggle("窗口置顶 (Always on Top)", isOn: $settings.alwaysOnTop)
                        .foregroundColor(grayTeal)

                    Toggle("菜单栏实时展示 (Menu Bar Extra)", isOn: $settings.showMenuBarExtra)
                        .foregroundColor(grayTeal)
                }

                // Done Button
                Button(action: {
                    settings.hasCompletedSetup = true
                    dismiss()
                }) {
                    Text(saveButtonText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(coralColor)
                        )
                }
                .buttonStyle(.plain)
                .padding(.bottom, 14)
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(outerBackground)
    }

    // MARK: - Country Sections

    private var chinaSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("启用住房公积金计算 (Housing Fund)", isOn: $settings.chinaHousingFundEnabled)
                .foregroundColor(.white)
                .font(.system(size: 12))

            if settings.chinaHousingFundEnabled {
                HStack {
                    Text("缴存费率")
                        .foregroundColor(grayTeal)
                        .font(.system(size: 11))

                    Slider(value: $settings.chinaHousingFundRate, in: 5...12, step: 1)

                    Text("\(Int(settings.chinaHousingFundRate))%")
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .frame(width: 32)
                }

                Text("• 个人缴纳 \(Int(settings.chinaHousingFundRate))% + 企业缴纳 \(Int(settings.chinaHousingFundRate))% = \(Int(settings.chinaHousingFundRate * 2))% 双倍计入个人公积金账户")
                    .font(.system(size: 10))
                    .foregroundColor(grayTeal)
            }

            Toggle("合并统计社保个人账户 (养老8% + 医保2%)", isOn: $settings.chinaIncludeSocialSecurity)
                .foregroundColor(grayTeal)
                .font(.system(size: 11))
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var franceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 3) {
                Text("法国员工身份 (Statut professionnel)")
                    .font(.system(size: 11))
                    .foregroundColor(grayTeal)

                Picker("", selection: $settings.franceStatus) {
                    ForEach(FranceStatus.allCases) { st in
                        Text(st.displayName).tag(st)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("卡片重点追踪项目 (Affichage principal)")
                    .font(.system(size: 11))
                    .foregroundColor(grayTeal)

                Picker("", selection: $settings.franceDisplayFocus) {
                    ForEach(FranceDisplayFocus.allCases) { f in
                        Text(f.displayName).tag(f)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }

            HStack {
                Text("餐券雇主补贴 (Tickets Resto)")
                    .foregroundColor(grayTeal)
                    .font(.system(size: 11))
                Spacer()
                Text("€\(String(format: "%.1f", settings.franceDailyTicketRestaurant))/天")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .monospacedDigit()
                Stepper("", value: $settings.franceDailyTicketRestaurant, in: 0...15, step: 0.5)
                    .labelsHidden()
            }

            HStack {
                Text("交通补贴 (Pass Navigo 50%)")
                    .foregroundColor(grayTeal)
                    .font(.system(size: 11))
                Spacer()
                Text("€\(String(format: "%.1f", settings.franceMonthlyTransport))/月")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .monospacedDigit()
                Stepper("", value: $settings.franceMonthlyTransport, in: 0...100, step: 5)
                    .labelsHidden()
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var germanySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("德国法定养老保险 (Rentenversicherung)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("9.3% + 9.3%")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color(red: 0.18, green: 0.90, blue: 0.61))
            }
            Text("• 雇员 9.3% + 雇主 9.3% = 18.6% 全额统筹，年假通常为 28~30 天。")
                .font(.system(size: 10))
                .foregroundColor(grayTeal)
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var ukSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("英国职业年金 (Workplace Pension)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("5% + 3%")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color(red: 0.18, green: 0.90, blue: 0.61))
            }
            Text("• 个人 5% + 雇主匹配 3% = 8%；法定总休假 28 天（含 8 天 Bank Holidays）。")
                .font(.system(size: 10))
                .foregroundColor(grayTeal)
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var japanSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("日本社会保険 (厚生年金+健康保険)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("~15% + 15%")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color(red: 0.18, green: 0.90, blue: 0.61))
            }
            Text("• 厚生年金与健康险劳资对半；拥有 G7 最高的 16 天法定国民祝日。")
                .font(.system(size: 10))
                .foregroundColor(grayTeal)
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var usSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("401(k) 养老费率")
                    .foregroundColor(grayTeal)
                    .font(.system(size: 11))

                Slider(value: $settings.customBenefitRate, in: 0...20, step: 1)

                Text("\(Int(settings.customBenefitRate))%")
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .frame(width: 32)
            }

            Toggle("公司等额匹配 (Employer 1:1 Match)", isOn: $settings.customEmployerMatch)
                .foregroundColor(grayTeal)
                .font(.system(size: 11))
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    private var customCountrySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("福利名称")
                    .foregroundColor(grayTeal)
                    .frame(width: 70, alignment: .leading)
                    .font(.system(size: 11))

                TextField("例如 年金/福利金", text: $settings.customBenefitName)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                Text("缴存费率")
                    .foregroundColor(grayTeal)
                    .font(.system(size: 11))

                Slider(value: $settings.customBenefitRate, in: 0...30, step: 1)

                Text("\(Int(settings.customBenefitRate))%")
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .frame(width: 32)
            }

            Toggle("包含雇主匹配 (1:1 Match)", isOn: $settings.customEmployerMatch)
                .foregroundColor(grayTeal)
                .font(.system(size: 11))
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(8)
    }

    // MARK: - Helpers

    private var settingsTitle: String {
        switch settings.appLanguage {
        case .zh: return "设置 Settings"
        case .fr: return "Paramètres"
        case .de: return "Einstellungen"
        case .ja: return "設定 (Settings)"
        case .en: return "Settings"
        }
    }

    private var settingsSubtitle: String {
        switch settings.appLanguage {
        case .zh: return "按国家国情自定义社保、公积金、假期与薪资"
        case .fr: return "Configurez vos cotisations, congés et salaire selon votre pays"
        case .de: return "Passen Sie Sozialabgaben, Urlaub und Gehalt nach Land an"
        case .ja: return "国の制度に合わせた社会保険・有休・給与の精密設定"
        case .en: return "Configure social benefits, leave and salary by country"
        }
    }

    private var salaryStep: Double {
        let curr = settings.salaryCurrency.uppercased()
        let isAnnual = settings.salaryInputMode == .annual
        if curr == "JPY" {
            return isAnnual ? 50_000 : 5_000
        }
        return isAnnual ? 500 : 100
    }

    private var salaryPills: [(label: String, delta: Double)] {
        let curr = settings.salaryCurrency.uppercased()
        let isAnnual = settings.salaryInputMode == .annual
        if curr == "JPY" {
            if isAnnual {
                return [("-50万", -500_000), ("-10万", -100_000), ("+10万", 100_000), ("+50万", 500_000), ("+100万", 1_000_000)]
            }
            return [("-5万", -50_000), ("-1万", -10_000), ("+1万", 10_000), ("+5万", 50_000), ("+10万", 100_000)]
        }
        if isAnnual {
            return [("-10,000", -10_000), ("-5,000", -5_000), ("+5,000", 5_000), ("+10,000", 10_000), ("+20,000", 20_000)]
        }
        return [("-500", -500), ("-100", -100), ("+100", 100), ("+500", 500), ("+1,000", 1000)]
    }

    private var saveButtonText: String {
        switch settings.appLanguage {
        case .zh: return "保存并开始进账 (Done)"
        case .fr: return "Enregistrer et lancer"
        case .de: return "Speichern und Starten"
        case .ja: return "保存して開始 (Done)"
        case .en: return "Save and Start"
        }
    }

    @ViewBuilder
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 8) {
                content()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(cardBorder, lineWidth: 1)
            )
        }
    }

    private var workDayOptions: [(label: String, weekday: Int)] {
        [
            ("一", 2), ("二", 3), ("三", 4), ("四", 5),
            ("五", 6), ("六", 7), ("日", 1)
        ]
    }
}
