//
//  filterVC.swift
//  MVP
//
//  Created by Sean Murphy on 10/9/21.
//

import UIKit
import CoreData
import SwiftUI

var loaded = false

class FilterVC: UITableViewController {

    var filterList = [Filters]()
    var filter = Filters.self
    var filtersInPlace = false
    var previousCategory = "None"
    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension", "Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]


    var allergyID = ["alcohol-free", "immuno-supportive", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free", "gluten-free", "keto-friendly", "gluten-free", "keto-friendly", "kidney-friendly", "kosher", "low-potassium", "lupine-free", "Mediterranean", "mustard-free", "low-fat-abs", "No-oil-added", "low-sugar", "paleo", "peanut-free", "pecatarian", "pork-free", "red-meat-free", "seasame-free", "shellfish-free", "soy-free", "sugar-conscious", "tree-nut-free", "vegan", "vegetarian", "wheat-free"]

    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]

    var dietID = ["balanced", "high-fiber", "high-protein", "low-carb", "low-fat", "low-sodium"]

    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]

    var typeOfDishList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]

    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]


    override func viewDidLoad() {
        super.viewDidLoad()
        if hasFiltersBeenAdded() == false {
            addFilters()
        }
        print("### Before loadfilters \(filterList.count)")
        loadFilters()
        print("### After loadfilters \(filterList.count)")
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
        if filterList[indexPath.row].categoryTitle != previousCategory {
            cell.filterLabel.text = filterList[indexPath.row].categoryTitle
            cell.backgroundColor = .red
        }
        cell.filterLabel.text = filterList[indexPath.row].filter

        cell.isSelectedImage.image = filterList[indexPath.row].isSelected ? .checkmark : .none
        saveFilters()

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            filterList[indexPath.row].isSelected = !filterList[indexPath.row].isSelected
            try context.save()
        } catch {
            print("Error saving done status, \(error)")
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func hasFiltersBeenAdded() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Filters")
        let totalCount = allergyList.count + mealList.count + cuisineTypeList.count + dietList.count + typeOfDishList.count
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            if results.count == totalCount {
                filtersInPlace = true
            } else {
                filtersInPlace = false
            }
        } catch {
            print("Error checking if filters are in place")
        }
        return filtersInPlace
    }

    func addFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        for allergy in 0..<self.allergyList.count {
            let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
            let newFilter = Filters(entity: entity!, insertInto: context)
            newFilter.categoryTitle = "Allergies"
            newFilter.id = allergyID[allergy]
            newFilter.filter = allergyList[allergy]
            newFilter.isSelected = false
            print("The value of newFilter is \(newFilter.filter)")

        }
        do {
            try context.save()
        } catch {
            print("*** error saving filters to the context within saveFilters func ***")
        }

        for diet in 0..<self.dietList.count {
            let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
            let newFilter = Filters(entity: entity!, insertInto: context)
            newFilter.categoryTitle = "Diet"
            newFilter.id = dietList[diet]
            newFilter.filter = dietID[diet]
            newFilter.isSelected = false
            print("The value of newFilter is \(newFilter.filter)")

        }
        do {
            try context.save()
        } catch {
            print("*** error saving filters to the context within saveFilters func ***")
        }
        tableView.reloadData()

        for meal in mealList {
            let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
            let newFilter = Filters(entity: entity!, insertInto: context)
            newFilter.categoryTitle = "Meal"
            newFilter.id = meal
            newFilter.filter = meal
            newFilter.isSelected = false
            print("The value of newFilter is \(newFilter.filter)")

        }
        do {
            try context.save()
        } catch {
            print("*** error saving filters to the context within saveFilters func ***")
        }
        
        for dish in typeOfDishList {
            let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
            let newFilter = Filters(entity: entity!, insertInto: context)
            newFilter.categoryTitle = "Dish Type"
            newFilter.id = dish
            newFilter.filter = dish
            newFilter.isSelected = false
            print("The value of newFilter is \(newFilter.filter)")

        }
        do {
            try context.save()
        } catch {
            print("*** error saving filters to the context within saveFilters func ***")
        }
        
        for cuisine in cuisineTypeList {
            let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
            let newFilter = Filters(entity: entity!, insertInto: context)
            newFilter.categoryTitle = "Cuisine"
            newFilter.id = cuisine
            newFilter.filter = cuisine
            newFilter.isSelected = false
            print("The value of newFilter is \(newFilter.filter)")

        }
        do {
            try context.save()
        } catch {
            print("*** error saving filters to the context within saveFilters func ***")
        }

    }

    func saveFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("error saving filters to the context within saveFilters func")
        }
    }

    func loadFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Filters")
        let categorySort = NSSortDescriptor(key: "categoryTitle", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let filterSort = NSSortDescriptor(key: "filter", ascending: true)
        request.sortDescriptors = [categorySort, filterSort]
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            filterList.removeAll()
            for result in results {
                let filterer = result as! Filters
                filterList.append(filterer)
            }
        } catch {
            print("Fetch Failed for filter")
        }

    }
}
