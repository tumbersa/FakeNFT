import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = createNavigation(with: L10n.Tab.catalog,
                                                 and: UIImage(systemName: "square.stack.3d.up.fill"),
                                                 vc: TestCatalogViewController(servicesAssembly: servicesAssembly))

        let statisticsController = createStatisticsVC()
        
        self.setViewControllers([catalogController, statisticsController], animated: true)

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
        let assembly = StatisticsAssembly(networkClient: DefaultNetworkClient())
        let statisticsInput = MockDataStatistics.ids
        let statisticsViewController = assembly.build(with: statisticsInput)
        let statisticsController = UINavigationController(rootViewController: statisticsViewController)
        statisticsController.title = L10n.TabBar.statisticTabBarTitle
        statisticsController.tabBarItem.image = UIImage(systemName: "flag.2.crossed.fill")
        
        return statisticsController
    }
}
