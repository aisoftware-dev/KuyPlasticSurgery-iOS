import SwiftUI

struct AppointmentPreviewView: View {
  @ObservedObject var meta = env.meta
  
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
  let hidesDetail: Bool
  
  var doctor: String {
    appointment.doctor
  }
  
  var dateString: String {
    AppointmentPreviewView.dateFormatter.string(from: appointment.time)
  }
  
  var timeString: String {
    AppointmentPreviewView.timeFormatter.string(from: appointment.time)
  }
  
  var occursInThePast: Bool {
    Date() > appointment.time
  }
  
  var body: some View {
    VStack {
      topView
        .padding(.bottom, 1)
      bottomView
    }
    .padding()
    .background(.white)
    .cornerRadius(8)
  }
  
  var topView: some View {
    HStack {
      circularImage
      titleAndSubtitleView
        .padding(.leading)
      Spacer()
      if !hidesDetail {
        detailsView
      }
    }
    .frame(height: 60)
  }
  
  var bottomView: some View {
    VStack {
      if occursInThePast {
        Text("This appointment occures in the post.")
          .font(.caption)
          .padding(.bottom, 1)
      }
      HStack {
        IconLabelView(systemName: "calendar", label: dateString)
        Spacer()
        IconLabelView(systemName: "clock", label: timeString)
      }
    }
    .frame(height: 60)
  }
  
  var circularImage: some View {
    Image(uiImage: appointment.photo)
      .resizable()
      .scaledToFit()
      .frame(width: 60, height: 60, alignment: .center)
      .background(.white)
      .clipShape(Circle())
  }
  
  var procedure: String {
    appointment.procedure.isEmpty ? "Surgery" : appointment.procedure
  }
  
  var titleAndSubtitleView: some View {
    VStack {
      Text(doctor)
        .font(.subheadline)
      Text(procedure)
        .font(.headline)
    }
  }
  
  var detailsView: some View {
    Text("Details")
      .font(.headline)
      .foregroundColor(.white)
      .padding(8)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .foregroundColor(.accentColor)
      )
  }
}

private struct IconLabelView: View {
  let systemName: String
  let label: String
  
  var body: some View {
    HStack {
      Image(systemName: systemName)
      Text(label)
    }
  }
}
