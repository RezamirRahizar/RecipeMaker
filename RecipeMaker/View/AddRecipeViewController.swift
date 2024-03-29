//
//  AddRecipeViewController.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import UIKit
import SnapKit

class AddRecipeViewController: UIViewController {
    
    var recipeName: String = ""
    var recipeType: String = ""
    private let scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, pickerContainer])
        stack.axis = .vertical
        stack.spacing = 8
        
        return stack
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter recipe name"
        textField.delegate = self
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var pickerContainer: RecipePickerView = {
        let pickerView = RecipePickerView(type: nil, targetVC: self)
        
        return pickerView
    }()
    
    //Add imagePicker
    //Add reactive steps
    //Add reactive ingredients
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Add recipe", for: .normal)
        button.addTarget(self, action: #selector(addRecipe), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        navigationItem.title = "Add recipe"
        view.addSubviews([scrollView, submitButton])
        scrollView.addSubview(stackView)
    }
    
    private func layoutViews(){
        let bottomInset = max(24, safeAreaInsets.bottom)
        submitButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-bottomInset)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(getNavbarHeight() + 30)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(submitButton.snp.top)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
    
    @objc func addRecipe(){
        
    }
}

extension AddRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        self.recipeName = updatedText
       
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.recipeName = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


