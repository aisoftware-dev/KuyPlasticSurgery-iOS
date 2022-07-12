import Foundation

enum Destination {
  case dismiss
  
  case alert(Alert)
  case appointment(Appointment)
  case confirmAppointment(AppointmentType, AppointmentSlot)
  case bookAppointment
  case forgotPassword
  case preferences
  case schedule(AppointmentType)
}
