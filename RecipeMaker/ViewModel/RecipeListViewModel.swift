//
//  RecipeListViewModel.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import UIKit
import RxSwift
import CoreData

class RecipeListViewModel {
    var recipes =  PublishSubject<[RecipeModel]>()
    let context: NSManagedObjectContext?
    let targetVC: UIViewController?
    
    init(context: NSManagedObjectContext?, targetVC: UIViewController? = nil){
        self.context = context
        self.targetVC = targetVC
    }
    
    func fetchItems(){
        //TODO: Replace with data from CoreData
        let models = [
            RecipeModel(name: "Chicken", type: "Main Course", imagePath: nil, steps: [
                "Cook","Bake","Eat"
            ]),RecipeModel(name: "Beef", type: "Appetizer", imagePath: nil, steps: [
                "Cook","Bake","Eat"
            ]),RecipeModel(name: "Mutton", type: "Side Dish", imagePath: nil, steps: [
                "Cook","Bake","Eat"
            ]),RecipeModel(name: "Cake", type: "Dessert", imagePath: nil, steps: [
                "Cook","Bake","Eat"
            ])
        ]

        recipes.onNext(models)
        recipes.onCompleted()
    }
}
