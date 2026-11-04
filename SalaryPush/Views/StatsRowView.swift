import SwiftUI

/// Displays per-second, hourly, and daily earnings in 3 compact clean columns
struct StatsRowView: View {
    let perSecond: Double
    let hourly: Double
    let daily: Double
    let currencySymbol: String
    let currencyCode: String
    let language: AppLanguage

    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)

    var body: some View {
        HStack(spacing: 0) {
            // Column 1: 每秒进账
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.perSecond(language))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(grayTeal)

                Text(formatPerSecond(perSecond))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Column 2: 时薪
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.hourlyRate(language))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(grayTeal)

                Text(formatTwoDecimals(hourly))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Column 3: 日薪
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.dailyRate(language))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(grayTeal)

                Text(formatTwoDecimals(daily))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }

    private func formatPerSecond(_ value: Double) -> String {
        let numStr = CurrencyFormatter.format(value: value, currency: currencyCode, decimals: 5)
        let isEuropean = ["EUR", "CHF"].contains(currencyCode.uppercased())
        return isEuropean ? "\(numStr) \(currencySymbol)" : "\(currencySymbol)\(numStr)"
    }

    private func formatTwoDecimals(_ value: Double) -> String {
        let numStr = CurrencyFormatter.format(value: value, currency: currencyCode, decimals: 2)
        let isEuropean = ["EUR", "CHF"].contains(currencyCode.uppercased())
        return isEuropean ? "\(numStr) \(currencySymbol)" : "\(currencySymbol)\(numStr)"
    }
}
