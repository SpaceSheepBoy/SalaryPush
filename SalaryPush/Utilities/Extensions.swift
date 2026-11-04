import Foundation

// MARK: - Date Extensions
extension Date {
    /// Returns the start of the current day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Returns a date with specific hour and minute on the same day
    func withTime(hour: Int, minute: Int) -> Date {
        let cal = Calendar.current
        var components = cal.dateComponents([.year, .month, .day], from: self)
        components.hour = hour
        components.minute = minute
        components.second = 0
        return cal.date(from: components) ?? self
    }

    /// Weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    var weekdayIndex: Int {
        Calendar.current.component(.weekday, from: self)
    }

    /// Returns true if this date falls on the given weekday (1=Sun, 7=Sat)
    func isWeekday(_ day: Int) -> Bool {
        weekdayIndex == day
    }
}

// MARK: - Number Formatting
extension Double {
    /// Format as currency string with proper separator (dot for RMB/USD, comma for EUR)
    func currencyString(symbol: String, currency: String = "CNY", decimals: Int = 2) -> String {
        let numStr = CurrencyFormatter.format(value: self, currency: currency, decimals: decimals)
        let isEuropean = ["EUR", "CHF"].contains(currency.uppercased())
        if isEuropean {
            // French/European style: 2 593,91 €
            return "\(numStr) \(symbol)"
        } else {
            // Standard RMB/USD style: ¥2,593.91
            return "\(symbol)\(numStr)"
        }
    }

    /// Format with specified decimals
    func formatted(currency: String = "CNY", decimals: Int = 2) -> String {
        CurrencyFormatter.format(value: self, currency: currency, decimals: decimals)
    }
}

// MARK: - TimeInterval Formatting
extension TimeInterval {
    /// Format as HH:MM:SS
    var hhmmss: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// Format as "X天 HH:MM:SS"
    var daysAndTime: (days: Int, time: String) {
        let totalSeconds = Int(max(0, self))
        let days = totalSeconds / 86400
        let remaining = totalSeconds % 86400
        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60
        return (days, String(format: "%02d:%02d:%02d", hours, minutes, seconds))
    }
}
