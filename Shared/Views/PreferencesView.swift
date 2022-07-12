import SwiftUI

struct PreferencesView: View {
  let viewModel: PreferencesViewModel
  
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
      ToggleView(toggle: textBinding, systemName: "ellipsis.bubble", title: "Text Notifications")
      ToggleView(toggle: emailBinding, systemName: "envelope", title: "Email Notifications")
      InputView(initialText: emailValueBinding.wrappedValue, text: emailValueBinding) {
        viewModel.didUpdateBuffer.send()
      }
      Spacer()
    }
    .padding()
  }
  
  let emailValueBinding: Binding<String>
  let emailBinding: Binding<Bool>
  let textBinding: Binding<Bool>
  
  
  init() {
    let viewModel = PreferencesViewModel.shared
    self.viewModel = viewModel
    self.emailValueBinding = .init(get: { [unowned viewModel] in
      viewModel.email
    }, set: { [unowned viewModel] value in
      viewModel.email = value
    })
    self.emailBinding = .init { [unowned viewModel] in
      viewModel.isEmailNotificationsEnabled
    } set: { [unowned viewModel] value in
      viewModel.isEmailNotificationsEnabled = value
    }
    self.textBinding = .init(get: { [unowned viewModel] in
      viewModel.isTextNotificationsEnabled
    }, set: { value in
      viewModel.isTextNotificationsEnabled = value
    })
  }

}

struct InputView: View {
  let initialText: String
  @Binding var text: String
  let onSubmit: () -> Void
  
  var body: some View {
    HStack {
      Image(systemName: "arrow.forward.square")
        .foregroundColor(.secondary)
        .padding(.trailing)
      TextField(initialText, text: $text)
        .onSubmit {
          onSubmit()
        }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .foregroundColor(.white)
    )
  }
}

struct ToggleView: View {
  @Binding var toggle: Bool
  let systemName: String
  let title: String
  
  var body: some View {
    HStack {
      Image(systemName: systemName)
        .foregroundColor(.secondary)
        .padding(.trailing)
      Toggle(title, isOn: $toggle)
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .foregroundColor(.white)
    )
  }
}
