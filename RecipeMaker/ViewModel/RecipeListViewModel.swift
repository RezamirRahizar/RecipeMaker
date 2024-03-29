//
//  RecipeListViewModel.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class RecipeListViewModel {
    var recipes =  BehaviorRelay<[RecipeModel]>(value: [])
    let context: NSManagedObjectContext?
    let targetVC: UIViewController?
    
    init(context: NSManagedObjectContext?, targetVC: UIViewController? = nil){
        self.context = context
        self.targetVC = targetVC
    }
    
    func fetchItems(){
        //TODO: Replace with data from CoreData
        let models = [
            RecipeModel(name: "Fried Chicken", type: "Main Course", imagePath: nil, ingredients: "Chicken", steps: "Cook, Bake, Eat"),
            RecipeModel(name: "Beef Stew", type: "Soup", imagePath: nil, ingredients: "Beef", steps:
                "Cook, Bake"
            ),RecipeModel(name: "Mutton Skewers", type: "Side Dish", imagePath: nil, ingredients: "Mutton", steps:
                "Cook, Eat"
            ),RecipeModel(name: "Cake", type: "Dessert", imagePath: nil, ingredients: "Flour, Cherry, Milk", steps:
                "Bake, Eat"
            )
        ]

        recipes.accept(models)
    }
}
