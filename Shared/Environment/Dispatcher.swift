import Foundation

struct Dispatcher {
  typealias Completion = () -> Void
  let _perform: (@escaping Completion) -> Void
  
  func perform(_ completion: @escaping Completion) {
    _perform(completion)
  }
}

extension Dispatcher {
  static var mock: Dispatcher {
    .init { completion in
      DispatchQueue.main.asyncAfter(deadline: .random) {
        completion()
      }
    }
  }
  
  static var live: Dispatcher {
    .init { completion in
      completion()
    }
  }
}

fileprivate extension DispatchTime {
  static var random: DispatchTime {
    .now() + .seconds(.random(in: 1..<3))
  }
}
