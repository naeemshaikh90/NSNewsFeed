//
//  CommonUtil.swift
//  NSNewsFeed
//
//  Created by Spaculus MM on 26/08/15.
//  Copyright (c) 2015 Spaculus MM. All rights reserved.
//

import UIKit

let AlertTitle = "NSNewsFeed"
//===================ERRORS==========================//

let ERROR_COMMON = "Something went wrong, please try again later."
let ERROR_NO_INTERNET_CONNECTION = "No Internet Connection. Please Try Again"

//===================================================//

class CommonUtil: NSObject {
    
    // MARK: - hasConnected
    /*
    +(BOOL)connected
    {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.co.in"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    }
    */
    class func connected() -> Bool{
        let reachability:Reachability = Reachability.forInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    // MARK: - Show ALert
    class func ShowALert(_ myTitle:String , myMessage message:String) {
        let alert:Void = UIAlertView(title: myTitle, message: message, delegate: self, cancelButtonTitle: "OK").show()
    }
    
    class func ShowALertWithDelegate(_ myTitle:String, myMessage message:String, myTarget target:UIAlertViewDelegate) {
        let alert:Void = UIAlertView(title:myTitle, message:message, delegate:target, cancelButtonTitle: "YES", otherButtonTitles: "NO").show()
    }
   
}
