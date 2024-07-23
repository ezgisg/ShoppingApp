//
//  BaseViewController.swift
//
//
//  Created by Ezgi Sümer Günaydın on 17.07.2024.
//

import Foundation

import UIKit

// MARK: - BaseViewControllerProtocol
public protocol BaseViewControllerProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - BaseViewController
open class BaseViewController: UIViewController, LoadingShowable {
    private var tapGesture: UITapGestureRecognizer!
    public var activeTextField: UITextField?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    final func showAlert(title: String, message: String, buttonTitle: String = "Try Again", completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - BaseViewController: BaseViewControllerProtocol
extension BaseViewController: BaseViewControllerProtocol {

    final public func showLoadingView() {
        showLoading()
    }
    
    final public func hideLoadingView() {
        hideLoading()
    }
}

//MARK: Keyboard operations
///When keyboard is active then other tap properties disabled and when tap anywhere else but keyboard then keyboard hide
///Checking whether the selected textfield remains under the keyboard. If it is under keyboard then shifting the view. For this activeTextField must set
public extension BaseViewController {
    final func setupKeyboardObservers(activeTextField: UITextField? = nil) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.activeTextField = activeTextField
    }

    @objc final func keyboardWillShow(notification: NSNotification) {
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        }
        view.addGestureRecognizer(tapGesture)
        
        ///To scroll the view up
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = activeTextField else {
            return
        }

        let keyboardTop = view.frame.height - keyboardFrame.height
        let textFieldBottom = activeTextField.convert(activeTextField.bounds, to: view).maxY

        if textFieldBottom + 40 > keyboardTop {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                view.frame.origin.y = keyboardTop - textFieldBottom - 40
            }
        }
    }

    @objc final func keyboardWillHide(notification: NSNotification) {
        if tapGesture != nil {
            view.removeGestureRecognizer(tapGesture)
        }
        ///To return the view to its original place
        view.frame.origin.y = 0
    }

    @objc final func dismissKeyboard() {
        view.endEditing(true)
    }
}
