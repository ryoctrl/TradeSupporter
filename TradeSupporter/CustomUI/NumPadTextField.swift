//
//  NumPadTextField.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/28.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import UIKit

class NumPadTextField: UITextField, UITextFieldDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.keyboardType = .numberPad
        self.clearButtonMode = .always
        self.returnKeyType = .done
        //addToolBar()
        addNotification()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NumPadTextField.keyBoardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NumPadTextField.keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil
        )
    }
    
    let SCREEN_SIZE = UIScreen.main.bounds.size
    @objc func keyBoardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        self.superview!.superview!.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - self.superview!.superview!.frame.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.superview!.superview!.frame.origin.y = 0
    }
    
    func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NumPadTextField.donePressed))
        let previewLabel = UILabel()
        let previewField = UIBarButtonItem(customView: previewLabel)
        
        toolBar.setItems([doneButton, previewField], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        ViewController.shared!.endEditing()
    }
    
    /*UITextFieldDelegate*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}
