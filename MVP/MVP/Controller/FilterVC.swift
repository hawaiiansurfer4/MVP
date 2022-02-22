//
//  filterVC.swift
//  MVP
//
//  Created by Sean Murphy on 10/9/21.
//

import UIKit
import CoreData

//var filterList = [Filters]()

class FilterVC: UITableViewController {
    
    var filterList = [Filters]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var keepCount = 0
    var firstLoad = true
    var screenLoad = true
    var previousCategory = "None"
    var allergyList = ["Alcohol-free", "Immune-Supportive", "Celery-free", "Crustcean-free", "Dairy", "Dietary Approaches to Stop Hypertension", "Eggs", "Fish", "FODMAP free", "Gluten", "Keto", "Kidney friendly", "Kosher", "Low potassium", "Lupine-free", "Mediterranean", "Mustard-free", "Low-fat-abs", "No oil added", "No-sugar", "Paleo", "Peanuts", "Pescatarian", "Pork-free", "Red meat-free", "Sesame-free", "Shellfish", "Soy", "Sugar-conscious", "Tree Nuts", "Vegan", "Vegetarian", "Wheat-free"]

    var allergyID = ["alcohol-free", "immuno-supportive", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free", "gluten-free", "keto-friendly", "gluten-free", "keto-friendly", "kidney-friendly", "kosher", "low-potassium", "lupine-free", "Mediterranean", "mustard-free", "low-fat-abs", "No-oil-added", "low-sugar", "paleo", "peanut-free", "pecatarian", "pork-free", "red-meat-free", "seasame-free", "shellfish-free", "soy-free", "sugar-conscious", "tree-nut-free", "vegan", "vegetarian", "wheat-free"]

    var dietList = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]

    var dietID = ["balanced", "high-fiber", "high-protein", "low-carb", "low-fat", "low-sodium"]

    var mealList = ["Breakfast", "Lunch", "Dinner", "Snack", "Teatime"]

    var typeOfDishList = ["Alcohol-cocktail", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Drinks", "Desserts", "Egg", "Main course", "Omelet", "Pancake", "Preps", "Preserve", "Salad", "Sandwhiches", "Soup", "Starter"]

    var cuisineTypeList = ["Asmerican", "Asian", "British", "Caribbean", "Central Europe", "Chinese", "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]

    var countingTotal = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        addFilters()
        loadFilters()
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
//        if(screenLoad) {
//            screenLoad = false
//            loadFilters()
//        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
        if filterList[indexPath.row].isSelected == nil {
            filterList[indexPath.row].isSelected = false
        }
        if filterList[indexPath.row].categoryTitle != previousCategory {
            cell.filterLabel.text = filterList[indexPath.row].categoryTitle
//            cell.isSelectedImage = .none
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

    func addFilters() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)!
        let newFilter = Filters(entity: entity, insertInto: context)

        if self.firstLoad {
            self.firstLoad = false
            var count = 0
            for allergy in 0..<self.allergyList.count {
                self.countingTotal += 1
                newFilter.categoryTitle = "Allergies"
                newFilter.id = self.allergyID[count]
                newFilter.filter = self.allergyList[allergy]
                newFilter.isSelected = false
                saveFilters()
                do {
                    try context.save()
                    filterList.append(newFilter)
                } catch {
                    print("error saving filters to the context within saveFilters func")
                }

                count += 1
            }
            count = 0
//            for diet in self.dietList {
//                self.countingTotal += 1
//                newFilter.filter = diet
//                newFilter.categoryTitle = "Diet"
//                newFilter.isSelected = false
//                newFilter.id = self.dietID[count]
//                count += 1
//                saveFilters()
//            }
//            count = 0
//            for meal in self.mealList {
//                self.countingTotal += 1
//                newFilter.categoryTitle = "Meal"
//                newFilter.filter = meal
//                newFilter.id = meal
//                newFilter.isSelected = false
//                saveFilters()
//            }
//            for dish in self.typeOfDishList {
//                self.countingTotal += 1
//                newFilter.categoryTitle = "Dish Type"
//                newFilter.filter = dish
//                newFilter.id = dish
//                newFilter.isSelected = false
//                saveFilters()
//            }
//            count = 0
//            for cuisine in self.cuisineTypeList {
//                self.countingTotal += 1
//                newFilter.categoryTitle = "Cuisine Type"
//                newFilter.filter = cuisine
//                newFilter.id = cuisine
//                newFilter.isSelected = false
//                saveFilters()
//            }

        }
    }

    func saveFilters() {

        keepCount += 1
//        print("I have been called \(keepCount) ")
//        do {
//            try context.save()
//        } catch {
//            print("error saving filters to the context within saveFilters func")
//        }
    }

    func loadFilters() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Filters")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            filterList.removeAll()
            for result in results {
                let filters = result as! Filters
                filterList.append(filters)
            }
        } catch {
            print("Fetch Failed for filter")
        }

    }
}
