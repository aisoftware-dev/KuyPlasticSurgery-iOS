import Foundation

enum NetworkError: Error {
  case invalidResponse
  case missingData
}

struct Network {
  let urlSession: URLSession
  let sessionStore: SessionStore
  let decoder: JSONDecoder = JSONDecoder()
  
  func onMainThread(_ closure: @escaping () -> ()) {
    DispatchQueue.main.async {
      closure()
    }
  }
  
  func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
    let task = urlSession.dataTask(with: request) { data, response, networkError in
      guard let data = data else {
        onMainThread {
          completion(.failure(NetworkError.missingData))
        }
        return
      }
      
      do {
        let response = try decoder.decode(T.self, from: data)
        onMainThread {
          completion(.success(response))
        }
      } catch {
        onMainThread {
          completion(.failure(NetworkError.invalidResponse))
        }
      }
    }
    task.resume()
  }
  
  func perform(request: URLRequest, completion: @escaping (Error?) -> Void) {
    let task = urlSession.dataTask(with: request) { data, response, error in
      if let error = error {
        onMainThread {
          completion(error)
        }
        return
      }
      
      let error = (response as? HTTPURLResponse)?.statusCode == 200 ? nil : NetworkError.invalidResponse
      onMainThread {
        completion(error)
      }
    }
    task.resume()
  }
}

extension Network {
  func login(
    username: String,
    password: String,
    completion: @escaping (Result<LoginResponse, Error>) -> Void
  ) {
    perform(request: .authenticate(username: username, password: password), completion: completion)
  }
  
  func resetPassword(newPassword: String, completion: @escaping (Error?) -> Void) {
    perform(request: .passwordReset(guid: sessionStore.guid, newPassword: newPassword), completion: completion)
  }
  
  func forgotPassword(email: String, completion: @escaping (Error?) -> Void) {
    perform(request: .forgotPassword(email: email), completion: completion)
  }

  func submitPreferences(
    recieveTextNotifications: Bool,
    recieveEmailNotifications: Bool,
    email: String,
    completion: @escaping (Error?) -> Void
  ) {
    perform(
      request: .submitPreferences(
        guid: sessionStore.guid,
        receiveTextNotifications: recieveTextNotifications,
        receiveEmailNotifications: recieveEmailNotifications,
        email: email
      ),
      completion: completion
    )
  }

  func appointments(completion: @escaping (Result<Appointments, Error>) -> Void) {
    perform(
      request: .appointments(guid: sessionStore.guid, tokenOne: sessionStore.tokenOne, tokenTwo: sessionStore.tokenTwo),
      completion: completion
    )
  }
  
  func appointmentMeta(completion: @escaping (Result<AppointmentMeta, Error>) -> Void) {
    perform(
      request: .appointmentMetaData(guid: sessionStore.guid, tokenOne: sessionStore.tokenOne, tokenTwo: sessionStore.tokenTwo),
      completion: completion
    )
  }
  
  func appointmentSlots(appointmentType: AppointmentType, completion: @escaping (Result<AppointmentSlots, Error>) -> Void) {
    perform(
      request: .appointmentSlots(
        tokenOne: env.sessionStore.tokenOne,
        tokenTwo: env.sessionStore.tokenTwo,
        appointmentId: appointmentType.appointmentId,
        appointmentTypeId: appointmentType.appointmentTypeId
      ),
      completion: completion
    )
  }
  
  func cancel(appointment: Appointment, completion: @escaping (Error?) -> Void) {
    guard let isTypeOne = appointment.isTypeOne else { return }
    if isTypeOne {
      perform(request: .cancelAppointmentTypeOne(guid: env.sessionStore.guid, tokenOne: env.sessionStore.tokenOne, appointmentId: appointment.id ?? 0), completion: completion)
    } else {
      perform(request: .cancelAppointmentTypeTwo(guid: env.sessionStore.guid, tokenTwo: env.sessionStore.tokenTwo, appointmentId: appointment.id ?? 0), completion: completion)
    }
  }
  
  func confirm(appointment: Appointment, type: AppointmentType, completion: @escaping (Error?) -> Void) {
    guard let isTypeOne = appointment.isTypeOne else { return }
    if isTypeOne {

      let practioner = appointment.practioner
      let practionerDisplayParts = practioner?.practitionerDisplay?.split(separator: "/") ?? []

      let practionerReference: String
      if practionerDisplayParts.count >= 2 {
        practionerReference = "\(practionerDisplayParts[practionerDisplayParts.count - 2])/\(practionerDisplayParts.last ?? "")"
      } else {
        practionerReference = String(practionerDisplayParts.last ?? "")
      }

      let location = appointment.location
      let locationDisplayParts = location?.locationDisplay?.split(separator: "/") ?? []
      let locationReference: String
      if locationDisplayParts.count >= 2 {
        locationReference = "\(locationDisplayParts[locationDisplayParts.count - 2])/\(locationDisplayParts.last ?? "")"
      } else {
        locationReference = String(locationDisplayParts.last ?? "")
      }

      let request = URLRequest.TokenOneAppointmentRequest(createAppointmentData: URLRequest.TokenOneAppointmentRequest.Values(
        appointmentStatus: "pending",
        appointmentTypeCode: String(type.appointmentTypeId),
        appointmentTypeDisplay: type.name,
        appointmentTypeSystem: type.system ?? "",
        end: appointment.end ?? "",
        locationDisplay: location?.locationDisplay ?? "",
        locationReference: locationReference,
        minutesDuration: appointment.durationMinutes,
        patientId: env.sessionStore.patientIdOne,
        practitionerDisplay: practioner?.practitionerDisplay ?? "",
        practitionerReference: practionerReference,
        resourceType: "Appointment",
        start: appointment.start ?? "")
      )
      perform(
        request: .createAppointmentRequestTokenOne(
          guid: env.sessionStore.guid,
          tokenOne: env.sessionStore.tokenOne,
          appointmentRequest: request
        ),
        completion: completion
      )
    } else {

      let locationID = appointment.locationId ?? ""
      let practitionerID = appointment.practitionerId ?? ""

      let request = URLRequest.TokenTwoAppointmentRequest(createAppointment: URLRequest.TokenTwoAppointmentRequest.Data(
        locationId: Int(locationID) ?? 0,
        patientId: "\(env.sessionStore.patientIdTwo)",
        practitionerId: Int(practitionerID) ?? 0,
        sessionTypeId: Int(type.id) ?? 0,
        start: appointment.start ?? ""
      ))

      perform(request: .createAppointmentRequestTokenTwo(guid: env.sessionStore.guid, tokenTwo: env.sessionStore.tokenTwo, appointmentRequest: request), completion: completion)
    }
  }
}
