//
//  APIManagerClass.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 09/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

let navigationMenuAPI = "\(CommonHomeAPI)/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=getChlidCat&format=json"
let CategoriesListAPI = "\(CommonHomeAPI)/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=getParentCat&format=json"
let signInAPI = "\(CommonHomeAPI)/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=login&format=json&ignoreMessages=0&"

class APIManagerClass: NSObject {

    //singleton Instance
    class func sharedInstance() -> APIManagerClass {
        var APIManagerclass: APIManagerClass?
        if(APIManagerclass == nil)
        {
            APIManagerclass = APIManagerClass()
        }
        return APIManagerclass!
    }
    class func navigationSubmenuList(URLString : String)
    {
        Alamofire.request(URLString).responseJSON { response in
            if let json = response.result.value {
                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! [Any])
                let dicvalue = NSMutableDictionary()
                for jsonresponse in jsonResult
                {
                    let key = (jsonresponse as AnyObject).value(forKey: "name") as! String
                    if(dicvalue.value(forKey: key) != nil)
                    {
                        let dicArray = dicvalue.value(forKey: key) as! NSMutableArray
                        dicArray.add(jsonresponse)
                        dicvalue.setValue(dicArray, forKey: key)
                    }
                    else
                    {
                        let dicArray = NSMutableArray()
                        dicArray.add(jsonresponse)
                        dicvalue.setValue(dicArray, forKey: key)
                    }
            }
                commonAppDelegate.menulistArray = dicvalue
                //commonAppDelegate.menulistArray.add(dicvalue)
        }
    }
}
    class func singinUserDetails(username: String , password : String)
    {
        Alamofire.request("\(signInAPI)username=\(username)&password=\(password)").responseJSON { response in
        if let json = response.result.value {
            let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
        }
        }
        
    }
}
