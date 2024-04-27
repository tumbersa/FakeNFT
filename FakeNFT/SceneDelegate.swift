import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let controllersFactory = ControllersFactory()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {

        guard let windowsScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowsScene)
        let tabBarController = controllersFactory.setupTabBarController()

        window.rootViewController = UserDefaults.standard.isOnBoarded ? tabBarController : OnBoardingController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
