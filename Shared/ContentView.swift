//
//  ContentView.swift
//  Shared
//
//  Created by Kyle Knez on 11/14/21.
//

import SwiftUI

struct ContentView: View {
  let calendar = Calendar.current
  @State var selectedDate: Date? = Date()
  @State var selectedMonth: Date = Date()
  
  var body: some View {
    ScheduleView(appointments: [])
//    CalendarView(interval: .init(), month: $selectedMonth) { date in
//      DayView(date: date, selectedDate: $selectedDate)
////        .onTapGesture {
////          selectedDate = date
////        }
//    }
//    .background(.black)
//    .padding([.leading, .trailing])
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
