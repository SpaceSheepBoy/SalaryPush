import SwiftUI

/// Displays countdown to next rest day and 7-day pill strip with compact layout
struct CountdownView: View {
    let nextRestInfo: NextRestInfo
    let language: AppLanguage

    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let mintColor = Color(red: 0.18, green: 0.85, blue: 0.60)
    private let darkPillTrack = Color(red: 0.10, green: 0.18, blue: 0.21)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header: "下一个休息" + Badge
            HStack {
                Text(L10n.nextRest(language))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(grayTeal)

                Spacer()

                // Badge in amber/gold
                Text(nextRestInfo.badgeName)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(red: 0.98, green: 0.75, blue: 0.14))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.22, green: 0.17, blue: 0.06))
                    )
            }

            // Big countdown timer: e.g. "3天06:17:00"
            let dt = nextRestInfo.countdownSeconds.daysAndTime
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                if dt.days > 0 {
                    Text("\(dt.days)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()

                    let dayUnit = language == .zh ? "天" : (language == .fr ? "j " : (language == .de ? "T " : (language == .ja ? "日" : "d ")))
                    Text(dayUnit)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                Text(dt.time)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.8)

            // Subtitle: e.g. "11/7 起 · 共 2 天"
            Text(nextRestInfo.startDateFormatted)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(grayTeal)
                .padding(.top, -3)

            // 7-day dash pills strip with dates underneath
            HStack(spacing: 5) {
                ForEach(nextRestInfo.dayStrips) { item in
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(item.isToday ? mintColor : (item.isWorkDay ? darkPillTrack : Color(red: 0.14, green: 0.24, blue: 0.28)))
                            .frame(height: 4)

                        Text(item.dayNumber)
                            .font(.system(size: 10, weight: item.isToday ? .bold : .regular))
                            .foregroundColor(item.isToday ? .white : grayTeal)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 2)
        }
    }
}
