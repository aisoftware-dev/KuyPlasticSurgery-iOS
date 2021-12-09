import SwiftUI

struct LoginView: View {
  @State var username: String = ""
  @State var password: String = ""
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 20)
      BrandView()
      Spacer()
        .frame(height: 120)
      LoginTextField(placeholder: "Username", imageName: "person", value: $username)
        .padding([.leading, .trailing, .bottom])
      LoginTextField(placeholder: "Password", imageName: "lock", value: $password)
        .padding([.leading, .trailing, .bottom])
      LoginButton(title: "LOGIN")
        .padding([.leading, .trailing])
      ResetPasswordButton()
        .padding([.leading, .trailing])
      Spacer()
      Spacer()
    }
    .background(.blue)
  }
}

struct LoginTextField: View {
  let placeholder: String
  let imageName: String
  
  @Binding var value: String
  
  var body: some View {
    HStack {
      TextField.init(placeholder, text: $value, prompt: nil)
      Spacer()
      Image(systemName: imageName)
    }
    .padding()
    .background(.white)
    .cornerRadius(8)
  }
}

struct LoginButton: View {
  let title: String
  
  var body: some View {
    HStack {
      Spacer()
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.accentColor)
    .cornerRadius(8)
  }
}

struct ResetPasswordButton: View {
  var body: some View {
    HStack {
      Spacer()
      Text("Forgot Password?")
        .foregroundColor(.accentColor)
      Spacer()
    }
    .padding()
  }
}

extension Color {
  static var lightBlue: Color {
    .init(red: 0, green: 204/255, blue: 1)
  }
}
// 0, 204, 255

#if DEBUG
struct LoginView_Preview: PreviewProvider {
  static var previews: some View {
    LoginView()
      .accentColor(.lightBlue)
  }
}
#endif
