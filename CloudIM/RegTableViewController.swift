//
//  RegTableViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/24.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

class RegTableViewController: UITableViewController {
    
    var (userOk, pwdOk, mailOk) = (false, false, false)
    
    @IBOutlet var loginTextMustFields: [UITextField]!
    @IBOutlet var loginTextNotFields: [UITextField]!
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var pass_question: UITextField!
    @IBOutlet weak var pass_answer: UITextField!
    
    func checkRequeriedField() ->Bool{
        
        let doneButton = self.navigationItem.rightBarButtonItem
        
        //一次性定位所有的子控件，第三方UIView+ViewRecursion
 /*       self.view.runBlockOnAllSubviews { (subview) -> Void in
            if let textfield = subview as? UITextField{
                if textfield.text.isEmpty {
                    println("当前没有内容！")
                }
            }
        }
*/
        //storyboard 建立数组，遍历
        for textField in loginTextMustFields {
            if textField.text!.isEmpty {
                errorMessage(self, "必填项有空行")
                return false
            }
        }
        
        //通过正则表达式对内容进行校验
        let regex = "[A-Z0-9a-z._]+@[A-Za-z0-9._]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluateWithObject(mail.text){
            println("邮箱格式正确!")
            return true
        }else {
            println("邮箱格式不正确!")
            return false
        }
        
        //textfield 左右子视图
        //        let rightLabel = UILabel(frame: CGRectMake(20, 0, 30, 30))
        //        rightLabel.text = "x"
        //        user.rightView = rightLabel
        //        user.rightViewMode = UITextFieldViewMode.WhileEditing
        
        //通过第三方库校验,应该在界面进入时初始化，进行检测
        let vUser = AJWValidator(type: .String)
        vUser.addValidationToEnsureMinimumLength(3, invalidMessage: "最少为3个字符")
        vUser.addValidationToEnsureMaximumLength(15, invalidMessage: "最多只能有15个字符")
        self.user.ajw_attachValidator(vUser)
        
        var bUserState: Bool = true
        vUser.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
            case .ValidationStateValid:
                println("有效!")
                self.userOk = true
            default:
                println("无效!")
                self.userOk = false
                errorMessage(self, vUser.errorMessages.first as! String)
            }
            
            doneButton?.enabled = self.userOk && self.pwdOk  && self.mailOk
        }
        
        let vPwd = AJWValidator(type: .String)
        vPwd.addValidationToEnsureMinimumLength(6, invalidMessage: "最少为6个字符")
        vPwd.addValidationToEnsureMaximumLength(15, invalidMessage: "最多只能有15个字符")
        self.user.ajw_attachValidator(vPwd)
        
        vPwd.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
            case .ValidationStateValid:
                println("有效!")
                self.pwdOk = true
            default:
                println("无效!")
                self.pwdOk = false
            }
            doneButton?.enabled = self.userOk && self.pwdOk  && self.mailOk
        }
        
        let vMail = AJWValidator(type: .String)
        vMail.addValidationToEnsureValidEmailWithInvalidMessage("邮箱格式不正确")
        self.mail.ajw_attachValidator(vMail)
        
        vMail.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
            case .ValidationStateValid:
                self.mailOk = true
            default:
                self.mailOk = false
            }
            doneButton?.enabled = self.userOk && self.pwdOk && self.mailOk
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTap")
        
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationItem.title = "新用户注册"
        self.navigationController?.navigationItem.rightBarButtonItem?.enabled = false
        
        //checkRequeriedField()
    }

    func doneButtonTap(){
        let manager = AFHTTPRequestOperationManager()
        let url = "http://123.57.80.107:100"
        
        let params = ["api_uid":"Login","type":"regUser","name":user.text, "pwd":pass.text, "mail":mail.text, "question" : pass_question.text, "answer":pass_answer.text,"phone":"13933673296"]
        
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
            
            let alertView = UIAlertController(title: "恭喜，恭喜", message: "您已注册成功！", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "好的!", style: UIAlertActionStyle.Default, handler: { (curAction) -> Void in
                self.backToRootView()
            })
            alertView.addAction(alertAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else{
            errorMessage(self, "当前用户名已存在，请重新输入！")
        }
    }
    
    func backToRootView(){
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        // 通知传递数据
        var dict = NSDictionary(objectsAndKeys: self.user.text, "name", self.pass.text, "pwd")
        NSNotificationCenter.defaultCenter().postNotificationName("registerCompletion", object: nil, userInfo: dict as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 3
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
