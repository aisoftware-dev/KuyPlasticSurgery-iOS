import SwiftUI

fileprivate var dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()

struct ScheduleView: View {
  @State var selectedDate: Date? = Date()
  
  @State var selectedMonth = Date()

  @ObservedObject var viewModel: ScheduleViewModel
  
  @State var isShowingConfirmationView: Bool = false
  
  var appointments: [AppointmentSlot] {
    viewModel.appointments(for: selectedDate ?? Date())
  }
  
  var isLoading: Bool {
    viewModel.isLoading(for: selectedDate ?? Date())
  }

  var formattedDate: String {
    selectedDate.map {
      dateFormatter.string(from: $0)
    } ?? ""
  }

  var body: some View {
    VStack(spacing: 0) {
      calendarView
        .background(.black)
      appointmentView
        .background(Color.lightBlue)
      Spacer()
      NavigationLink<Text, EmptyView>("", isActive: $isShowingConfirmationView) {
        EmptyView()
      }.hidden()
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .background(.white)
    .navigationBarBackButtonHidden(true)
    .navigationTitle("Appointments")
  }

  var calendarView: some View {
    CalendarView(
      interval: .init(),
      month: $selectedMonth
    ) { date in
      DayView(date: date, selectedDate: $selectedDate, onSelect: { viewModel.date = $0 })
    }
    .background(.black)
    .padding([.leading, .trailing])
  }

  var appointmentView: some View {
    VStack {
      appointmentHeaderView
        .padding([.top, .leading])
      if isLoading {
        VStack {
          Spacer()
          ProgressView()
            .foregroundColor(.white)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
          Spacer()
        }
      } else if appointments.isEmpty {
        emptyAppiontmentView
          .padding([.bottom, .top])
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
        SmallAppointmentPreviewView(
          name: appointment.doctor,
          time: appointment.startTime,
          image: appointment.photo
        )
          .padding([.leading, .trailing, .top])
          .onTapGesture {
            env.navigator.go(to: .confirmAppointment(viewModel.procedure, appointment))
          }
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
  let image: UIImage

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
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
      .frame(width: 60, height: 60, alignment: .center)
      .background(.white)
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
//
//struct ScheduleView_Previews: PreviewProvider {
//  @State static var isShowing: Bool = true
//
//  static var previews: some View {
//    ScheduleView(viewModel: .init(procedure: "Surgery", .instant))
//  }
//}
