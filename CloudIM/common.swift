//
//  common.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/31.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import Foundation

func errorMessage(view:UIViewController, errMsg: String){
    let alertView = UIAlertController(title: "客观，哪里出错了", message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
    let alertAction = UIAlertAction(title: "好吧!", style: UIAlertActionStyle.Default, handler: nil)
    alertView.addAction(alertAction)
    view.presentViewController(alertView, animated: true, completion: nil)
}

func infoMessage(view: UIViewController, title: String, actionTitle:String, infoMsg: String){
    let alertView = UIAlertController(title: title, message: infoMsg, preferredStyle: UIAlertControllerStyle.Alert)
    let alertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil)
    alertView.addAction(alertAction)
    view.presentViewController(alertView, animated: true, completion: nil)
}