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
    var recipeTypes: [String]? = []
    var recipeName: String = ""
    var recipeType: String = ""
    private let scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, typeTextField])
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
    
    private lazy var typeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select recipe type"
        textField.delegate = self
        textField.inputView = tempPicker
        textField.inputAccessoryView = tempPicker.toolbar
        
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var tempPicker: RecipeTypePickerView = {
        let picker = RecipeTypePickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.toolbarDelegate = self
        picker.reloadAllComponents()
        
        return picker
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
        recipeTypes = RecipeTypesManager().getTypes()
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

extension AddRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let recipeTypes else {
            return 0
        }
        
        return recipeTypes.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes?[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeTextField.text = recipeTypes?[row]
    }
}

extension AddRecipeViewController: RecipeTypePickerViewDelegate {
    func didTapDone() {
        let row = self.tempPicker.selectedRow(inComponent: 0)
        tempPicker.selectRow(row, inComponent: 0, animated: false)
        typeTextField.text = recipeTypes?[row]
        typeTextField.resignFirstResponder()
    }

    func didTapCancel() {
        typeTextField.text = nil
        typeTextField.resignFirstResponder()
    }
}


