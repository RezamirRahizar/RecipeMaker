//
//  RecipeModel.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import UIKit


struct RecipeModel {
    let name: String
    let type: String
    let imagePath: UIImage? 
    let ingredients: String
    let steps: String
    
//    init(coreDataObject: RecipeItem){
//        self.name = coreDataObject.name ?? ""
//        self.type = coreDataObject.type ?? ""
//        if let imageData = coreDataObject.imagePath{
//            self.imagePath = UIImage(data: imageData)
//        }
//        self.ingredients = coreDataObject.ingredients ?? ""
//        self.steps = coreDataObject.steps ?? ""
//    }
}
