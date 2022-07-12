import Combine
import Foundation

class SelectProcedureViewModel: ObservableObject {
  private(set) var procedures: [AppointmentType] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    env.meta.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadProcedures()
      }
      .store(in: &cancellables)
    
    loadProcedures()
  }
  
  func loadProcedures() {
    guard let meta = env.meta.meta else { return }
    self.procedures = meta.appointmentTypes
    self.objectWillChange.send()
  }
}
