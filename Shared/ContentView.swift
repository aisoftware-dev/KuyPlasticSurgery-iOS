import Combine
import SwiftUI

struct ContentView: View {
  @ObservedObject var session = env.sessionStore
  
  var hasLoogedIn: Bool {
    env.sessionStore.isAuthenticated
  }
  
  var body: some View {
    if hasLoogedIn {
      HomeView()
    } else {
      LoginView()
    }
  }
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

