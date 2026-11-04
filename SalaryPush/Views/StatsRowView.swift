import SwiftUI

/// Displays per-second, hourly, daily, and annual earnings in 4 compact clean columns
struct StatsRowView: View {
    let perSecond: Double
    let hourly: Double
    let daily: Double
    var annual: Double = 0.0
    var monthToDate: Double = 0.0
    let currencySymbol: String
    let currencyCode: String
    let language: AppLanguage

    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let mintColor = Color(red: 0.18, green: 0.90, blue: 0.61)

    var body: some View {
        HStack(spacing: 2) {
            // Column 1: 每秒进账
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.perSecond(language))
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundColor(grayTeal)
                    .lineLimit(1)

                Text(formatPerSecond(perSecond))
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Column 2: 时薪
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.hourlyRate(language))
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundColor(grayTeal)
                    .lineLimit(1)

                Text(formatTwoDecimals(hourly))
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Column 3: 日薪
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.dailyRate(language))
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundColor(grayTeal)
                    .lineLimit(1)

                Text(formatTwoDecimals(daily))
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Column 4: 年薪
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.annualRate(language))
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundColor(grayTeal)
                    .lineLimit(1)

                Text(formatTwoDecimals(annual, decimals: 0))
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
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

    private func formatTwoDecimals(_ value: Double, decimals: Int = 2) -> String {
        let numStr = CurrencyFormatter.format(value: value, currency: currencyCode, decimals: decimals)
        let isEuropean = ["EUR", "CHF"].contains(currencyCode.uppercased())
        return isEuropean ? "\(numStr) \(currencySymbol)" : "\(currencySymbol)\(numStr)"
    }
}
