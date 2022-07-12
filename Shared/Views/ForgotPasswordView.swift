import SwiftUI

struct ForgotPasswordView: View {
  let viewModel = ForgotPasswordViewModel()
  @State var email: String = ""
  
  var body: some View {
    vStack
      .background(
        Rectangle()
          .foregroundColor(.accentColor)
      )
      .ignoresSafeArea()
  }
  
  var vStack: some View {
    VStack {
      Spacer()
        .frame(height: 100)
      Text("You will be emailed directions on how to reset your password.")
        .foregroundColor(.white)
        .font(.subheadline)
        .padding(.bottom)
      InputView(initialText: "Enter Email", text: $email) {
        viewModel.submit(email: email)
        env.navigator.go(to: .dismiss)
      }
      Spacer()
    }
    .padding()
  }
}
