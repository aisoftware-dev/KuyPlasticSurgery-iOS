import Foundation

struct Alert {
  let message: String
}

extension Alert {
  static let unableToCancel: Alert = Alert(message: "Cancellation cannot be performed less than 24 hours prior to the scheduled appointment. Please call the office at (844)794-7736 to cancel.")
}
