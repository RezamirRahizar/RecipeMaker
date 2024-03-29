
//
//  RecipeDetailsViewModel.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class RecipeDetailsViewModel {
    var didComplete =  BehaviorRelay<Bool?>(value: nil)
    let context: NSManagedObjectContext?
    let targetVC: UIViewController?
    
    init(context: NSManagedObjectContext?, targetVC: UIViewController? = nil){
        self.context = context
        self.targetVC = targetVC
    }
    
    func saveData(model: RecipeModel, onCompletion: ((Bool) -> Void)){
        guard let context else { return }
        let newRecipe = RecipeItem(context: context)
        newRecipe.name = model.name
        newRecipe.type = model.type
        if let imageData = model.imagePath?.jpegData(compressionQuality: 1.0){
            newRecipe.imagePath = imageData
        }
        newRecipe.ingredients = model.ingredients
        newRecipe.steps = model.steps
        
        do {
            try context.save()
            onCompletion(true)
        }catch {
            print("Failed to save new recipe")
            onCompletion(false)
        }
    }
}
