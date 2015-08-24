//
//  ConversationViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/20.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

class ConversationViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //聊天对象的信息
//        self.targetId = RCIMClient.sharedRCIMClient().currentUserInfo.userId
//        self.userName = RCIMClient.sharedRCIMClient().currentUserInfo.name
        //聊天模式为私聊
//        self.conversationType = .ConversationType_PRIVATE
        //聊天对象标题
        self.title = "与" + self.userName + "聊天中"
        //设置聊天对象头像样式
        self.setMessageAvatarStyle(._USER_AVATAR_CYCLE)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */
}
