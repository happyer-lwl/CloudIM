//
//  AboutViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/9/2.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBAction func backToMain(sender: UIButton) {
        backToLoginView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToLoginView(){
        let loginView:UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView")  as! UIViewController
        
        self.presentViewController(loginView, animated: true, completion: nil)
    }
}
