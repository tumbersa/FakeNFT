import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataProvider = DataProvider(networkClient: DefaultNetworkClient())
        let catalogPresenter = CatalogPresenter(dataProvider: dataProvider)
        let catalogController = createNavigation(with: L10n.Tab.catalog,
                                                 and: UIImage(systemName: "rectangle.stack.fill"),
                                                 vc: CatalogViewController(presenter: catalogPresenter))

        self.setViewControllers([catalogController], animated: true)

        view.backgroundColor = .systemBackground
    }
    
    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
}
