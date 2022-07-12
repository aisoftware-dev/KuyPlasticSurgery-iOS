import Foundation

struct AppointmentMeta: Codable {
  let locations: [Location]?
  let practitioners: [Practitioner]?
  let mindbodyvaluesets: MindbodyValueSet?
  let modmedvaluesets: ModmedValueSet?
  
  var appointmentTypes: [AppointmentType] {
    let one: [AppointmentType] = modmedvaluesets?.appointmentTypes.compactMap {
      guard let codeString = $0.code, let code = Int(codeString), let name = $0.display else { return nil }
      return AppointmentType(appointmentId: code, appointmentTypeId: 1, name: name, system: $0.system)
    } ?? []
    
    let two: [AppointmentType] = mindbodyvaluesets?.appointmentTypes?.compactMap {
      guard let id = $0.id, let name = $0.name else { return nil }
      return AppointmentType(appointmentId: id, appointmentTypeId: 2, name: name, system: nil)
    } ?? []
    
    return one + two
  }
}

struct Location: Codable {
  let accessToken: String?
  let active: Bool
  let address: String?
  let city: String?
  let id: Int?
  let locationDisplay: String?
  let name: String?
  let state: String?
  let zip: String?
}

struct Practitioner: Codable {
  let accessToken: String?
  let active: Bool
  let firstName: String?
  let lastName: String?
  let id: Int?
  let practitionerDisplay: String?
}

struct AppointmentCancellation: Codable {
  let code: String?
  let display: String?
  let system: String?
}

struct AppointmentTypeOne: Codable {
  let code: String?
  let display: String?
  let system: String?
}

struct ReportableReason: Codable {
  let code: String?
  let display: String?
  let system: String?
}

struct MindbodyValueSet: Codable {
  let appointmentTypes: [AppointmentTypeTwo]?
}

struct ModmedValueSet: Codable {
  let active: Bool
  let appointmentCancellations: [AppointmentCancellation]?
  let appointmentTypes: [AppointmentTypeOne]
  let id: Int?
  let reportableReasons: [ReportableReason]?
}

struct AppointmentTypeTwo: Codable {
  //let category: Any?
  let id: Int?
  let name: String?
  let numDeducted: Int?
  let programId: Int?
  let type: String?
}

//@JsonClass(generateAdapter = true)
//data class AppointmentTypeType2(
//    @Json(name = "Category")
//    val category: Any? = null,
//    @Json(name = "CategoryId")
//    val categoryId: Any? = null,
//    @Json(name = "DefaultTimeLength")
//    val defaultTimeLength: Any? = null,
//    @Json(name = "Id")
//    val id: Int? = null,
//    @Json(name = "Name")
//    val name: String? = null,
//    @Json(name = "NumDeducted")
//    val numDeducted: Int? = null,
//    @Json(name = "ProgramId")
//    val programId: Int? = null,
//    @Json(name = "StaffTimeLength")
//    val staffTimeLength: Any? = null,
//    @Json(name = "Subcategory")
//    val subcategory: Any? = null,
//    @Json(name = "SubcategoryId")
//    val subcategoryId: Any? = null,
//    @Json(name = "Type")
//    val type: String? = null
//): Serializable
//

struct AppointmentType: Codable, Identifiable, Hashable {
  let appointmentId: Int
  let appointmentTypeId: Int
  let name: String
  let system: String?
  
  var id: String {
    name
  }
  
  static func ==(lhs: AppointmentType, rhs: AppointmentType) -> Bool {
    lhs.name == rhs.name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}
