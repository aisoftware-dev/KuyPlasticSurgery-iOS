import Foundation
import UIKit

struct Appointment: Identifiable, Hashable {
  static func == (lhs: Appointment, rhs: Appointment) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  let id = UUID()
  let time: Date
  let image: Image
  let procedure: String
  let doctor: String

  let creationDate: Date
  let duration: TimeInterval

}

struct Address {
  let name: String
  let streetName: String
  let city: String
  let state: String

}

extension Appointment {
  public enum Image {
    case url(URL)
    case image(UIImage)
  }
}
