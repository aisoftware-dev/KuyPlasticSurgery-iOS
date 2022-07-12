import SwiftUI

struct ConfirmAppointmentView: View {
  var appointment: Appointment {
    viewModel.appointment
  }
  
  @ObservedObject var viewModel: ConfirmAppointmentViewModel
  
  var isLoading: Bool {
    viewModel.isLoading(for: appointment)
  }
  
  var isConfirmed: Bool {
    viewModel.isConfirmed(for: appointment)
  }
  
  var body: some View {
    if isLoading {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .navigationBarBackButtonHidden(true)
    } else if isConfirmed {
      confirmedView
        .navigationBarBackButtonHidden(true)
    } else {
      initialView
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .navigation) {
            Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                        .onTapGesture {
                        }
          }
        }
    }
  }
  
  var initialView: some View {
    ConfirmAppintmentSubView(
      title: "Confirm Appiontment",
      subtitle: "Please confirm the appointment with \(appointment.doctor)",
      appointment: appointment,
      buttonTitle: "Confirm",
      onButton: {
        viewModel.confirm(appointment: appointment)
      }) {
        env.navigator.go(to: .dismiss)
      }
  }
  
  var confirmedView: some View {
    ConfirmAppintmentSubView(
      title: "Booking Successful",
      subtitle: "Thank you for scheduling an appointment.",
      appointment: appointment,
      buttonTitle: "Back To Home",
      onButton: {
        env.navigator.go(to: .dismiss)
        ///env.confirmedAppointments.send(appointment)
      },
      onClose: nil
    )
  }
}

struct ConfirmAppintmentSubView: View {

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

  let title: String
  let subtitle: String
  let appointment: Appointment
  
  let buttonTitle: String
  let onButton: () -> Void
  
  let onClose: (() -> Void)?

  var dateTitle: String {
    ConfirmAppintmentSubView.dateFormatter.string(from: appointment.time)
  }

  var timeTitle: String {
    ConfirmAppintmentSubView.timeFormatter.string(from: appointment.time)
  }
  
  var procedure: String {
    appointment.appointmentType ?? ""
  }

  var body: some View {
    VStack {
      imageView
      titleView
      itemViews
      Spacer()
      VStack {
        ButtonView(title: buttonTitle, onSelect: onButton)
        if let onClose = onClose {
          ButtonView(title: "Close", onSelect: onClose)
        }
      }
    }
    .padding([.leading, .trailing])
  }

  var imageView: some View {
    Image("Logo", bundle: .main)
      .frame(width: 90, height: 90, alignment: .center)
      .background(Color.lightBlue)
      .clipShape(Circle())
  }

  var titleView: some View {
    VStack {
      Text(title)
        .font(.title)
      Text(subtitle)
        .font(.title3)
        .foregroundColor(.secondary)
    }
  }

  var itemViews: some View {
    VStack {
      ItemView(title: dateTitle, subtitle: "Date", imageName: "calendar")
      ItemView(title: timeTitle, subtitle: "Time", imageName: "clock")
      ItemView(title: procedure, subtitle: "Procedure", imageName: nil)
    }
  }
}

struct ButtonView: View {
  let title: String
  let onSelect: () -> Void

  var body: some View {
    HStack {
      Spacer()
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(Color.lightBlue)
    )
    .onTapGesture {
      onSelect()
    }
  }
}

struct ItemView: View  {
  let title: String
  let subtitle: String
  let imageName: String?

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
        Text(subtitle)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      if let imageName = imageName {
        Image(systemName: imageName)
          .resizable()
          .frame(width: 32, height: 32, alignment: .center)
          .font(.headline)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray))
  }
}
