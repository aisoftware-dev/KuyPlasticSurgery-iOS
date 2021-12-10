import SwiftUI

fileprivate var dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()

struct ScheduleView: View {
  @State var selectedDate: Date? = Date()
  @State var selectedMonth = Date()

  let appointments: [Appointment]

  var formattedDate: String {
    selectedDate.map {
      dateFormatter.string(from: $0)
    } ?? ""
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        calendarView
          .background(.black)
        appointmentView
          .background(Color.lightBlue)
      }
      .background(.white)
      .navigationTitle("Select Date And Time")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  var calendarView: some View {
    CalendarView(
      interval: .init(),
      month: $selectedMonth
    ) { date in
      DayView(date: date, selectedDate: $selectedDate)
        .onTapGesture {
          selectedDate = date
        }
    }
    .background(.black)
    .padding([.leading, .trailing])
  }

  var appointmentView: some View {
    VStack {
      appointmentHeaderView
        .padding([.top, .leading])
      if appointments.isEmpty {
        emptyAppiontmentView
          .padding(.bottom)
      } else {
        appointmentScrollView
      }
      Spacer()
    }
    .background(Color.accentColor)
  }

  var appointmentHeaderView: some View {
    HStack {
      Text("Available Times")
        .font(.headline)
        .foregroundColor(.white)
      Spacer()
    }
  }

  var emptyAppiontmentView: some View {
    HStack {
      Spacer()
      Text("No appointment times available for \(formattedDate)")
        .foregroundColor(.white)
        .padding([.leading, .trailing])
      Spacer()
    }
  }

  var appointmentScrollView: some View {
    ScrollView {
      ForEach(appointments, id: \.self) { appointment in
        SmallAppointmentPreviewView(name: appointment.doctor, time: appointment.time)
          .padding()
      }
    }
  }
}

struct SmallAppointmentPreviewView: View {
  static let dateFormater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
  }()

  let name: String
  let time: Date

  var body: some View {
    HStack {
      imageView
      nameView
      timeView
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(.white)
    )
  }

  var imageView: some View {
    Image.init(systemName: "person")
      .frame(width: 60, height: 60, alignment: .center)
      .background(.blue)
      .clipShape(Circle())
  }

  var nameView: some View {
    HStack {
      Text(name)
        .font(.headline)
        .foregroundColor(.secondary)
        .padding(.leading, 10)
      Spacer()
    }
  }

  var timeView: some View {
    Text(SmallAppointmentPreviewView.dateFormater.string(from: time))
      .font(.headline)
      .foregroundColor(.secondary)
  }
}

struct ScheduleView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleView(appointments: [
      Appointment(time: .init(), image: .image(UIImage()), procedure: "Surgery", doctor: "Dr. Something"),
      Appointment(time: .init(), image: .image(UIImage()), procedure: "Surgery", doctor: "Dr. Something"),
      Appointment(time: .init(), image: .image(UIImage()), procedure: "Surgery", doctor: "Dr. Something"),
      Appointment(time: .init(), image: .image(UIImage()), procedure: "Surgery", doctor: "Dr. Something"),
    ])
  }
}
