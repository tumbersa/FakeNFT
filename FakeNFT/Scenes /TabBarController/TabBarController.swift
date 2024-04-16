import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
        title: L10n.TabBar.profileTabBarTitle,
        image: UIImage(named: "profile_tab_inactive"),
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
        configureTabBars()
    }

    private func configureTabBars() {
        let profileViewController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )

        let profileNavigationController = UINavigationController(
            rootViewController: profileViewController
        )

        profileViewController.tabBarItem = profileTabBarItem
        tabBar.unselectedItemTintColor = UIColor.black

        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController

        self.setViewControllers([profileNavigationController], animated: true)

        view.backgroundColor = .systemBackground
    }
}
