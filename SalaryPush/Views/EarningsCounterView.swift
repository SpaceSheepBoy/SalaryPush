import SwiftUI

/// The animated top earnings counter matching the reference video style with compact layout and locale formatting
struct EarningsCounterView: View {
    let earnings: Double
    var monthInfo: EarningsCalculator.MonthEarningsInfo? = nil
    let currencySymbol: String
    let currencyCode: String
    let isWorking: Bool
    let motivationalText: String
    let language: AppLanguage

    private let coralColor = Color(red: 0.92, green: 0.44, blue: 0.46)
    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let mintColor = Color(red: 0.18, green: 0.90, blue: 0.61)

    var body: some View {
        VStack(spacing: 4) {
            // Top row: "今日已赚" on left, "● 在岗" badge on right
            HStack {
                Text(L10n.todayEarned(language))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(grayTeal)

                Spacer()

                // Status pill badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(isWorking ? Color.red : Color.gray)
                        .frame(width: 5, height: 5)

                    Text(isWorking ? L10n.statusWorking(language) : L10n.statusOffDuty(language))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isWorking ? coralColor : grayTeal)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 2.5)
                .background(
                    Capsule()
                        .fill(isWorking ? Color(red: 0.22, green: 0.10, blue: 0.12) : Color(red: 0.11, green: 0.16, blue: 0.18))
                )
            }

            // Big animated earnings number (strictly 2 decimal places, proper separator)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                let formattedNumber = CurrencyFormatter.format(value: earnings, currency: currencyCode, decimals: 2)
                let isEuropean = ["EUR", "CHF"].contains(currencyCode.uppercased())

                if !isEuropean {
                    Text(currencySymbol)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(coralColor)
                }

                Text(formattedNumber)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(coralColor)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .contentTransition(.numericText())
                    .animation(.linear(duration: 0.05), value: earnings)

                if isEuropean {
                    Text(currencySymbol)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(coralColor)
                }
            }
            .padding(.top, 2)

            // Month-to-Date Live Pill right under Hero Amount
            if let month = monthInfo {
                HStack(spacing: 4) {
                    Text("\(L10n.monthEarned(language)):")
                        .foregroundColor(grayTeal)
                    let formattedMonth = CurrencyFormatter.format(value: month.totalEarned, currency: currencyCode, decimals: 2)
                    let isEuropean = ["EUR", "CHF"].contains(currencyCode.uppercased())
                    Text(isEuropean ? "\(formattedMonth) \(currencySymbol)" : "\(currencySymbol)\(formattedMonth)")
                        .fontWeight(.bold)
                        .foregroundColor(mintColor)
                    Text("(\(L10n.monthProgress(language)) \(String(format: "%.1f", month.progressPercent))%)")
                        .foregroundColor(grayTeal.opacity(0.8))
                }
                .font(.system(size: 11, design: .rounded))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(Color(red: 0.07, green: 0.14, blue: 0.16))
                )
                .overlay(
                    Capsule()
                        .stroke(Color(red: 0.11, green: 0.21, blue: 0.24), lineWidth: 1)
                )
                .padding(.top, 1)
            }

            // Centered motivational quote in elegant serif font
            Text(motivationalText)
                .font(.system(size: 13, weight: .medium, design: .serif))
                .foregroundColor(.white)
                .padding(.top, 1)
        }
    }
}
