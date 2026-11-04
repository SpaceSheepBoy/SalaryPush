import SwiftUI

/// Displays countdown to next rest day and 7-day pill strip with compact layout
struct CountdownView: View {
    let nextRestInfo: NextRestInfo
    let language: AppLanguage

    private let grayTeal = Color(red: 0.50, green: 0.59, blue: 0.62)
    private let mintColor = Color(red: 0.18, green: 0.85, blue: 0.60)
    private let darkPillTrack = Color(red: 0.10, green: 0.18, blue: 0.21)
    private let amberColor = Color(red: 0.98, green: 0.75, blue: 0.14)
    private let amberBackground = Color(red: 0.22, green: 0.16, blue: 0.05)

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
                    .foregroundColor(amberColor)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(amberBackground)
                    )
            }

            if nextRestInfo.isRestingNow {
                HStack(spacing: 6) {
                    Text("🏖️")
                        .font(.system(size: 24))
                    Text(L10n.restingNow(language))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(amberColor)
                }
                .padding(.vertical, 2)
            } else {
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
            }

            // Subtitle: e.g. "11/7 起 · 共 2 天"
            Text(nextRestInfo.startDateFormatted)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(grayTeal)
                .padding(.top, -3)

            // 7-day natural week strip (Monday to Sunday) with weekdays, pills, dates and prominent rest badges
            HStack(spacing: 4) {
                ForEach(nextRestInfo.dayStrips) { item in
                    VStack(spacing: 3) {
                        // 1. Weekday name: 周一, 周二... / Lun, Mar...
                        Text(item.weekdayLabel)
                            .font(.system(size: 9, weight: item.isToday ? .bold : (item.isRestDay ? .semibold : .regular)))
                            .foregroundColor(item.isToday ? .white : (item.isRestDay ? amberColor : grayTeal))
                            .lineLimit(1)

                        // 2. Dash pill
                        Capsule()
                            .fill(item.isToday ? mintColor : (item.isRestDay ? amberColor : (item.isPast ? mintColor.opacity(0.3) : darkPillTrack)))
                            .frame(height: item.isToday || item.isRestDay ? 4 : 3)

                        // 3. Calendar date number
                        Text(item.dayNumber)
                            .font(.system(size: 10, weight: item.isToday ? .bold : (item.isRestDay ? .semibold : .regular)))
                            .foregroundColor(item.isToday ? .white : (item.isRestDay ? amberColor : grayTeal))

                        // 4. Badge: 今 or 休
                        if item.isToday {
                            Text(item.todayBadgeLabel)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(mintColor)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 1)
                                .background(Capsule().fill(mintColor.opacity(0.2)))
                        } else if item.isRestDay {
                            Text(item.restBadgeLabel)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(amberColor)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 1)
                                .background(
                                    Capsule()
                                        .fill(amberColor.opacity(0.25))
                                        .overlay(Capsule().stroke(amberColor.opacity(0.4), lineWidth: 0.5))
                                )
                        } else {
                            Text(" ")
                                .font(.system(size: 8))
                                .padding(.vertical, 1)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 1)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(item.isToday ? mintColor.opacity(0.12) : (item.isRestDay ? amberBackground : Color.white.opacity(0.02)))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(item.isToday ? mintColor.opacity(0.4) : (item.isRestDay ? amberColor.opacity(0.35) : Color.white.opacity(0.04)), lineWidth: 1)
                    )
                }
            }
            .padding(.top, 2)
        }
    }
}
