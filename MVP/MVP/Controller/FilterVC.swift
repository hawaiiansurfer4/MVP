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
    
    var filterModel = FilterModel()
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterModel.addFilters()
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
        cell.accessoryType = filterList[indexPath.row].isSelected! ? .checkmark : .none
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
}
