import Foundation
import UIKit

struct AppointmentSlot: Codable {
  let accessToken: String?
  let active: Bool
  let appointmentTypeId: String
  let end: String?
  let id: Int?
  let locationId: String?
  let minutesDuration: String?
  let practitionerId: String?
  let scheduleDisplay: String?
  let slotDisplay: String?
  let slotStatus: String?
  let start: String?
  let practitionerName: String?
}

extension AppointmentSlot {
  var startTime: Date {
    Appointment.formatter.date(from: start ?? "") ?? Date()
  }
  
  var doctor: String {
    guard
      let meta = env.meta.meta,
      let id = practitionerId,
      let metaPractioner = meta.practitioners?.first(where: { $0.id == Int(id) })
    else {
      return practitionerName ?? ""
    }
    
    return (metaPractioner.firstName ?? "") + " " + (metaPractioner.lastName ?? "")
  }
  
  var photo: UIImage {
    guard
      let meta = env.meta.meta,
      let id = practitionerId
    else {
      return UIImage(named: "kuy")!
    }
    
    func image(for id: String) -> UIImage? {
      switch id {
      case "12340243": return UIImage(named: "ashleigh")
      case "14862685": return UIImage(named: "lindsay")
      case "13351571": return UIImage(named: "kendra")
      case "11462472": return UIImage(named: "jessica")
      case "13446253": return UIImage(named: "leah")
      default: return nil
      }
    }
    
    return image(for: id) ?? UIImage(named: "kuy")!
  }
}



extension AppointmentSlot: Equatable, Hashable {
  static func ==(lhs: AppointmentSlot, rhs: AppointmentSlot) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id ?? 0)
  }
}

