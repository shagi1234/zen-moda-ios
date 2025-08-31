//
//  File.swift
//  ZenModaIOS
//
//  Created by Shahruh on 13.07.2025.
//


import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .white
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
