import Foundation
import UIKit

class ScheduleViewModel: ObservableObject {
  let objectWillChange = ObjectWillChangePublisher()
  
  func isLoading(for date: Date) -> Bool {
    _isLoading
  }
  private var _isLoading: Bool = false
  
  func appointments(for date: Date) -> [AppointmentSlot] {
    _appointments[date] ?? []
  }
  private var _appointments: [Date: [AppointmentSlot]] = [:]
  private var slots: AppointmentSlots? = nil
  
  let procedure: AppointmentType
  
  var date = Date() {
    didSet {
      loadAvailableAppointments(date: date)
    }
  }
  
  init(procedure: AppointmentType) {
    self.procedure = procedure
    
    loadSlots()
  }
  
  func loadAvailableAppointments(date: Date) {
    let slots = slots?.appointmentSlots ?? []
    let filtered = slots.filter {
      $0.startTime.sameDay(as: date)
    }
    _appointments[date] = filtered
    objectWillChange.send()
  }
  
  func loadSlots() {
    _isLoading = true
    objectWillChange.send()
    
    env.network.appointmentSlots(appointmentType: procedure) { [weak self] result in
      switch result {
      case .success(let slots):
        self?.slots = slots
        self?._isLoading = false
        self?.loadAvailableAppointments(date: self?.date ?? Date())
      case .failure:
        self?._isLoading = false
        self?.objectWillChange.send()
      }
    }
  }
}

struct ScheduleViewModelService {
  typealias Completion = (Result<[Appointment], Error>) -> Void
  let perform: (AppointmentType, @escaping Completion) -> Void
}

fileprivate extension Date {
  static var tomorrow: Date {
    let calendar = Calendar.current
    var currentComponents = calendar.dateComponents([.day, .month, .year], from: Date())
    currentComponents.day = currentComponents.day! + 1
    return calendar.date(from: currentComponents) ?? Date()
  }
  
  func sameDay(as other: Date) -> Bool {
    let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
    let otherComponents = Calendar.current.dateComponents([.day, .month, .year], from: other)
    return components == otherComponents
  }
}
