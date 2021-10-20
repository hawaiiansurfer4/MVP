//
//  filterVC.swift
//  MVP
//
//  Created by Sean Murphy on 10/9/21.
//

import UIKit
import CoreData

var filterList = [Filters]()

class FilterVC: UITableViewController {
    
    var healthList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension","Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]

    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]

    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]

    var dishTypeList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]

    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]
    
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        if(firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        cell.textLabel?.text = filterList[indexPath.row].filter
        if filterList[indexPath.row].selectedFilter == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterList[indexPath.row].selectedFilter = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
