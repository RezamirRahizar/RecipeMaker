//
//  RecipeTypeViewController.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import SnapKit
import UIKit

class RecipeTypeViewController: UIViewController {
    var recipeTypes: [String]? = []
    var didSelectType: ((String) -> Void)?
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.reloadAllComponents()
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTypes = RecipeTypesManager().getTypes()
        
        pickerView.frame = view.bounds
        view.addSubview(pickerView)
    }
}

extension RecipeTypeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let recipeTypes else {
            return 0
        }
        
        return recipeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let recipeTypes else {
            return nil
        }
        return recipeTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectType?(recipeTypes?[row] ?? "")
    }
    
    
}
