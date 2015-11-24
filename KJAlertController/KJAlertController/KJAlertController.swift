//
//  KJAlertController.swift
//  KJAlertController
//
//  Created by Kurt Jensen on 11/23/15.
//  Copyright © 2015 Arbor Apps LLC. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class KJAlertController: UIViewController {
    
    class func alertController(title: String, message: String?) -> KJAlertController? {
        let kjAlertController = KJAlertController(nibName: "KJAlertController", bundle: nil)
        kjAlertController.title = title
        kjAlertController.message = message
        return kjAlertController
    }
    
    var actions = [KJAlertAction]()
    var textFields = [UITextField]()
    var message : String?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var stackView = UIStackView()
    var inputStackView = UIStackView()
    
    static let stackSpacing : CGFloat = 4
    static let inputHeight : CGFloat = 24
    static let preferredWidth : CGFloat = 260
    
    var hasSetupActions = false
    var maximumButtonsForHorizontal = 2
    
    var preferredContentSizeComputed : CGSize {
        let width : CGFloat = KJAlertController.preferredWidth
        var height : CGFloat = 32
        height += titleHeight()
        height += messageHeight()
        height += inputViewHeight()
        height += actionViewHeight()
        let maxHeight = UIScreen.mainScreen().bounds.height - 60
        return CGSizeMake(width, min(maxHeight,height))
    }
    
    func titleHeight() -> CGFloat {
        let label = UILabel()
        label.font = titleLabel.font
        label.numberOfLines = titleLabel.numberOfLines
        label.text = titleLabel.text
        let size = label.sizeThatFits(CGSizeMake(KJAlertController.preferredWidth, 260))
        return size.height
    }

    func messageHeight() -> CGFloat {
        let label = UILabel()
        label.font = messageLabel.font
        label.numberOfLines = messageLabel.numberOfLines
        label.text = messageLabel.text
        let size = label.sizeThatFits(CGSizeMake(KJAlertController.preferredWidth, 260))
        return size.height
    }
    
    func inputViewHeight() -> CGFloat {
        var height = CGFloat(textFields.count)*KJAlertController.inputHeight
        if (height > 0) {
            height += 8
        }
        return height
    }
    
    func actionViewHeight() -> CGFloat {
        var height : CGFloat = 0
        if (stackView.axis == .Vertical) {
            height = CGFloat(actions.count)*KJAlertButton.height
        } else {
            height = KJAlertButton.height
        }

        return height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title
        messageLabel.text = message
        
        stackView.distribution = .FillEqually
        stackView.spacing = KJAlertController.stackSpacing
        if (actions.count > maximumButtonsForHorizontal) {
            stackView.axis = .Vertical
        } else {
            stackView.axis = .Horizontal
        }
        
        inputStackView.spacing = KJAlertController.stackSpacing
        if (textFields.count > 0) {
            inputStackView = UIStackView()
            inputStackView.axis = .Vertical
            inputStackView.backgroundColor = UIColor.blueColor()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        for textField in textFields {
            if (textField.isFirstResponder()) {
                textField.resignFirstResponder()
            }
        }
        view.endEditing(true)
    }
    
    func addTextFieldWithConfiguration(configurationHandler:((UITextField)->Void)?) {
        let textField = UITextField()
        textField.backgroundColor = UIColor.whiteColor()
        textField.borderStyle = .Line

        configurationHandler?(textField)
        
        self.textFields.append(textField)
    }
    
    func addAction(action: KJAlertAction) {
        self.actions.append(action)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var scrollViewContentHeight : CGFloat = 0
        if (inputStackView.superview == nil) {
            scrollView.addSubview(inputStackView)
            let height : CGFloat = KJAlertController.inputHeight*CGFloat(textFields.count)
            scrollViewContentHeight += height
            let frame = CGRectMake(0, 0, scrollView.frame.size.width, height)
            inputStackView.frame = frame
            setupInputs()
            
        }
        if (stackView.superview == nil) {
            scrollView.addSubview(stackView)
            var y : CGFloat = inputStackView.frame.size.height
            if (y > 0) {
                y += 8
                scrollViewContentHeight += 8
            }
            scrollViewContentHeight += 8
            let height : CGFloat = KJAlertButton.height*CGFloat(stackView.axis == .Vertical ? actions.count : 1)
            scrollViewContentHeight += height
            let frame = CGRectMake(0, y, scrollView.frame.size.width, height)
            stackView.frame = frame
            setupActions()
        }
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollViewContentHeight)
    }
    
    func setupInputs() {
        
        for textField in textFields {
            textField.frame = CGRectMake(0, 0, inputStackView.frame.size.width, KJAlertController.inputHeight)
            inputStackView.addArrangedSubview(textField)
        }
        
    }
    
    func setupActions() {
        
        var defaultActions = [KJAlertAction]()
        var destructiveActions = [KJAlertAction]()
        var cancelActions = [KJAlertAction]()
        for action in actions {
            switch (action.type) {
            case .Default:
                defaultActions.append(action)
            case .Destructive:
                destructiveActions.append(action)
            case .Cancel:
                cancelActions.append(action)
            }
        }
        
        for action in defaultActions {
            let button = KJAlertButton(action: action)
            button.addTarget(self, action: "alertButtonTapped:", forControlEvents: .TouchUpInside)
            stackView.addArrangedSubview(button)
        }
        for action in destructiveActions {
            let button = KJAlertButton(action: action)
            button.addTarget(self, action: "alertButtonTapped:", forControlEvents: .TouchUpInside)
            stackView.addArrangedSubview(button)
        }
        for action in cancelActions {
            let button = KJAlertButton(action: action)
            button.addTarget(self, action: "alertButtonTapped:", forControlEvents: .TouchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    func alertButtonTapped(sender: KJAlertButton) {
        self.dismissKeyboard()
        dismissViewControllerAnimated(true) { () -> Void in
            if let action = sender.action {
                if let completionHandler = action.completionHandler {
                    completionHandler(action)
                }
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class KJAlertButton: UIButton {
    
    static let destructiveColor = UIColor.redColor()
    static let defaultColor = UIColor.darkGrayColor()
    static let cancelColor = UIColor.blackColor()
    static let destructiveFontColor = UIColor.whiteColor()
    static let defaultFontColor = UIColor.whiteColor()
    static let cancelFontColor = UIColor.whiteColor()
    
    static let font = UIFont.systemFontOfSize(14.0)
    
    static let borderColor = UIColor.lightGrayColor().CGColor
    static let borderWidth : CGFloat = 1
    static let cornerRadius : CGFloat = 4
    static let height : CGFloat = 30
    var action : KJAlertAction?
    
    convenience init(action: KJAlertAction) {
        self.init()
        self.contentHorizontalAlignment = .Center
        self.setTitle(action.title, forState: .Normal)
        self.action = action
        self.layer.masksToBounds = true
        self.layer.cornerRadius = KJAlertButton.cornerRadius
        self.layer.borderColor = KJAlertButton.borderColor
        self.layer.borderWidth = KJAlertButton.borderWidth
        self.titleLabel?.font = KJAlertButton.font
        
        switch (action.type) {
        case .Default:
            self.backgroundColor = KJAlertButton.defaultColor
            self.titleLabel?.textColor = KJAlertButton.defaultFontColor
        case .Destructive:
            self.backgroundColor = KJAlertButton.destructiveColor
            self.titleLabel?.textColor = KJAlertButton.destructiveFontColor
        case .Cancel:
            self.backgroundColor = KJAlertButton.cancelColor
            self.titleLabel?.textColor = KJAlertButton.cancelFontColor
        }
    }
    
}


class KJAlertAction: NSObject {
    
    enum KJAlertActionType {
        case Default
        case Destructive
        case Cancel
    }
    
    var completionHandler : ((KJAlertAction)->Void)?
    var type = KJAlertActionType.Default
    var title : String? = ""
    var image : UIImage?
    
    convenience init(title: String?, image: UIImage?, type: KJAlertActionType?, completionHandler:((KJAlertAction)->Void)?) {
        self.init()
        self.completionHandler = completionHandler
        self.title = title
        self.image = image
        if (type != nil) {
            self.type = type!
        }
    }
    
    override init() {
        super.init()
    }
    
}
