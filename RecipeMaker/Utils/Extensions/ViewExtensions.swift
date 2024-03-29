//
//  ViewExtensions.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit

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


