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
    
    
    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension","Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]

    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]

    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]

    var foodList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]

    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]
    
    func addFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
        let newFilter = Filters(entity: entity!, insertInto: context)
        newFilter.category = "Allergies"
//        filterList.append("Allergies")
        for allergy in allergyList {
            newFilter.filter = allergy
        }
        newFilter.category = "Diet"
        for diet in dietList {
            newFilter.filter = diet
        }
        newFilter.category = "Meal"
        for meal in mealList {
            newFilter.filter = meal
        }
        newFilter.category = "Food"
        for food in foodList {
            newFilter.filter = food
        }
        newFilter.category = "Cuisine"
        for cuisine in cuisineTypeList {
            newFilter.filter = cuisine
        }
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
