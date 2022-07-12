import UIKit

struct Router {
  func route(to route: Route) {
    switch route {
    case .maps(let location):
      let values: [String?] = [
        location.address,
        location.state,
        location.zip
      ]
      let value = values.compactMap { $0 }.joined(separator: ",").replacingOccurrences(of: " ", with: "")
      guard let url = URL(string: "http://maps.apple.com/?address=\(value)") else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)

    case .phone:
      if let url = URL(string: "tel://\("8447947736")"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }
}
