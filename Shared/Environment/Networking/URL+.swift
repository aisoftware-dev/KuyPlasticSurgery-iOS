import Foundation

extension URL {
  static var authenticate: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/Authenticate")
  }
  
  static var appointmentMeta: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/AppointmentMetaData")
  }

  static var patientAppointments: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/Appointments")
  }
  
  static var cancelAppointmentTypeOne: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/CancelAppointmentType1")
  }
  
  static var cancelAppointmentTypeTwo: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/CancelAppointmentType2")
  }
  
  static var appointmentSlot: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/AppointmentSlots")
  }
  
  static var submitAppointmentTypeOne: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/SubmitAppointmentType1")
  }
  
  static var submitAppointTypeTwo: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/SubmitAppointmentType2")
  }
  
  static var submitUserPreferences: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/UpdatePreferences")
  }

  static var passwordReset: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/ResetPassword")
  }
  
  static var forgotPassword: URL {
    baseURL.appendingPathComponent("Services/WebServices.asmx/ForgotPassword")
  }
    
  static var baseURL: URL {
    prodURL
  }
  
  static var sandBoxURL: URL {
    URL(string: "https://sandbox.kuyplasticsurgery.com/")!
  }
  
  static var prodURL: URL {
    URL(string: "https://app.drkuy.com/")!
  }
}
