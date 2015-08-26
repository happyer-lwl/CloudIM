//
//  RegTableViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/8/24.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

class RegTableViewController: UITableViewController {
    
    @IBOutlet var loginTextMustFields: [UITextField]!
    @IBOutlet var loginTextNotFields: [UITextField]!
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var pass_question: UITextField!
    @IBOutlet weak var pass_answer: UITextField!
    
    func checkRequeriedField() {
        
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
                println("有空行！")
            }
        }
        
        //通过正则表达式对内容进行校验
        let regex = "[A-Z0-9a-z._]+@[A-Za-z0-9._]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluateWithObject(mail.text){
            println("邮箱格式正确!")
        }else {
            println("邮箱格式不正确!")
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
        
        //textfield 左右子视图
//        let rightLabel = UILabel(frame: CGRectMake(20, 0, 30, 30))
//        rightLabel.text = "x"
//        user.rightView = rightLabel
//        user.rightViewMode = UITextFieldViewMode.WhileEditing
        
        //通过第三方库校验
        let vUser = AJWValidator(type: .String)
        vUser.addValidationToEnsureMinimumLength(3, invalidMessage: "最少为3个字符")
        vUser.addValidationToEnsureMaximumLength(15, invalidMessage: "最多只能有15个字符")
        self.user.ajw_attachValidator(vUser)
        
        vUser.validatorStateChangedHandler = { (newState: AJWValidatorState) -> Void in
            switch newState {
            case .ValidationStateValid:
                println("有效!")
            default:
                println("无效!")
            }
        }
    }

    func doneButtonTap(){
        
        //checkRequeriedField()
        //换作注册新用户
        
//        let alert = UIAlertController(title: "提示", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
//        alert.addAction(action)
//        self.presentViewController(alert, animated: true, completion: nil)
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
