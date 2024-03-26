import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let controllersFactory = ControllersFactory()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {

        guard let windowsScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowsScene)

        let tabBarController = TabBarController(controllersFactory: controllersFactory)

        window.rootViewController = tabBarController

        self.window = window

        window.makeKeyAndVisible()

    }
}
