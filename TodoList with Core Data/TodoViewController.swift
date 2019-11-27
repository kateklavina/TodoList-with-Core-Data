//
//  TodoViewController.swift
//  TodoList with Core Data
//
//  Created by Dace Laizane on 22/11/2019.
//  Copyright © 2019 Kate Klavina. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
 
    override func viewDidLoad() {
 
        super.viewDidLoad()
 
       loadItems()
 
    }
    
    var items = [Items]()
     
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return items.count
       }
    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
           let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
           let item = items[indexPath.row]
           cell.textLabel?.text = item.name
           cell.accessoryType = item.completed ? .checkmark : .none
    
           return cell
    
       }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
           var textField = UITextField()
    
           let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
           let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
    
               let newItem = Items(context: self.context)
    
    
               newItem.name = textField.text!
    
               self.items.append(newItem)
    
               self.saveCategories()
    
           }
    
           alert.addAction(action)
    
    
           alert.addTextField { (field) in
    
               textField = field
    
               textField.placeholder = "Add a New Item"
    
           }
    
           present(alert, animated: true, completion: nil)
    
       }



  func saveCategories(){
 
        do{
 
            try context.save()
 
        }catch {
 
            print("Error saving item with \(error)")
 
        }
 
        tableView.reloadData()
 
    }

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            tableView.deselectRow(at: indexPath, animated: true)
     
            items[indexPath.row].completed = !items[indexPath.row].completed
     
            saveCategories()
     
        }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     
            return true
     
        }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
           if (editingStyle == .delete) {
    
               let item = items[indexPath.row]
               items.remove(at: indexPath.row)
               context.delete(item)
    
               do {
                   try context.save()
               } catch {
                   print("Error deleting items with \(error)")
               }
               tableView.deleteRows(at: [indexPath], with: .automatic)  //includes updating UI so reloading is not necessary
           }
    }
    func loadItems(){
     
            let request: NSFetchRequest<Items> = Items.fetchRequest()
     
            do {
     
            items = try context.fetch(request)
     
            }catch {
     
                print("Error fetching data from context \(error)")
     
            }
     
            tableView.reloadData()
        }
}
