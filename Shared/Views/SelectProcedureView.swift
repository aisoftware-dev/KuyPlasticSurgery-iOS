import SwiftUI

struct SelectProcedureView: View {
  @ObservedObject var viewModel: SelectProcedureViewModel
  
  var body: some View {
      VStack {
        Spacer()
        scrollView
          .padding(.top)
          .background(.blue)
      }
      .accentColor(.lightBlue)
      .background(Color.blue)
      .navigationBarBackButtonHidden(true)
      .navigationTitle("Select Procedure")
  }
  
  var scrollView: some View {
    ScrollView {
      VStack {
        ForEach(viewModel.procedures, id: \.self) { procedure in
          SecondItemView(name: procedure.name)
            .padding([.leading, .trailing, .bottom])
            .onTapGesture {
              env.navigator.go(to: .schedule(procedure))
            }
        }
        BrandView()
          .padding([.top])
      }
    }
  }
}

fileprivate struct SecondItemView: View {
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
    Image("Logo", bundle: .main)
      .resizable()
      .scaledToFill()
      .frame(width: 60, height: 60, alignment: .center)
      .background(.white)
      .clipShape(Circle())
  }
}

#if DEBUG
struct SelectProcedureView_Preview: PreviewProvider {
  static var previews: some View {
    SelectProcedureView(viewModel: .init())
  }
}
#endif
