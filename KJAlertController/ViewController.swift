//
//  ViewController.swift
//  KJAlertController
//
//  Created by Kurt Jensen on 11/23/15.
//  Copyright © 2015 Arbor Apps LLC. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlertTapped(sender: AnyObject) {
        if let kjAlertController = KJAlertController.alertController("hello hello hello hello hello hello hello hello hello hellolo hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello ", message: "worl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello dworl hello hello hello hello hello hello hello hello hello hellohello hello hello hello hello hello hello hello hello hello d") {
            kjAlertController.addTextFieldWithConfiguration({ (textField) -> Void in
                textField.keyboardType = .DecimalPad
                textField.text = "YOLOI"
                textField.backgroundColor = UIColor.whiteColor()
            })
            let alertAction = KJAlertAction(title: "Alert", image: nil, type: .Default) { (action) -> Void in
                for textField in kjAlertController.textFields {
                    print(textField.text)
                }
                
                let viewController = UIViewController()
                viewController.view.backgroundColor = UIColor.blueColor()
                self.presentViewController(viewController, animated: true, completion: nil)
            }
            let cancelAction = KJAlertAction(title: "Cancel", image: nil, type: .Cancel, completionHandler: nil)
            let cancelAction1 = KJAlertAction(title: "Cancel", image: nil, type: .Cancel, completionHandler: nil)
            let cancelAction2 = KJAlertAction(title: "Cancel", image: nil, type: .Cancel, completionHandler: nil)
            let cancelAction3 = KJAlertAction(title: "Cancel", image: nil, type: .Cancel, completionHandler: nil)
            let cancelAction4 = KJAlertAction(title: "Cancel", image: nil, type: .Cancel, completionHandler: nil)
            kjAlertController.addAction(alertAction)
            kjAlertController.addAction(cancelAction)
            kjAlertController.addAction(cancelAction1)
            kjAlertController.addAction(cancelAction2)
            kjAlertController.addAction(cancelAction3)
            kjAlertController.addAction(cancelAction3)
            kjAlertController.addAction(cancelAction1)
            kjAlertController.addAction(cancelAction2)
            kjAlertController.addAction(cancelAction3)
            kjAlertController.addAction(cancelAction3)
            kjAlertController.addAction(cancelAction1)
            kjAlertController.addAction(cancelAction2)
            kjAlertController.addAction(cancelAction3)
            kjAlertController.addAction(cancelAction3)
            
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: kjAlertController)
            formSheetController.presentationController?.shouldCenterHorizontally = true
            formSheetController.presentationController?.shouldCenterVertically = true
            formSheetController.presentationController?.contentViewSize = kjAlertController.preferredContentSizeComputed
            formSheetController.presentationController?.movementActionWhenKeyboardAppears = .AboveKeyboard

            self.presentViewController(formSheetController, animated: true, completion: nil)
        }
    }

}

