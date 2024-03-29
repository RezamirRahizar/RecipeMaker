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
    var recipes =  BehaviorRelay<[RecipeItem]>(value: [])
    let context: NSManagedObjectContext?
    let targetVC: UIViewController?
    
    init(context: NSManagedObjectContext?, targetVC: UIViewController? = nil){
        self.context = context
        self.targetVC = targetVC
    }
    
    func fetchItems(){
        guard let context else { return }
        do {
            let models = try context.fetch(RecipeItem.fetchRequest())
            recipes.accept(models)
        }catch {
            print("Unable to fetch items")
        }
        
    }
}
