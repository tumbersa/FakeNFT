import UIKit

enum ControllersType {
    case catalogViewController
}

final class TabBarController: UITabBarController {

    var controllersFactory: ControllersFactory

    init(controllersFactory: ControllersFactory) {
        self.controllersFactory = controllersFactory
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogNavigationItem = controllersFactory.setupController(of: ControllersType.catalogViewController)
        
        self.setViewControllers([catalogNavigationItem], animated: true)

        view.backgroundColor = .systemBackground
    }
}
