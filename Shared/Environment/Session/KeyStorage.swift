import Foundation

protocol KeyStorage {
  func save(value: String, key: String)
  func save(value: Int, key: String)
  func save(value: Bool, key: String)
  func retrieve(key: String) -> String?
  func retrieve(key: String) -> Int?
  func retrieve(key: String) -> Bool?
}
