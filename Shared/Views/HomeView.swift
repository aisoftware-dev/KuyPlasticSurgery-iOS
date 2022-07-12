import SwiftUI

struct HomeView: View {
  @StateObject var viewModel: HomeViewModel = .init()
    
  @State var selectedAppoinment: Appointment? = nil
  @State var isShowingSelectedAppoinment: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        appointmentView
          .padding()
        ButtonView(title: "Book An Appointment", onSelect: {
          env.navigator.go(to: .bookAppointment)
        })
          .padding()
          .toolbar {
            ToolbarItem(
              id: "system",
              placement: .navigationBarTrailing,
              showsByDefault: true) {
                Image(systemName: "gearshape.fill")
                  .foregroundColor(.white)
                  .onTapGesture {
                    env.navigator.go(to: .preferences)
                  }
              }
          }
      }
      .background(Color.blue)
      .navigationTitle(Text("Key Plastic Surgery"))
    }
  }
  
  var appointmentView: some View {
    ScrollView {
      VStack {
        ForEach(viewModel.appointments, id: \.self) { appointment in
          AppointmentPreviewView(appointment: appointment, hidesDetail: false)
            .onTapGesture {
              env.navigator.go(to: .appointment(appointment))
            }
        }
      }
    }
  }
  
  init(viewModel: HomeViewModel = .init()) {    
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
  }
}

//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    HomeView(viewModel: .init(isLoading: false))
//  }
//}
