//
//  PhotoViewController.swift
//  CloudIM
//
//  Created by 刘伟龙 on 15/9/5.
//  Copyright (c) 2015年 lwl. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
//    convenience override init() {
//        var nibNameOrNil = String?("photoChooseView")
//        
//        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil {
//            nibNameOrNil = nil
//        }
//        
//        self.init(nibName: nibNameOrNil, bundle: nil)
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
