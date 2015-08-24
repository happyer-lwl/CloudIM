//
//  ConversationListViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/20.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit
import Social

class ConversationListViewController: RCConversationListViewController {

    //1 storyboard 跳转界面
    let conVC = RCConversationViewController()
    
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        
/*
        var frame = sender.valueForKey("view")?.frame
        frame?.origin.y += 30
        
       KxMenu.showMenuInView(self.view, fromRect:frame!, menuItems: [
        
            KxMenuItem("发起群聊", image: UIImage(named: "public_icon1"), target: self,  action: "ClickMenuGroup"),
            KxMenuItem("添加好友", image: UIImage(named: "public_greens_add"), target: self,  action: "ClickMenuAdd"),
            KxMenuItem("扫一扫", image: UIImage(named: "public_function_order_unlick"), target: self,  action: "ClickMenuScan"),
            KxMenuItem("收钱", image: UIImage(named: "public_function_promotion_unclick"), target: self,  action: "ClickMenuReceiveMoney")
            ])
*/
        
        //PopMenu
        let items = [
            MenuItem(title: "新浪", iconName: "public_share5", glowColor: UIColor.redColor(), index: 1),
            MenuItem(title: "微信", iconName: "public_share1", glowColor: UIColor.blueColor(), index: 2),
            MenuItem(title: "QQ", iconName: "public_share3", glowColor: UIColor.yellowColor(), index: 3),
            MenuItem(title: "twitter", iconName: "public_share4", glowColor: UIColor.grayColor(), index: 4)
        ]
        
        var popMenu = PopMenu(frame: self.view.frame, items: items)
        
        popMenu.menuAnimationType = PopMenuAnimationType.NetEase
        
        if popMenu.isShowed{
            return
        }
        
        popMenu.didSelectedItemCompletion = { (selectedItem: MenuItem!) -> Void in
            println(selectedItem.index)
            
            switch selectedItem.index{
            case 1:
                break;
            case 2:
                break;
            case 3:
                var controllerTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                controllerTwitter.setInitialText("分享到推特儿！")
                controllerTwitter.addImage(UIImage(named: "public_share3"))
                self.presentViewController(controllerTwitter, animated: true, completion: nil)
                break;
            case 4:
                var controllerFaceBook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                controllerFaceBook.setInitialText("分享到Facebook！")
                controllerFaceBook.addImage(UIImage(named: "public_share4"))
                self.presentViewController(controllerFaceBook, animated: true, completion: nil)
                break;
            default:
                break;
            }
            
            self.tabBarController?.tabBar.hidden = false
        }
        
        popMenu.showMenuAtView(self.view)
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    func ClickMenuGroup()
    {
        println("发起群聊")
    }
    
    func ClickMenuAdd()
    {
        println("添加好友")
    }
    
    func ClickMenuScan()
    {
        println("扫一扫")
        //代码进行页面跳转
        
    }
    
    func ClickMenuReceiveMoney()
    {
        println("收钱")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //AppDelegate为全局唯一，需要公用的方法写在AppDelegate中
        //获取AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        //在需要连接的部分去连接服务器
        //执行AppDelegate中的connectServer方法
        appDelegate?.connectServer({ () -> Void in
            
            self.setDisplayConversationTypes([
                RCConversationType.ConversationType_APPSERVICE.rawValue,
                RCConversationType.ConversationType_CHATROOM.rawValue,
                RCConversationType.ConversationType_CUSTOMERSERVICE.rawValue,
                RCConversationType.ConversationType_DISCUSSION.rawValue,
                RCConversationType.ConversationType_PRIVATE.rawValue,
                RCConversationType.ConversationType_GROUP.rawValue,
                RCConversationType.ConversationType_PUBLICSERVICE.rawValue,
                RCConversationType.ConversationType_SYSTEM.rawValue
                ])
            
            //执行此步才可以刷新
            self.refreshConversationTableViewIfNeeded()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        println("hello")
        
        //1 storyboard 跳转界面
        let destVC = segue.destinationViewController as? RCConversationViewController
        
        destVC?.targetId = self.conVC.targetId
        destVC?.userName = self.conVC.userName
        destVC?.conversationType = self.conVC.conversationType
        destVC?.title = self.conVC.title

        //1 storyboard 跳转界面
        
        self.tabBarController?.tabBar.hidden = true
    }

    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
        conVC.targetId = model.targetId
        conVC.userName = model.conversationTitle
        conVC.conversationType = RCConversationType.ConversationType_PRIVATE
        conVC.title = model.conversationTitle
        
        self.performSegueWithIdentifier("tabOnCell", sender: self)
        println("world")
        
/*        //代码跳转到会话界面
        let conVC = RCConversationViewController()
        
        conVC.targetId = model.targetId
        conVC.userName = model.conversationTitle
        conVC.conversationType = RCConversationType.ConversationType_PRIVATE
        conVC.title = model.conversationTitle
        
        self.navigationController?.pushViewController(conVC, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
*/
    }

}
