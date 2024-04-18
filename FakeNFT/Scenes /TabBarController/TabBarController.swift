import UIKit

final class TabBarController: UITabBarController {
    
    var controllersFactory: ControllersFactory
    
    init(controllersFactory: ControllersFactory, servicesAssembly: ServicesAssembly) {
        self.controllersFactory = controllersFactory
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var servicesAssembly: ServicesAssembly!
    
    private let cartTabBarItem = UITabBarItem(
        title: L10n.TabBar.cartTabBarTitle,
        image: UIImage(named: "Cart"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogNavigationItem = controllersFactory.setupController(of: ControllersType.catalogViewController)
    
        let statisticsController = createStatisticsVC()
        
        let cartViewController = UINavigationController(rootViewController: CartViewController(servicesAssembly: servicesAssembly))
        cartViewController.tabBarItem = cartTabBarItem
        
        self.setViewControllers([catalogNavigationItem, cartViewController, statisticsController], animated: true)
        view.backgroundColor = .systemBackground
    }

    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title

        return nav
    }
    
    private func createStatisticsVC() -> UIViewController {
        let navController = UINavigationController()
        let assemblyBuilder = StatisticsAssemblyBuilderImpl(networkClient: DefaultNetworkClient())
        let router = StatisticsRouterImpl(navigationController: navController, assemblyBuilder: assemblyBuilder)
        router.initialViewController()
        
        navController.title = L10n.TabBar.statisticTabBarTitle
        navController.tabBarItem.image = UIImage(systemName: "flag.2.crossed.fill")
        return navController
    }

}
