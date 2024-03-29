//
//  RecipeDetailsViewController.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import UIKit
import SnapKit
import CoreData

enum DetailsState {
    case empty
    case nonempty
}

class RecipeDetailsViewController: UIViewController {
    let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var recipeTypes: [String]? = []
    var recipeName: String = ""
    var recipeType: String = ""
    var recipeIngredients: String = ""
    var recipeSteps: String = ""
    var recipeImage: UIImage?
    
    private lazy var viewModel: RecipeDetailsViewModel = {
        let viewModel = RecipeDetailsViewModel(context: context, targetVC: self)
        
        return viewModel
    }()
    
    private let scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            typeTextField,
            imageView,
            imagePickerButton,
            ingredientsTextView,
            stepsTextView
        ])
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
        textField.inputView = recipeTypePicker
        textField.inputAccessoryView = recipeTypePicker.toolbar
        
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var recipeTypePicker: RecipeTypePickerView = {
        let picker = RecipeTypePickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.toolbarDelegate = self
        picker.reloadAllComponents()
        
        return picker
    }()
    
    private lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload an image for the recipe", for: .normal)
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var ingredientsTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.text = "Enter the ingredients for your recipe"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        
        return textView
    }()
    
    private lazy var stepsTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.text = "Enter the steps for your recipe"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        
        return textView
    }()
    
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
        
        ingredientsTextView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        stepsTextView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    func setDetails(data: RecipeItem?){
        guard let data else { return }
        self.navigationItem.title = "Recipe Details"
        self.submitButton.isHidden = true
        if let name = data.name {
            recipeName = name
            nameTextField.text = name
            nameTextField.isEnabled = false
        }
        
        if let type = data.type {
            recipeType = type
            typeTextField.text = type
            typeTextField.isEnabled = false
        }
        
        if let imagePath = data.imagePath, let image = UIImage(data: imagePath){
            recipeImage = image
            imageView.image = image
            imageView.snp.remakeConstraints { make in
                make.height.equalTo(200)
            }
            imagePickerButton.isEnabled = false
        }
        
        if let ingredients = data.ingredients {
            recipeIngredients = ingredients
            ingredientsTextView.text = ingredients
            ingredientsTextView.isEditable = false
        }
        
        if let steps = data.steps {
            recipeSteps = steps
            stepsTextView.text = steps
            stepsTextView.isEditable = false
        }
        
        
    }
    
    @objc func showImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // You can also use .camera to allow taking a new photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func addRecipe(){
        let model = RecipeModel(name: recipeName, type: recipeType, imagePath: recipeImage, ingredients: recipeIngredients, steps: recipeSteps)
        viewModel.saveData(model: model) { [weak self] isCompleted in
            guard isCompleted else { return }
            self?.showSuccessPopup()
        }
    }
    
    private func didSelectRecipe(_ selectedType: String) {
        self.recipeType = selectedType
        typeTextField.text = selectedType
    }
    
    private func showSuccessPopup(){
        let alert = UIAlertController(title: "Success", message: "Recipe saved successfully!", preferredStyle: .alert)
    
        self.present(alert, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension RecipeDetailsViewController: UITextFieldDelegate {
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

//MARK: PickerView Delegates
extension RecipeDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

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
        didSelectRecipe(recipeTypes?[row] ?? "")
    }
}

extension RecipeDetailsViewController: RecipeTypePickerViewDelegate {
    func didTapDone() {
        let row = self.recipeTypePicker.selectedRow(inComponent: 0)
        recipeTypePicker.selectRow(row, inComponent: 0, animated: false)
        didSelectRecipe(recipeTypes?[row] ?? "")
        
        typeTextField.resignFirstResponder()
    }

    func didTapCancel() {
        typeTextField.text = nil
        typeTextField.resignFirstResponder()
    }
}

extension RecipeDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Image picker delegate method for handling selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            recipeImage = pickedImage
            imageView.snp.remakeConstraints { make in
                make.height.equalTo(200)
            }
        }else{
            imageView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
       
        dismiss(animated: true, completion: nil)
    }
   
    // Image picker delegate method for handling cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecipeDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == ingredientsTextView {
            self.recipeIngredients = textView.text
        }else if textView == stepsTextView{
            self.recipeSteps = textView.text
        }else{
            print("Text view not found")
        }
    }
}


