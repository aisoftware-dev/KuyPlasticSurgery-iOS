import SwiftUI

@main
struct KeyPlasticSurgeryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewRepresentable()
            .ignoresSafeArea()
            .accentColor(Color.lightBlue)
            .colorScheme(.light)
        }
    }
  
  
}
