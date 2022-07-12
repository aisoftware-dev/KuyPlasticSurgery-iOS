import SwiftUI

struct LoginView: View {
  @State var username: String = "" {
    didSet {
      viewModel.login(username: username, password: password)
    }
  }
  
  private var isLoggedIn: Binding<Bool> {
    Binding (
      get: { viewModel.isLoggedIn },
      set: { _ in }
    )
  }
  
  @State var password: String = "" {
    didSet {
      viewModel.login(username: username, password: password)
    }
  }
  
  @ObservedObject var viewModel = LoginViewModel()
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 20)
      BrandView()
      Spacer()
        .frame(height: 120)
      if viewModel.isLoading {
        ProgressView()
          .foregroundColor(.white)
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
      } else {
        enterInfoView
      }
      Spacer()
      Spacer()
    }
    .background(.blue)
    .fullScreenCover(isPresented: isLoggedIn, onDismiss: nil) {
      HomeView()
    }
  }
  
  var enterInfoView: some View {
    VStack {
      LoginTextField(placeholder: "Username", imageName: "person", value: $username, isSecure: false)
        .padding([.leading, .trailing, .bottom])
      LoginTextField(placeholder: "Password", imageName: "lock", value: $password, isSecure: true)
        .padding([.leading, .trailing, .bottom])
      LoginButton(title: "LOGIN")
        .padding([.leading, .trailing])
        .onTapGesture {
          viewModel.login(username: username, password: password)
        }
      ResetPasswordButton()
        .onTapGesture {
          env.navigator.go(to: .forgotPassword)
        }
        .padding([.leading, .trailing])
    }
  }
}

struct LoginTextField: View {
  let placeholder: String
  let imageName: String
  
  @Binding var value: String
  
  let isSecure: Bool
  
  var body: some View {
    HStack {
      if isSecure {
        SecureField.init(placeholder, text: $value, prompt: nil)
      } else {
        TextField.init(placeholder, text: $value, prompt: nil)
          .autocapitalization(.none)
      }
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

extension UIColor {
  static var lightBlue: UIColor {
    UIColor(displayP3Red: 0, green: 205/255, blue: 1, alpha: 1)
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
