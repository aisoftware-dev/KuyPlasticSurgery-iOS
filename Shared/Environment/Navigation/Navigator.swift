import Foundation
import UIKit

class Navigator {
  weak var controller: UIViewController? = nil
  
  var topController: UIViewController? {
    var topController = controller
    while let presentedController = topController?.presentedViewController {
      topController = presentedController
    }
    return topController
  }
  
  var navigationController: UINavigationController? {
    topController as? UINavigationController
  }
  
  func go(to destination: Destination) {
    switch destination {
    case .dismiss:
      topController?.dismiss(animated: true, completion: nil)
      
    case .alert(let alert):
      let controller = UIAlertController(title: nil, message: alert.message, preferredStyle: .alert)
      controller.addAction(.init(title: "Ok", style: .default, handler: { _ in controller.dismiss(animated: true, completion: nil)}))
      topController?.present(controller, animated: true, completion: nil)
      
    case .appointment(let appointment):
      let view = AppointmentView(appointment: appointment)
      let controller = ContentViewController(view: view)
      topController?.present(controller, animated: true, completion: nil)
      
    case .confirmAppointment(let type, let slot):
      let view = ConfirmAppointmentView(viewModel: .init(appointmentType: type, slot: slot))
      let controller = ContentViewController(view: view)
      controller.title = "Confirm"
      navigationController?.pushViewController(controller, animated: true)
      
    case .bookAppointment:
      let view = SelectProcedureView(viewModel: .init())
      let controller = ContentViewController(view: view)
      //controller.title = "Select Procedures"
      let navigationController = UINavigationController(rootViewController: controller)
      //navigationController.navigationBar.prefersLargeTitles = true
      topController?.present(navigationController, animated: true, completion: nil)
      
    case .forgotPassword:
      let view = ForgotPasswordView()
      let controller = ContentViewController(view: view)
      controller.title = "Forgot Password"
      let navigationController = UINavigationController(rootViewController: controller)
      navigationController.navigationBar.prefersLargeTitles = true
      topController?.present(navigationController, animated: true, completion: nil)
      
    case .preferences:
      let view = PreferencesView()
      let controller = ContentViewController(view: view)
      controller.title = "Preferences"
      let navigationController = UINavigationController(rootViewController: controller)
      navigationController.navigationBar.prefersLargeTitles = true
      topController?.present(navigationController, animated: true, completion: nil)
      
    case .schedule(let appointmentType):
      let view = ScheduleView(viewModel: .init(procedure: appointmentType))
      let controller = ContentViewController(view: view)
      controller.title = "Select Slot"
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
