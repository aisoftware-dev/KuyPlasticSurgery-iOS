import Foundation

class ForgotPasswordViewModel {
  func submit(email: String) {
    env.network.forgotPassword(email: email) { _ in }
  }
}

