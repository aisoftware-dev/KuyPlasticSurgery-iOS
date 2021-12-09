import SwiftUI

struct SelectProcedureView: View {
  let procedures: [String] = [
    "Surgery",
    "New Patient",
    "Follow-up",
    "Yoga",
    "Pilates",
    "Aerobics"
  ]
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        scrollView
          .padding(.top)
          .background(.blue)
      }
      .accentColor(.lightBlue)
      .navigationTitle(
        Text("Select a Procedure")
          .foregroundColor(.white)
      )
    }
  }
  
  var scrollView: some View {
    ScrollView {
      VStack {
        ForEach(procedures, id: \.self) { procedure in
          ItemView(name: procedure)
            .padding([.leading, .trailing, .bottom])
        }
        BrandView()
          .padding([.top])
      }
    }
  }
}

fileprivate struct ItemView: View {
  let name: String
  
  var body: some View {
    HStack {
      imageView
        .padding(.leading)
      Spacer()
      Text(name)
        .foregroundColor(.gray)
        .font(.headline)
      Spacer()
      Spacer()
      Image(systemName: "chevron.right")
        .renderingMode(.template)
        .foregroundColor(.gray)
        .padding(.trailing)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(.white)
    )
  }
  
  var imageView: some View {
    Image.init(systemName: "person")
      .renderingMode(.template)
      .foregroundColor(.lightBlue)
      .frame(width: 60, height: 60, alignment: .center)
      .background(.white)
      .clipShape(Circle())
  }
}

#if DEBUG
struct SelectProcedureView_Preview: PreviewProvider {
  static var previews: some View {
    SelectProcedureView()
  }
}
#endif
