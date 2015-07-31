import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myViewController: UIViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        //ViewControllerのインスタンス化
        myViewController = Bluetooth1ViewController()

        //UINavigationControllerのインスタンス化とrootViewControllerの指定
        var myNavigationController = UINavigationController(rootViewController: myViewController!)

        //UIWindowのインスタンス化
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        //UIWindowのrootViewControllerにnavigationControllerを指定
        self.window?.rootViewController = myNavigationController

        //UIWindowの表示
        self.window?.makeKeyAndVisible()

        return true

    }

}
