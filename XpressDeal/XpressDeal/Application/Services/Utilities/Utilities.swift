//
//  Utilities.swift
//  MusixxiRecorder
//
//  Created by Lakeba-026 on 06/12/16.
//  Copyright © 2016 Lakeba Corporation Pty Ltd. All rights reserved.
//

import UIKit
import SystemConfiguration
var commonAppDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
var CommonHomeAPI = "http://172.104.181.194/demos/dj"
let userData = (UserDefaults.standard.dictionary(forKey: "profile")! as NSDictionary)
let credentialData = "\((userData.value(forKey: "Username") as! String)):\((userData.value(forKey: "Password") as! String))".data(using: String.Encoding.utf8)
let base64Credentials = credentialData?.base64EncodedString()
let headers = ["Authorization": "Basic \(base64Credentials!)"]
let processor = RoundCornerImageProcessor(cornerRadius: 20)
//macros
extension UIColor {
    convenience init(netHex:Int) {
        self.init(red: CGFloat((Float((netHex & 0xFF0000) >> 16)) / 255.0), green: CGFloat((Float((netHex & 0xFF00) >> 8)) / 255.0), blue: CGFloat((Float(netHex & 0xFF)) / 255.0), alpha: CGFloat(1.0))
    }
}

//Theme color for XpressDeal
let navigationbarColor = UIColor.init(red: 191.0 / 255.0, green: 0.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
let dropdownselectColor = UIColor.init(red: 30.0 / 255.0, green: 138.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
let CountcircleButtonColor = UIColor.init(red: 0.0 / 255.0, green: 196.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)

class Utilities: NSObject {
    
    
    //singleton Instance
    class func sharedInstance() -> Utilities {
        var UtilitiesClass: Utilities? = nil
        if(UtilitiesClass != nil)
        {
            UtilitiesClass = Utilities()
        }
        return UtilitiesClass!
    }
    
    //MARK: - Show alert
    //show an alert
    class func showAlert(_ alertMessage: String) {
        let alert = UIAlertController(title: "XpressDeal", message: alertMessage, preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertCancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    //MARK: - Loading, Hiding progress view
    //show Loading
    class func showLoading() {
        //let window = UIApplication.shared.windows.last! as UIWindow
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window, animated: true)
   //     hud?.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
//        hud?.labelText = "Loading ..."
//        hud?.labelColor = UIColor(netHex: 0x878787)
//        hud?.color = UIColor(netHex: 0xC3C3C3)
        //return hud!
    }
    
    class func showLoading(_ message: String) {
        //let window = UIApplication.shared.windows.last! as UIWindow
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
//        hud?.labelText = message
//        hud?.labelColor = UIColor(netHex: 0x878787)
//        hud?.color = UIColor(netHex: 0xC3C3C3)
    }
    //To hide the loading
    class func hideLoading() {
        //let window = UIApplication.shared.windows.last! as UIWindow
        UIApplication.shared.endIgnoringInteractionEvents()
        MBProgressHUD.hide(for: commonAppDelegate.window, animated: true)
    }
    
    class func hideAllLoading()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        MBProgressHUD.hideAllHUDs(for: commonAppDelegate.window, animated: true)
    }
    
    //MARK: - date of string change two digits
    class func changeTwoDigitString(_ dateString : String)-> String
    {
        if(dateString.count < 2)
        {
            return "0\(dateString)"
        }
        return dateString
    }
    
    //MARK: - Check Internet Connection
    //Checking the internet connection
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    //MARK: - Check internet Connection
    class func checkForInternet() -> Bool {
        let status = NetworkReachabilityManager.init(host: "www.google.com")
        if self.isConnectedToNetwork() == true && status?.networkReachabilityStatus != .notReachable
        {
           // print("Internet Connection Available!")
            return true
        }
        else
        {
            //print("Internet Connection not Available!")
            return false
        }
        
    }

    //Check the Battery level
    class func checkBattertLevel() -> Bool {
        #if (TARGET_IPHONE_SIMULATOR)
            UIDevice.current.isBatteryMonitoringEnabled = true
            var batteryLevel = UIDevice.current.batteryLevel
            batteryLevel *= 100
            //change the minimum battery level
            if(batteryLevel > 3)
            {
                return true
            }
            else
            {
                self.showAlert("You need low battery power")
                return false
            }
        #else
            return true
        #endif
        
    }
    
    class func collectionViewCellWidth()->CGFloat
    {
        if(UIScreen.main.bounds.size.width == 320)
        {
            return 100
        }
        else if(UIScreen.main.bounds.size.width == 375)
        {
            return 90
            //return (UIScreen.main.bounds.size.width) / 5
        }
        else if(UIScreen.main.bounds.size.width == 414)
        {
            return 100
            //return (UIScreen.main.bounds.size.width - 4) / 5
        }
        else
        {
            return 100
        }
    }
    
    //MARK: NavigationMenu Showing
    class func homeNavigationMenu(rootVC : UIViewController)
    {
        rootVC.navigationController?.navigationBar.barTintColor = navigationbarColor
        rootVC.navigationController?.navigationBar.isTranslucent = false
        rootVC.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    class func callSideMenu(rootVC : UIViewController)
    {
        SideMenuManager.default.menuLeftNavigationController = rootVC.storyboard!.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: rootVC.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: rootVC.navigationController!.view)
    }
    
    //MARK: Make cardview for all cell
    //Make card view on cell View
   class func viewBorderColor (ContentView : UIView)
    {
        ContentView.layer.borderColor = UIColor.white.cgColor
        ContentView.layer.borderWidth = 2.0
        ContentView.layer.cornerRadius = 8.0
    }
    class func AnimationShakeTextField(textField:UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }
   
}

