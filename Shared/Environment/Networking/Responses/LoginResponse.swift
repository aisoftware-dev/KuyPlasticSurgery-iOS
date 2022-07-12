import Foundation

struct LoginResponse: Codable {
  struct Authentication: Codable {
    let guid: String
    let receiveEmailNotification: Bool
    let receiveTextNotification: Bool
    let email: String
    let session: [Session]
  }
  
  let authentication: Authentication
}
