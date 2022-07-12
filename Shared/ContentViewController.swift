import UIKit
import SwiftUI

class ContentViewController: UIViewController {
  let controller: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(controller)
    
    guard let childView = controller.view else { return }
    childView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(childView)
    
    NSLayoutConstraint.activate([
      childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      childView.topAnchor.constraint(equalTo: view.topAnchor),
      childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    controller.didMove(toParent: self)
  }
  
  init(controller: UIViewController) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
  }
  
  init<T: View>(view: T) {
    self.controller = UIHostingController<T>(rootView: view)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct ContentViewRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = ContentViewController
  
  func makeUIViewController(context: Context) -> ContentViewController {
    let controller = ContentViewController(view: ContentView())
    env.navigator.controller = controller
    return controller
  }
  
  func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {}
}
 
