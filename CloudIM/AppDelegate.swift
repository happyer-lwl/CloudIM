//
//  AppDelegate.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/19.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,RCIMUserInfoDataSource {

    var window: UIWindow?

    //获取用户信息
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        
        let userInfo = RCUserInfo()
        userInfo.userId = userId
        
        switch userId{
            case "lwl":
                userInfo.name = "奔跑的小二"
                userInfo.portraitUri = "http://www.xiaoboswift.com/2.jpg"
                println("lwl")
                break
            case "crp":
                userInfo.name = "咕咕"
                userInfo.portraitUri = "http://img4.duitang.com/uploads/item/201403/23/20140323171323_aNfWX.jpeg"
                println("crp")
                break
            default:
                println("当前没有此用户")
                break
        }
        
        return completion(userInfo)     //返回当前用户状态信息
    }
    
    func connectServer(completion:()->Void)
    {
        //查询保存的token
        let tokenCache = NSUserDefaults.standardUserDefaults().objectForKey("kDeviceToken") as? String
        
        //Init AppKey
        RCIM.sharedRCIM().initWithAppKey("3argexb6rtube", deviceToken: tokenCache)
        
        //Init delegate
        RCIM.sharedRCIM().userInfoDataSource = self
        
        //
        RCIM.sharedRCIM().connectWithToken("tjZ7p0fxNGIN7hoD9jeW9BQEQkqHuwTxaOA1GsqSFIHO04mn8aTlk9LRbzPqpnFfXaWclbFt41ms4a+KSHo0lQ==", success: { (_) -> Void in
            
            //连接在后台执行，需要回到UI主线程，获取主线程
            dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                
                completion()
                
            })
            
            
            
            }, error:{ (_) -> Void in
                
            }) { () -> Void in
                println("Token Error!")
        }
    }

    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //设置用户信息提供者
        let currentUser = RCUserInfo(userId: "lwl", name: "奔跑的小二", portrait: "http://www.xiaoboswift.com/2.jpg")
        
        RCIMClient.sharedRCIMClient().currentUserInfo = currentUser
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

