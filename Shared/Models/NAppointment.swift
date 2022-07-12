import Foundation
import UIKit

struct NAppointment: Identifiable, Hashable {
  static func == (lhs: NAppointment, rhs: NAppointment) -> Bool {
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

extension NAppointment {
  public enum Image {
    case url(URL)
    case image(UIImage)
  }
}
