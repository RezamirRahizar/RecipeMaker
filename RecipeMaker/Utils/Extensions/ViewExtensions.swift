//
//  ViewExtensions.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit

extension UIViewController {
    var safeAreaInsets: UIEdgeInsets {
        guard let keyWindow = getKeyWindow() else { return UIEdgeInsets.zero }
        
        return keyWindow.safeAreaInsets
    }
    
    func getMainScreen() -> UIScreen? {
        return UIApplication.shared.connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }.first?.screen
    }
    
    func getNavbarHeight() -> CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
    
    func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
}


extension UIView {
    func addSubviews(_ views: [UIView]){
        views.enumerated().forEach { _, view in
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]){
        views.enumerated().forEach { _, view in
            self.addArrangedSubview(view)
        }
    }
}


