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

class LoginViewController: UIViewController, JSAnimatedImagesViewDataSource, UINavigationControllerDelegate,  UIImagePickerControllerDelegate{

    // 图片拾取器
    var imgPicker: UIImagePickerController = UIImagePickerController()
    
    //图片动画，由远及近，放大
    @IBOutlet weak var loginImageList: JSAnimatedImagesView!

    @IBOutlet weak var loginImageButton: RoundButtonView!
    var loginImageView: UIImageView?
    
    @IBAction func chooseImage(sender: RoundButtonView) {
        //chooseImageFromFile()
        var nibNameOrNil = String?("photoChooseView")
        let photoVC = PhotoViewController(nibName: nibNameOrNil, bundle: nil)
        photoVC.view.frame.origin.x = 0
        photoVC.view.frame.origin.y = 300
        self.presentViewController(photoVC, animated: true, completion: nil)
    }
    @IBOutlet weak var loginUserId: UITextField!
    @IBOutlet weak var loginUserPwd: UITextField!
    
    @IBOutlet weak var bAutoLogin: UISwitch!
    @IBOutlet weak var bRememberPwd: UISwitch!
    @IBAction func loginClick(sender: UIButton) {
        var token: String = loginGetToken()
        loginCheck()
    }
    
    @IBAction func loginNewUserClick(sender: UIButton) {
    }
    
    @IBAction func loginFogetPwdClick(sender: UIButton) {
    }
    
    //获取登录用户的token
    func loginGetToken()->String{
        return "hell"
    }
    
    // 登录check
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
    
    // 登录成功执行
    func loginSuccess(jsonResult:NSDictionary!)
    {
        
        //获取用户信息
        if jsonResult["result"] as! Int == 200{
            println("Successful!")
            
            var tokenString: String = jsonResult.objectForKey("data") as! String
            // 保存默认用户信息
            saveNSUserDefaults(tokenString)
            
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
        
        //图片拾取器
        self.imgPicker.delegate = self
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
    func saveNSUserDefaults(tokenString: String){
        var userDefaults = NSUserDefaults()
        userDefaults.setValue(tokenString, forKey: "userToken")
        userDefaults.setValue(self.loginUserId.text, forKey: "loginName")
        userDefaults.setValue(self.loginUserPwd.text, forKey: "loginPwd")
        userDefaults.setBool(bAutoLogin.on, forKey: "AutoLogin")
        userDefaults.setBool(bRememberPwd.on, forKey: "RememberPwd")
        //var imageData: NSData = UIImageJPEGRepresentation(loginImageButton.imageForState(UIControlState.Normal), 1)
        var imageData: NSData = UIImagePNGRepresentation(loginImageButton.imageForState(UIControlState.Normal))
        userDefaults.setObject(imageData, forKey: "loginImage")
        userDefaults.synchronize()
    }
    
    // 读取本地登陆信息
    func loadNSUserDefaults(){
        var userDefaults = NSUserDefaults()
        self.loginUserId.text = userDefaults.stringForKey("loginName")
        self.loginUserPwd.text = userDefaults.stringForKey("loginPwd")
        self.bAutoLogin.setOn(userDefaults.boolForKey("AutoLogin"), animated: true)
        self.bRememberPwd.setOn(userDefaults.boolForKey("RememberPwd"), animated: true)
        var imageData: NSData = userDefaults.dataForKey("loginImage")!
        self.loginImageButton.setImage(UIImage(data: imageData), forState: UIControlState.Normal)
        
        if !bRememberPwd.on {
            self.loginUserPwd.text = ""
        }
        
        if bAutoLogin.on {
            //self.loginCheck()
        }
    }
    
    
    //从本地查找图片
    func chooseImageFromFile(){
        imgPicker.view.backgroundColor = UIColor.grayColor()
        var pickSourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imgPicker.sourceType = pickSourceType
        imgPicker.allowsEditing = true
        
        self.presentViewController(imgPicker, animated: true) { () -> Void in
            
        }
    }
    
    // 图片获取之后处理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imgPicker.dismissViewControllerAnimated(true, completion: nil)
        var img = info[UIImagePickerControllerEditedImage] as? UIImage
        
        var newSize: CGSize = self.loginImageButton.frame.size
        self.loginImageButton.setImage(scaleToSize(img!, size: newSize), forState: UIControlState.Normal)
        
        //self.loginImageButton.addSubview(loginImageView!)
    }
    
    func scaleToSize(image: UIImage, size: CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
