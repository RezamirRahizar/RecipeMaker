//
//  RecipeItem+CoreDataProperties.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//
//

import Foundation
import CoreData


extension RecipeItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeItem> {
        return NSFetchRequest<RecipeItem>(entityName: "RecipeItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var steps: String?

}

extension RecipeItem : Identifiable {

}
