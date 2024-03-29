
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
    
    func saveData(model: RecipeModel, recipeItem: RecipeItem?, onCompletion: ((Bool) -> Void)){
        guard let context else { return }
        var item: RecipeItem
        
        if let recipeItem {
            item = recipeItem
        }else{
            item = RecipeItem(context: context)
        }
        
        item.name = model.name
        item.type = model.type
        if let imageData = model.imagePath?.jpegData(compressionQuality: 1.0){
            item.imagePath = imageData
        }
        item.ingredients = model.ingredients
        item.steps = model.steps
        
       
        
        do {
            try context.save()
            onCompletion(true)
        }catch {
            print("Failed to save new recipe")
            onCompletion(false)
        }
    }
}
