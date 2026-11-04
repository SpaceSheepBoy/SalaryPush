import SwiftUI

/// Displays work tenure, years to retirement, and daily progress bar with compact styling
struct WorkProgressView: View {
    let calculator: EarningsCalculator
    let currentDate: Date
    let language: AppLanguage

    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let coralColor = Color(red: 0.92, green: 0.44, blue: 0.46)
    private let lavenderColor = Color(red: 0.75, green: 0.55, blue: 0.95)

    private var tenure: (years: Int, months: Int) {
        calculator.workTenure(at: currentDate)
    }

    private var retirementYears: Int {
        calculator.yearsUntilRetirement(at: currentDate)
    }

    private var progress: Double {
        calculator.dayProgress(at: currentDate)
    }

    private var workedTime: TimeInterval {
        calculator.secondsWorkedToday(at: currentDate)
    }

    private var remainingTime: TimeInterval {
        calculator.secondsUntilEndOfWork(at: currentDate)
    }

    var body: some View {
        VStack(spacing: 8) {
            // Tenure and Retirement Cards in a compact rounded dark box
            HStack(spacing: 0) {
                // Left: 工作年限
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.workTenure(language))
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(grayTeal)

                    Text(L10n.tenureFormat(years: tenure.years, months: tenure.months, lang: language))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(lavenderColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right: 距退休
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.yearsUntilRetirement(language))
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(grayTeal)

                    Text(L10n.yearsUnit(years: retirementYears, lang: language))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.06, green: 0.11, blue: 0.13))
            )

            // Today's Work Time & Progress Bar
            VStack(spacing: 6) {
                HStack {
                    Text("\(L10n.workedToday(language)) \(workedTime.hhmmss)")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(grayTeal)
                        .monospacedDigit()

                    Spacer()

                    Text("\(L10n.remainingToday(language)) \(remainingTime.hhmmss)")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(coralColor)
                        .monospacedDigit()
                }

                // Coral pink progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.10, green: 0.18, blue: 0.21))

                        Capsule()
                            .fill(coralColor)
                            .frame(width: geo.size.width * CGFloat(min(1.0, max(0.0, progress))))
                            .animation(.linear(duration: 0.3), value: progress)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}
