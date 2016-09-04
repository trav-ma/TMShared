//
//  PopoverTextEntryViewController.swift
//  TMShared
//
//  Created by Travis Ma on 7/4/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

class PopoverTextEntryViewController: UIViewController {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewComment: StyledTextView!
    var didSaveText : ((String?) -> Void)!
    var text: String?
    var titleText: String?
    var shouldShowCloseButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewComment.text = text
        labelTitle.text = titleText
        btnClose.hidden = !shouldShowCloseButton
        self.preferredContentSize = self.view.frame.size
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if text == nil {
            textViewComment.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let newText = textViewComment.text!.characters.count > 0 ? textViewComment.text : nil
        if newText != text {
            didSaveText(newText)
        }
    }
    
    @IBAction func btnCloseTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
