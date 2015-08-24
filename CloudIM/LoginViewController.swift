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
    
    @IBAction func loginClick(sender: UIButton) {
        
    }
    
    @IBAction func loginNewUserClick(sender: UIButton) {
        
    }
    
    @IBAction func loginFogetPwdClick(sender: UIButton) {
        
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
        
        //动画数据源
        self.loginImageList.dataSource = self
        
        //隐藏导航
        self.navigationController?.navigationBar.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        //隐藏导航
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
