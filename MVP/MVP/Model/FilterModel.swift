//
//  FilterModel.swift
//  MVP
//
//  Created by Sean Murphy on 10/20/21.
//

import CoreData
import UIKit

var appFirstLoad = true

class FilterModel {


    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension", "Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]
    
    var allergyID = ["alcohol-free", "immuno-supportive", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free", "gluten-free", "keto-friendly", "gluten-free", "keto-friendly", "kidney-friendly", "kosher", "low-potassium", "lupine-free", "Mediterranean", "mustard-free", "low-fat-abs", "No-oil-added", "low-sugar", "paleo", "peanut-free", "pecatarian", "pork-free", "red-meat-free", "seasame-free", "shellfish-free", "soy-free", "sugar-conscious", "tree-nut-free", "vegan", "vegetarian", "wheat-free"]

    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]
    
    var dietID = ["balanced", "high-fiber", "high-protein", "low-carb", "low-fat", "low-sodium"]

    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]

    var typeOfDishList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]

    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]

    func addFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
        let newFilter = Filters(entity: entity!, insertInto: context)
        
        DispatchQueue.main.async {
            if appFirstLoad {
                appFirstLoad = false
                
                for allergy in 0..<self.allergyList.count {
                    newFilter.categoryTitle = "Allergies"
                    newFilter.id = self.allergyID[allergy]
                    newFilter.filter = self.allergyList[allergy]
                    newFilter.isSelected = false
                }
                self.saveFilters(context)
                for diet in 0..<self.dietList.count {
                    newFilter.filter = self.dietList[diet]
                    newFilter.categoryTitle = "Diet"
                    newFilter.isSelected = false
                    newFilter.id = self.dietID[diet]
                }
                self.saveFilters(context)
                for meal in self.mealList {
                    newFilter.categoryTitle = "Meal"
                    newFilter.filter = meal
                    newFilter.id = meal
                    newFilter.isSelected = false
                }
                self.saveFilters(context)
                for dish in self.typeOfDishList {
                    newFilter.categoryTitle = "Dish Type"
                    newFilter.filter = dish
                    newFilter.id = dish
                    newFilter.isSelected = false
                }
        }
        
            self.saveFilters(context)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Filters")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let filters = result as! Filters
                    filterList.append(filters)
                }
            } catch {
                print("Fetch Failed for filter")
            }
        }
    }
    func saveFilters(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving filters")
        }
    }
}
