import Foundation

class ConfirmAppointmentViewModel: ObservableObject {
  let appointment: Appointment
  let appointmentSlot: AppointmentSlot
  let appointmentType: AppointmentType
  
  var objectWillChange = ObjectWillChangePublisher()
  
  private var confirmedAppointments = Set<Appointment>()
  private var appoinmentsLoading = Set<Appointment>()
  
  func isConfirmed(for appointment: Appointment) -> Bool {
    return confirmedAppointments.contains(appointment)
  }
  
  func isLoading(for appointment: Appointment) -> Bool {
    return appoinmentsLoading.contains(appointment)
  }
  
  func confirm(appointment: Appointment) {
    guard isLoading(for: appointment) == false else { return }
    appoinmentsLoading.insert(appointment)
    
    objectWillChange.send()
    
    env.network.confirm(appointment: appointment, type: appointmentType) { [weak self] error in
      guard let self = self else { return }
      
      if error == nil {
        self.confirmedAppointments.insert(appointment)
      }
      self.appoinmentsLoading.remove(appointment)
    }
  }
  
  init(appointmentType: AppointmentType, slot: AppointmentSlot) {
    self.appointmentType = appointmentType
    self.appointmentSlot = slot
    self.appointment = Appointment(
      active: slot.active,
      appointmentStatus: slot.slotStatus,
      appointmentType: appointmentType.name,
      appointmentTypeCode: String(appointmentType.appointmentTypeId),
      createDate: nil,
      description: slot.scheduleDisplay,
      end: slot.end,
      id: slot.id,
      locationId: slot.locationId,
      locationName: nil,
      minutesDuration: Int(slot.minutesDuration ?? ""),
      patientId: nil,
      practitionerId: slot.practitionerId,
      practitionerName: slot.practitionerName,
      start: slot.start
    )
  }
}
