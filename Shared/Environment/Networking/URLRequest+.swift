import Foundation

extension URLRequest {
  static func authenticate(username: String, password: String) -> Self {
    POST(
      url: .authenticate,
      headers: ["username": username, "password": password],
      bodyParameters: [:]
    )
  }
  
  static func passwordReset(guid: String, newPassword: String) -> Self {
    POST(
      url: .forgotPassword,
      headers: ["guid": guid, "newPassword": newPassword],
      bodyParameters: [:]
    )
  }
  
  static func forgotPassword(email: String) -> Self {
    POST(url: .forgotPassword, headers: ["email": email], bodyParameters: [:])
  }
  
  static func submitPreferences(
    guid: String,
    receiveTextNotifications: Bool,
    receiveEmailNotifications: Bool,
    email: String
  ) -> Self {
    POST(url: .submitUserPreferences, headers: ["guid": guid], bodyParameters: [
      "receiveTextNotifications": "\(receiveTextNotifications)",
      "receiveEmailNotifications": "\(receiveEmailNotifications)",
      "email": email
    ])
  }
  
  static func appointmentMetaData(guid: String, tokenOne: String, tokenTwo: String) -> Self {
    POST(
      url: .appointmentMeta,
      headers: ["accessTokenType1": tokenOne, "accessTokenType2": tokenTwo, "guid": guid],
      bodyParameters: [:]
    )
  }

  static func appointmentSlots(tokenOne: String, tokenTwo: String, appointmentId: Int, appointmentTypeId: Int) -> Self {
    POST(
      url: .appointmentSlot,
      headers: ["accessTokenType1": tokenOne, "accessTokenType2": tokenTwo, "appointmentId": "\(appointmentId)", "appointmentTypeId": "\(appointmentTypeId)"],
      bodyParameters: [:]
    )
  }
  
  static func appointments(guid: String, tokenOne: String, tokenTwo: String) -> Self {
    POST(
      url: .patientAppointments,
      headers: ["guid": guid, "accessTokenType1": tokenOne, "accessTokenType2": tokenTwo],
      bodyParameters: [:]
    )
  }

  static func cancelAppointmentTypeOne(guid: String, tokenOne: String, appointmentId: Int) -> Self {
    POST(
      url: .cancelAppointmentTypeOne,
      headers: ["guid": guid, "accessTokenType1": tokenOne, "appointmentId": "\(appointmentId)"],
      bodyParameters: [:]
    )
  }
  
  static func cancelAppointmentTypeTwo(guid: String, tokenTwo: String, appointmentId: Int) -> Self {
    POST(
      url: .cancelAppointmentTypeOne,
      headers: ["guid": guid, "accessTokenType2": tokenTwo, "appointmentId": "\(appointmentId)"],
      bodyParameters: [:]
    )
  }
  
  struct TokenOneAppointmentRequest: Codable {
    struct Values: Codable {
      let appointmentStatus: String
      let appointmentTypeCode: String
      let appointmentTypeDisplay: String
      let appointmentTypeSystem: String
      let end: String
      let locationDisplay: String
      let locationReference: String
      let minutesDuration: Int
      let patientId: Int
      let practitionerDisplay: String
      let practitionerReference: String
      let resourceType: String
      let start: String
    }
    
    let createAppointmentData: Values
    
    var toString: String {
      let jsonEncoder = JSONEncoder()
      let data = try? jsonEncoder.encode(self)
      return data.map { String(data: $0, encoding: .utf8) ?? "" } ?? ""
    }
  }
  
  struct TokenTwoAppointmentRequest: Codable {
    struct Data: Codable {
      let locationId: Int
      let patientId: String
      let practitionerId: Int
      let sessionTypeId: Int
      let start: String
    }
    
    let createAppointment: Data
    
    var toString: String {
      let jsonEncoder = JSONEncoder()
      let data = try? jsonEncoder.encode(self)
      return data.map { String(data: $0, encoding: .utf8) ?? "" } ?? ""
    }
  }
  
  static func createAppointmentRequestTokenOne(
    guid: String,
    tokenOne: String,
    appointmentRequest: TokenOneAppointmentRequest
  ) -> Self {
    POST(
      url: .submitAppointmentTypeOne,
      headers: ["guid": guid, "accessTokenType1": tokenOne],
      bodyParameters: ["appointment": appointmentRequest.toString]
    )
  }
  
  static func createAppointmentRequestTokenTwo(
    guid: String,
    tokenTwo: String,
    appointmentRequest: TokenTwoAppointmentRequest
  ) -> Self {
    POST(
      url: .submitAppointmentTypeOne,
      headers: ["guid": guid, "accessTokenType2": tokenTwo],
      bodyParameters: ["appointment": appointmentRequest.toString]
    )
  }
}

// MARK: Helpers

extension URLRequest {
  static func POST(
    url: URL,
    headers: [String: String],
    bodyParameters: [String: String]
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
    request.encodeParameters(parameters: bodyParameters)
    return request
  }
  
  static func base(url: URL) -> Self {
    return URLRequest(url: url)
  }
  
  private func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")
    
    return string
      .addingPercentEncoding(withAllowedCharacters: characterSet)!
      .replacingOccurrences(of: " ", with: "+")
      .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
  }
  
  mutating func encodeParameters(parameters: [String : String]) {
    httpMethod = "POST"
    
    let parameterArray = parameters.map { (arg) -> String in
      let (key, value) = arg
      return "\(key)=\(self.percentEscapeString(value))"
    }
    
    httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
  }
}
