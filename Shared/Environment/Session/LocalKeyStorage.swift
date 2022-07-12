import Foundation

struct LocalKeyStorage: KeyStorage {
  func save(value: String, key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func retrieve(key: String) -> String? {
    UserDefaults.standard.string(forKey: key)
  }
  
  func save(value: Int, key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func retrieve(key: String) -> Int? {
    UserDefaults.standard.integer(forKey: key)
  }
  
  func save(value: Bool, key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func retrieve(key: String) -> Bool? {
    UserDefaults.standard.bool(forKey: key)
  }
}
