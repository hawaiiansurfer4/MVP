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
    
//    var filterModel = FilterModel()

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

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filterModel.addFilters()
        addFilters()
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
        if(screenLoad) {
            screenLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Filters", in: context)
        let newFilter = Filters(entity: entity!, insertInto: context)
        
        DispatchQueue.main.async {
            if self.firstLoad {
                self.firstLoad = false
//                appFirstLoad = false
                var count = 0
                for allergy in self.allergyList {
                    newFilter.categoryTitle = "Allergies"
                    newFilter.id = self.allergyID[count]
                    newFilter.filter = allergy
                    newFilter.isSelected = false
//                    self.saveFilters(context)
                    do {
                        try context.save()
                    } catch {
                        print("Error saving filters")
                    }

                    count += 1
                }
//                self.saveFilters(context)
                count = 0
                for diet in self.dietList {
                    newFilter.filter = diet
                    newFilter.categoryTitle = "Diet"
                    newFilter.isSelected = false
                    newFilter.id = self.dietID[count]
//                    self.saveFilters(context)
                    count += 1
                    do {
                        try context.save()
                    } catch {
                        print("Error saving filters")
                    }

                }
//                self.saveFilters(context)
                count = 0
                for meal in self.mealList {
                    newFilter.categoryTitle = "Meal"
                    newFilter.filter = meal
                    newFilter.id = meal
                    newFilter.isSelected = false
//                    self.saveFilters(context)
                    do {
                        try context.save()
                    } catch {
                        print("Error saving filters")
                    }

                }
//                self.saveFilters(context)
                for dish in self.typeOfDishList {
                    newFilter.categoryTitle = "Dish Type"
                    newFilter.filter = dish
                    newFilter.id = dish
                    newFilter.isSelected = false
//                    self.saveFilters(context)
                    do {
                        try context.save()
                    } catch {
                        print("Error saving filters")
                    }

                }
//                self.saveFilters(context)
                count = 0
                for cuisine in self.cuisineTypeList {
                    newFilter.categoryTitle = "Cuisine Type"
                    newFilter.filter = cuisine
                    newFilter.id = cuisine
                    newFilter.isSelected = false
//                    self.saveFilters(context)
                    do {
                        try context.save()
                    } catch {
                        print("Error saving filters")
                    }

                }
//                self.saveFilters(context)
//        }
        
//            self.saveFilters(context)
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
//    func saveFilters(_ context: NSManagedObjectContext) {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving filters")
//        }
    }
}
