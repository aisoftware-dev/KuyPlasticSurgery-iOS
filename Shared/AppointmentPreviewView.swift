import SwiftUI

struct AppointmentPreviewView: View {
  var body: some View {
    VStack {
      topView
        .padding(.bottom, 1)
      bottomView
    }
    .padding()
    .background(.white)
  }
  
  var topView: some View {
    HStack {
      circularImage
      titleAndSubtitleView
        .padding(.leading)
      Spacer()
      detailsView
    }
    .frame(height: 60)
  }
  
  var bottomView: some View {
    VStack {
      Text("This appointment occures in the post.")
        .font(.caption)
        .padding(.bottom, 1)
      HStack {
        IconLabelView(systemName: "calendar", label: "23 July 2021")
        Spacer()
        IconLabelView(systemName: "clock", label: "5:00 PM")
      }
    }
    .frame(height: 60)
  }
  
  var circularImage: some View {
    Image.init(systemName: "person")
      .frame(width: 60, height: 60, alignment: .center)
      .background(.blue)
      .clipShape(Circle())
  }
  
  var titleAndSubtitleView: some View {
    VStack {
      Text("Daniel Cane")
        .font(.subheadline)
      Text("Surgery")
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

#if DEBUG
struct AppointmentPreviewView_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      AppointmentPreviewView()
        .padding([.leading, .trailing])
      AppointmentPreviewView()
        .padding([.leading, .trailing])
      Spacer()
    }
    .background(.blue)
    .accentColor(.lightBlue)
  }
}
#endif
