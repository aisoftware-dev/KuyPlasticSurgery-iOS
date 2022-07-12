import SwiftUI

struct AppointmentView: View {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
  }()

  static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  let appointment: Appointment
  
  @State var isShowingCantCancel: Bool = false
  
  var body: some View {
    VStack {
      HStack {
        Text("Appointment")
        .font(.title)
        Spacer()
      }
        .padding()
      AppointmentPreviewView(appointment: appointment, hidesDetail: true)
        .padding([.leading, .trailing])
      detailView
        .padding([.leading, .trailing])
      Spacer()
      bottomButtons
        .padding([.leading, .trailing])
    }
    .navigationBarBackButtonHidden(true)
    .toolbar(content: {
      ToolbarItem (placement: .navigation)  {
        Image(systemName: "arrow.left")
          .foregroundColor(.blue)
          .onTapGesture {
            env.navigator.go(to: .dismiss)
            //isShowingSelf = false
          }
      }
    })
    .alert("Cancellation cannot be performed less than 24 hours prior to the scheduled appointment. Please call the office at (844)794-7736 to cancel.", isPresented: $isShowingCantCancel) {
      Button("OK", role: .cancel) { }
    }
  }
  
  var createdDate: String {
    Self.dateFormatter.string(from: appointment.createdDate)
  }
  
  var status: String {
    appointment.appointmentStatus?.capitalized ?? ""
  }
  
  var duration: String {
    "\(appointment.minutesDuration ?? 0) Minutes"
  }
  
  var detailView: some View {
    ScrollView {
      VStack {
        ThirdItemView(title: "Created Date:", info: createdDate)
        ThirdItemView(title: "Appointment Status:", info: status)
        ThirdItemView(title: "Duration", info: duration)
        if let location = appointment.location {
          ThirdItemView(title: "Location:", info: "")
          AddressView(location: location)
        }
      }
    }
  }
  
  var canCancel: Bool {
    let diffComponents = Calendar.current.dateComponents([.hour], from: Date(), to: appointment.time)
    let hours = diffComponents.hour ?? 0
    return abs(hours) > 24
  }
  
  var bottomButtons: some View {
    VStack {
      ButtonView(title: "Call") {
        env.router.route(to: .phone)
      }
      ButtonView(title: "Cancel Appointment") {
        if canCancel {
          env.cancelledApoinments.send(appointment)
          //env.network.cancel(appointment: appointment, completion: { _ in })
          env.navigator.go(to: .dismiss)
        } else {
          env.navigator.go(to: .alert(.unableToCancel))
        }
      }
    }
  }
}

fileprivate struct AddressView: View {
  let location: Location
  
  var first: String {
    location.name ?? ""
  }
  
  var second: String {
    location.address ?? ""
  }
  
  var third: String {
    (location.state ?? "") + ", " + (location.zip ?? "")
  }
  
  var body: some View {
    VStack {
      Text(first)
      Text(second)
      Text(third)
      HStack {
        Image(systemName: "mappin.circle.fill")
          .foregroundColor(.lightBlue)
          .padding(.trailing, 5)
        Text("Directions")
          .font(.headline)
          .foregroundColor(.lightBlue)
      }
      .onTapGesture {
        env.router.route(to: .maps(location))
      }
      .padding(.top, 5)
    }
  }
}

fileprivate struct ThirdItemView: View {
  let title: String
  let info: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.body)
      Spacer()
      Text(info)
        .font(.headline)
        .foregroundColor(.gray)
    }
    .padding([.leading, .trailing])
    .padding(.bottom, 10)
  }
}

extension TimeInterval {
  
  var stringValue: String {
    guard self > 0 && self < Double.infinity else {
      return "unknown"
    }
    let time = NSInteger(self)
    
    let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
    let seconds = time % 60
    let minutes = (time / 60) % 60
    let hours = (time / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, ms)
    
  }
}
