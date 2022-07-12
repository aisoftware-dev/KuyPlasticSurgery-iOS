import Foundation

struct Session: Codable {
  let accessToken: String
  let refreshToken: String
  let patientId: Int?
  let type: Int
}
