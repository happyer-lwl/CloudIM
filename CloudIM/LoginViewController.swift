//
//  LoginViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/21.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

//添加Storyboard属性栏项目
//extension UIView {
//    @IBInspectable var CornerRadius: CGFloat{
//        get{
//            return layer.cornerRadius
//        }
//        
//        set{
//            layer.cornerRadius = newValue
//            layer.masksToBounds = (newValue > 0)
//        }
//    }
//}

//图片动画，由远及近，放大    第三方库JSAnimatedImagesViewDataSource

class LoginViewController: UIViewController, JSAnimatedImagesViewDataSource{

    //图片动画，由远及近，放大
    @IBOutlet weak var loginImageList: JSAnimatedImagesView!
    
    @IBOutlet weak var loginUserId: UITextField!
    @IBOutlet weak var loginUserPwd: UITextField!
    
    @IBOutlet weak var bAutoLogin: UISwitch!
    @IBOutlet weak var bRememberPwd: UISwitch!
    @IBAction func loginClick(sender: UIButton) {
        loginCheck()
    }
    
    @IBAction func loginNewUserClick(sender: UIButton) {
//        var regUserView : RegTableViewController = RegTableViewController()
//        regUserView.delegate = self
//        let NVC: UINavigationController = UINavigationController()
//        self.presentViewController(regUserView, animated: true, completion: nil)
    }
    
    @IBAction func loginFogetPwdClick(sender: UIButton) {
        
    }
    
    func loginCheck() {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://123.57.80.107:100"

        var params = ["api_uid":"Login","type":"LoginIn","name":loginUserId.text, "pwd":loginUserPwd.text]
        
        println(params)
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.GET(url, parameters: params, success: {
            (operation:AFHTTPRequestOperation!, respondsObject:AnyObject!) in
                println("JSON: " + respondsObject.description!)
        
                self.loginSuccess(respondsObject as! NSDictionary!);
        
            },
            failure: {
                (opertion:AFHTTPRequestOperation!, error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
    }
    
    func loginSuccess(jsonResult:NSDictionary!)
    {
        
        //获取用户信息
        if jsonResult["result"] as! Int == 200{
            println("Successful!")
            
            // 保存默认用户信息
            saveNSUserDefaults()
            
            //StoryBoard切换
            let anotherView:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarView")  as! UIViewController
            
            self.presentViewController(anotherView, animated: true, completion: nil)
        }
        else if jsonResult["result"] as! Int == 201{
            errorMessage(self, "用户名不存在，请重新输入！")
        }
        else if jsonResult["result"] as! Int == 202{
            errorMessage(self, "密码输入错误，请重新输入！")
        }
        else{
            errorMessage(self, "网络连接错误！")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var rectTextUserName: CGRect = loginUserId.frame
        rectTextUserName.size.height = 41
        loginUserId.frame = rectTextUserName
        
        var rectTextUserPwd: CGRect = loginUserPwd.frame
        rectTextUserPwd.size.height = 40
        loginUserPwd.frame = rectTextUserPwd
        
        var rectAutoLogin: CGRect = bAutoLogin.frame
        rectAutoLogin.size.width = 30
        rectAutoLogin.size.height = 22
        bAutoLogin.frame = rectAutoLogin
        
        //动画数据源
        self.loginImageList.dataSource = self
        
        //隐藏导航
        self.navigationController?.navigationBar.hidden = true
        
        //加入事件监听,select中内容的冒号不可省略
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"registerCompletion:", name:
            "registerCompletion", object: nil)
        
        // 读取默认用户
        loadNSUserDefaults()
    }

    override func viewWillAppear(animated: Bool) {
        //隐藏导航
        self.navigationController?.navigationBar.hidden = true
    }
    
    // 接受通知响应函数
    func registerCompletion(notification: NSNotification){
        let info = notification.userInfo as! NSDictionary

        if info.count != 0{
            self.loginUserId.text = info.objectForKey("name") as! String
            self.loginUserPwd.text = info.objectForKey("pwd") as! String
        }
        
        self.loginCheck()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 保存本地登陆信息
    func saveNSUserDefaults(){
        var userDefaults = NSUserDefaults()
        userDefaults.setValue(self.loginUserId.text, forKey: "loginName")
        userDefaults.setValue(self.loginUserPwd.text, forKey: "loginPwd")
        userDefaults.setBool(bAutoLogin.on, forKey: "AutoLogin")
        userDefaults.setBool(bRememberPwd.on, forKey: "RememberPwd")
        userDefaults.synchronize()
    }
    
    // 读取本地登陆信息
    func loadNSUserDefaults(){
        var userDefaults = NSUserDefaults()
        self.loginUserId.text = userDefaults.stringForKey("loginName")
        self.loginUserPwd.text = userDefaults.stringForKey("loginPwd")
        self.bAutoLogin.setOn(userDefaults.boolForKey("AutoLogin"), animated: true)
        self.bRememberPwd.setOn(userDefaults.boolForKey("RememberPwd"), animated: true)
        
        if !bRememberPwd.on {
            self.loginUserPwd.text = ""
        }
        
        if bAutoLogin.on {
            self.loginCheck()
        }
    }
    
    func animatedImagesNumberOfImages(animatedImagesView: JSAnimatedImagesView!) -> UInt {
        return 3
    }
    
    func animatedImagesView(animatedImagesView: JSAnimatedImagesView!, imageAtIndex index: UInt) ->
        UIImage! {
            return UIImage(named: "pic\(index)")
        }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        loginUserId.resignFirstResponder()
        loginUserPwd.resignFirstResponder()
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
