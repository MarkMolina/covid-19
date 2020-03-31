//
//  DDInputPopupViewController.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import UIKit

class DDInputPopupViewController: DDViewController, UITextFieldDelegate {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeigthConstraint: NSLayoutConstraint!
    
    private let initialValue: Double
    private let valueDidChange: ((Double) -> ())?
    
    
    init(value: Double, valueDidChange: ((Double) -> ())?) {
        
        initialValue = value
        self.valueDidChange = valueDidChange
        super.init(nibName: "DDInputPopupViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        inputField.text = "\(initialValue)"
        inputField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            bottomConstraint.constant = keyboardHeight
            buttonBottomConstraint.constant = keyboardHeight + viewHeigthConstraint.constant
            UIView.animate(withDuration: 0.0) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        inputField.resignFirstResponder()
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let value = textField.text as NSString? else { return }
        valueDidChange?(value.doubleValue)
    }
}
