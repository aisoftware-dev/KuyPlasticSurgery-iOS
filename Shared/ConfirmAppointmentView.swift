import SwiftUI

struct ConfirmAppintmentView: View {

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

  var dateTitle: String {
    ConfirmAppintmentView.dateFormatter.string(from: appointment.time)
  }

  var timeTitle: String {
    ConfirmAppintmentView.timeFormatter.string(from: appointment.time)
  }

  var body: some View {
    VStack {
      imageView
      titleView
      itemViews
      Spacer()
      VStack {
        ButtonView(title: "Confirm", onSelect: {})
        ButtonView(title: "Close", onSelect: {})
      }
    }
    .padding([.leading, .trailing])
  }

  var imageView: some View {
    Image.init(systemName: "person")
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
      ItemView(title: appointment.procedure, subtitle: "Procedure", imageName: nil)
    }
  }
}

fileprivate struct ButtonView: View {
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

fileprivate struct ItemView: View  {
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

struct ConfirmAppointmentView_Previews: PreviewProvider {
  static var previews: some View {
    let appointment = Appointment(time: Date(), image: .image(UIImage()), procedure: "Surgery", doctor: "Daniel Cane", creationDate: Date(), duration: 60 *  10)
    return ConfirmAppintmentView(title: "Confirm Appointment", subtitle: "Please confirm the appointment with \(appointment.doctor)", appointment: appointment)
  }
}
