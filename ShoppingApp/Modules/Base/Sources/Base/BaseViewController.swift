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
public extension BaseViewController {
    final func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    
      @objc final func keyboardWillShow() {
          if tapGesture == nil {
              tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          }
          view.addGestureRecognizer(tapGesture)
      }
      
      @objc final func keyboardWillHide() {
          if tapGesture != nil {
              view.removeGestureRecognizer(tapGesture)
          }
      }
      @objc final func dismissKeyboard() {
          view.endEditing(true)
      }
}
