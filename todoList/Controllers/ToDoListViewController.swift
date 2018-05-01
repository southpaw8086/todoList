//
//  ViewController.swift
//  todoList
//
//  Created by Nitin Chauhan on 4/27/18.
//  Copyright © 2018 Nitin Chauhan. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
//    var itemArray1 = ["Abc","xyz","hello","a","b","c","d","e","f","g","h","i","j","k","l","aaa","bbb","ccc","ddd","a1","b1","c1","c2","c3"]
    //creating a Plist
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(dataFilePath)
       loadItems()

    }

    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        //Using Ternary Operator
        //value = condition ? valueIfTrue:valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add New Items
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Do List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user Click The Add Item Button on Our Alert
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK : Model Manupulation Methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error Encoding Item Array,\(error)")
        }
        self.tableView.reloadData()

    }
    
    func loadItems()
    {
       if let data = try? Data(contentsOf: dataFilePath!){
           let decoder = PropertyListDecoder()
        do{
          itemArray = try decoder.decode([Item].self, from: data)
        }
        catch{
            print("Error decoding Item Array,\(error)")
        }
        }
    }

}

