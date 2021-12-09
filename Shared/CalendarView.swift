import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let showHeaders: Bool
    let content: (Date) -> DateView

    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(months, id: \.self) { month in
                Section(header: header(for: month)) {
                    ForEach(days(for: month), id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date).id(date)
                        } else {
                            content(date).hidden()
                        }
                    }
                }
            }
        }
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    private func header(for month: Date) -> some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month

        return Group {
            if showHeaders {
              VStack {
                Text(formatter.string(from: month))
                  .foregroundColor(.white)
                  .font(.title)
                  .padding()
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                  ForEach(["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"], id: \.self) { name in
                    Text(name)
                      .foregroundColor(.white)
                      .font(.caption)
                  }
                }
              }
            }
        }
    }

    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}

struct DayView: View {
  @Environment(\.calendar) var calendar
  
  let date: Date
  let today: Date = Date()
  
  @Binding var selectedDate: Date?
  
  var isSelected: Bool {
    if let selectedDate = selectedDate {
      let selectedComp = self.calendar.dateComponents([.day, .month, .year], from: selectedDate)
      let dateComp =  self.calendar.dateComponents([.day, .month, .year], from: date)
      return selectedComp == dateComp
    }
    return false
  }
  
  var isTodaysDate: Bool {
    let todayComp = self.calendar.dateComponents([.day, .month, .year], from: today)
    let dateComp =  self.calendar.dateComponents([.day, .month, .year], from: date)
    return todayComp == dateComp
  }
  
  var isPastDate: Bool {
    date.timeIntervalSince1970 < today.timeIntervalSince1970
  }
  
  var textColor: Color {
    if isTodaysDate {
      return isSelected ? Color.white : Color.lightBlue
    }
    
    return isPastDate ? Color.gray : Color.white
  }
  
  var backgroundColor: Color {
    isSelected ? Color.lightBlue : Color.clear
  }
  
  var body: some View {
    Text("30")
      .foregroundColor(.clear)
      .padding(8)
      .background(backgroundColor)
      .clipShape(Circle())
      .padding(.vertical, 4)
      .overlay(
        VStack {
        Text(String(self.calendar.component(.day, from: date)))
          .foregroundColor(textColor)
        }.onTapGesture {
          selectedDate = date
        }
      )
  }
}

struct CalendarView_Previews: PreviewProvider {
  static let calendar = Calendar.current
  @State static var selectedDate: Date? = Date()
  
  static var previews: some View {
    CalendarView(interval: .init()) { date in
      DayView(date: date, selectedDate: $selectedDate)
        .onTapGesture {
          selectedDate = date 
        }
    }
    .background(.black)
    .padding([.leading, .trailing])
  }
}
