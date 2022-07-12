import Combine
import Foundation
import UIKit

class HomeViewModel: ObservableObject {
  let objectWillChange = ObjectWillChangePublisher()
  
  private(set) var isLoading: Bool
  private(set) var appointments: [Appointment] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  init(isLoading: Bool = true) {
    self.isLoading = isLoading
    
    load()
    
    env.confirmedAppointments
      .receive(on: DispatchQueue.main)
      .sink { [weak self] appointment in
        self?.appointments.insert(appointment, at: 0)
      }
      .store(in: &cancellables)
    
    env.cancelledApoinments
      .receive(on: DispatchQueue.main)
      .sink { [weak self] appointment in
        self?.appointments.removeAll(where: { $0 == appointment })
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
    
    env.meta.$meta
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.appointments = self?.appointments ?? []
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }
  
  func load() {
    let completion: (Result<Appointments, Error>) -> Void = { [weak self] result in
      switch result {
      case .success(let appointments):
        self?.appointments = appointments.appointments.sorted(by: { one, two in
          one.time > two.time
        })
      case .failure:
        // TODO: Add error handling
        return
      }
      self?.isLoading = false
      self?.objectWillChange.send()
    }
    env.network.appointments(completion: completion)//service.loadAppointments(completion)
    env.meta.fetch()
  }
}

//struct HomeService {
//  typealias Completion = (@escaping (Result<[Appointment], Error>) -> Void) -> Void
//  let loadAppointments: Completion
//}
//
//extension HomeService {
//  static var mocked: Self {
//    .init { completion in
//      env.network.appointments { <#Result<[Appointment], Error>#> in
//        <#code#>
//      }
//    }
//  }
//
//  static var instant: Self {
//    .init { completion in
//      //completion(.success(Appointment.mocked))
//    }
//  }
//}

//fileprivate extension Appointment {
//  static var mocked: [Appointment] {
//    let calendar = Calendar.current
//    let currentComponents = calendar.dateComponents([.day, .month, .year], from: Date())
//    let currentDay = currentComponents.day!
//    let currentMonth = currentComponents.month!
//    let currentYear = currentComponents.year!
//
//    /// (Hour, Minute)
//    let times: [(Int, Int)] = [
//      (9, 30),
//      (12, 0),
//      (14, 30)
//    ]
//
//    let offsets: [Int] = [
//      -1,
//       0,
//       1
//    ]
//
//    let dates: [Date] = offsets
//      .map { dayOffset -> [DateComponents] in
//        return times.map { values -> DateComponents in
//          var component = DateComponents()
//          component.year = currentYear
//          component.month = currentMonth
//          component.day = currentDay + dayOffset
//          component.hour = values.0
//          component.minute = values.1
//          return component
//        }
//      }
//      .reduce([], +)
//      .map {
//        calendar.date(from: $0)!
//      }
//
//    let creationDate: Date = {
//      var components = DateComponents()
//      components.year = currentYear
//      components.month = currentMonth
//      components.day = currentDay - 2
//      components.hour = 3
//      components.minute = 21
//      return calendar.date(from: components)!
//    }()
//
//    return dates.map { date -> Appointment in
//      Appointment(
//        time: date,
//        image: .image(UIImage()),
//        procedure: "Surgery",
//        doctor: "Daniel Cane",
//        creationDate: creationDate,
//        duration: 10
//      )
//    }
//  }
//}

