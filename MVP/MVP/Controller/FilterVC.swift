//
//  filterVC.swift
//  MVP
//
//  Created by Sean Murphy on 10/9/21.
//

import UIKit
import CoreData

//var filterList = [Filters]()
var loaded = false

class FilterVC: UITableViewController {
    
    var filterList = [Filters]()
//    let filterContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var keepCount = 0
    var screenLoad = true
    var previousCategory = "None"
    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension", "Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]
    
//    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free"]
//    var allergyID = ["alcohol-free", "immuno-supportive", "celery-free"]

    var allergyID = ["alcohol-free", "immuno-supportive", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free", "gluten-free", "keto-friendly", "gluten-free", "keto-friendly", "kidney-friendly", "kosher", "low-potassium", "lupine-free", "Mediterranean", "mustard-free", "low-fat-abs", "No-oil-added", "low-sugar", "paleo", "peanut-free", "pecatarian", "pork-free", "red-meat-free", "seasame-free", "shellfish-free", "soy-free", "sugar-conscious", "tree-nut-free", "vegan", "vegetarian", "wheat-free"]
//
//    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]
//
//    var dietID = ["balanced", "high-fiber", "high-protein", "low-carb", "low-fat", "low-sodium"]
//
//    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]
//
//    var typeOfDishList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]
//
//    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]

    var countingTotal = 0


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
        if filterList[indexPath.row].isSelected == nil {
            filterList[indexPath.row].isSelected = false
        }
        if filterList[indexPath.row].categoryTitle != previousCategory {
            cell.filterLabel.text = filterList[indexPath.row].categoryTitle
            cell.backgroundColor = .red
        }
        cell.filterLabel.text = filterList[indexPath.row].filter

        cell.isSelectedImage.image = filterList[indexPath.row].isSelected ? .checkmark : .none
        
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
        // look at the core data for this entity and retrieve info and get the number of allergies and it is equal to the number of allergies in the table if it returns true skip addFilters
       
        return
    }

    func addFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            for allergy in 0..<self.allergyList.count {
                let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
                let newFilter = Filters(entity: entity!, insertInto: context)
                self.countingTotal += 1
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
        tableView.reloadData()

    }

    func saveFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        keepCount += 1
        do {
            try context.save()
            print("I have been called \(keepCount) ")
        } catch {
            print("error saving filters to the context within saveFilters func")
        }
    }

    func loadFilters() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Filters")
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
