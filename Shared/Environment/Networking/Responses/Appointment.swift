import Foundation
import UIKit
import SwiftUI

struct Appointment: Codable {
  var active: Bool
  var appointmentStatus: String?
  let appointmentType: String?
  let appointmentTypeCode: String?
  let createDate: String?
  let description: String?
  let end: String?
  let id: Int?
  let locationId: String?
  let locationName: String?
  let minutesDuration: Int?
  let patientId: String?
  let practitionerId: String?
  let practitionerName: String?
  // let session: [Session]
  let start: String?
}

extension Appointment: Equatable, Hashable {
  static func ==(lhs: Appointment, rhs: Appointment) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id ?? 0)
  }
}


extension Appointment {
  static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }()
  
  var time: Date {
    start.map { Self.formatter.date(from: $0) ?? Date() } ?? Date()
  }
  
  var durationMinutes: Int {
    let start = Self.formatter.date(from: self.start ?? "") ?? Date()
    let end = Self.formatter.date(from: self.end ?? "") ?? Date()
    
    let startComponents = Calendar.current.dateComponents([.hour, .minute], from: start)
    let endComponents = Calendar.current.dateComponents([.hour, .minute], from: end)

    return Calendar.current.dateComponents([.minute], from: startComponents, to: endComponents).minute ?? 0
  }
  
  var createdDate: Date {
    createDate.map { Self.formatter.date(from: $0) ?? Date() } ?? Date()
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
  
  var practioner: Practitioner? {
    guard
      let meta = env.meta.meta,
      let id = practitionerId,
      let metaPractioner = meta.practitioners?.first(where: { $0.id == Int(id) })
    else {
      return nil
    }
    return metaPractioner
  }
  
  var location: Location? {
    guard let meta = env.meta.meta, let id = Int(locationId ?? "") else { return nil }
    let allLocations = meta.locations ?? []
    return allLocations.first(where: { $0.id == id })
  }
  
  var procedure: String {
    appointmentType ?? ""
  }
  
  // nil means it can't find a type
  var isTypeOne: Bool? {
    let types = env.meta.meta?.appointmentTypes ?? []
    guard let id = types.first(where: { $0.appointmentTypeId == $0.appointmentTypeId })?.appointmentId else { return nil }
    return id == 1
  }
  
  var photo: UIImage {
    guard
      let meta = env.meta.meta,
      let id = practitionerId,
      let firstName = meta.practitioners?.first(where: { $0.id == Int(id) })?.firstName
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
