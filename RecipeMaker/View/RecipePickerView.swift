//
//  RecipePickerView.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit
import SnapKit

class RecipePickerView: UIView {
    let targetVC: UIViewController
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var pickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Select a recipe"
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    
    init(type: String?, targetVC: UIViewController) {
        self.targetVC = targetVC
        super.init(frame: .zero)
        if let type {
            pickerLabel.text = type
            pickerLabel.textColor = .lightGray
        }
     
        setupViews()
        layoutViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(containerView)
        containerView.addSubview(pickerLabel)
        
        let tapGesture = UITapGestureRecognizer(target: targetVC, action: #selector(openPicker))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func layoutViews(){
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pickerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
    }
    
    @objc func openPicker(){
        let vc = RecipeTypeViewController()
        let alertController = UIAlertController(title: "Choose a recipe type", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        targetVC.addChild(vc)
        alertController.view.addSubview(vc.view)
        vc.didMove(toParent: targetVC)
        
        targetVC.present(alertController, animated:true)
            
    }
}
