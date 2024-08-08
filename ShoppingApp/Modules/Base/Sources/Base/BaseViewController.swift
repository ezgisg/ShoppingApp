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
    private var tapGesture: UITapGestureRecognizer?
    public var activeTextField: UITextField?
    var scrollView: UIScrollView?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TODO: localizable
    public final func showAlert(title: String, message: String, buttonTitle: String = "Try Again", showCancelButton: Bool = false, cancelButtonTitle: String = "Cancel", completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        
        if showCancelButton {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
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
    final func setupKeyboardObservers(activeTextField: UITextField? = nil, scrollView: UIScrollView? = nil) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.activeTextField = activeTextField
        self.scrollView = scrollView
    }

    @objc final func keyboardWillShow(notification: NSNotification) {
        keyboardWillShowForScrollView(notification: notification)
    
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        }
        guard let tapGesture else { return }
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
        keyboardWillHideForScrollView(notification: notification)
        if let tapGesture {
            view.removeGestureRecognizer(tapGesture)
        }
        ///To return the view to its original place
        view.frame.origin.y = 0
    }
    
    @objc final func keyboardWillShowForScrollView(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 40 , right: 0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc final func keyboardWillHideForScrollView(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
}
