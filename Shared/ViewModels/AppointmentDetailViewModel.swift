import Combine
import Foundation

class AppointmentDetailViewModel: ObservableObject {
  
  var appointment: Appointment
  
  init(appointment: Appointment) {
    self.appointment = appointment
  }
  
  func loadDetail() {
  }
}
