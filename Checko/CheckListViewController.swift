//
//  ViewController.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 18/8/21.
//

import UIKit
import simd

/// Description
final class CheckListViewController: UITableViewController {
    
    /// Our TodoList object. Holds all TodoItems
    var todoList: TodoList
    let maxItemsAllowed = 5
    
    /// Adds an item to our TODO list object
    /// - Parameter sender: The "+" button on UI
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = todoList.todos.count
        if newRowIndex >= maxItemsAllowed {
            return
        } else {
            todoList.newTodoItem()
            let indexPath = IndexPath(row: newRowIndex, section: 0 )
            let indexPaths = [indexPath]
            
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    @IBAction func clearAll(_ sender: Any) {
          
        // Deletes all data from UserPredefs
        todoList.clearTodoList()
        // TODO: Needs to also update the TableView and rows:
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {

        todoList = TodoList()

        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        // WIP: Disallow editing
        //navigationItem.leftBarButtonItem = editButtonItem
    }
// WIP: Disallow editing
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: true)
//        tableView.setEditing(tableView.isEditing, animated: true)
//    }
    /// Overrides numberOfRowsInSection
    /// - Returns: The number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    /// Overrides cellForRowAt: Creates and configures an appropriate cell for the given index path.
    /// - Returns: A cell, our CheckListTableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        
        configureText(cell: cell, with: item)
        configureTimestamp(cell: cell, with: item)
        configureCellStyle(cell: cell, with: item)
        
        return cell
    }
    /// Overrides didSelectRowAt: Tells the delegate a row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) != nil{
            _ = todoList.todos[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    /// Overrides editingStyle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            // Here we're casting the segue.destination ViewController as AddItemTableViewController so I can access the delegate properties.
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        }
        else if segue.identifier == "showItemsGraveyard" {
            
            if let controller = segue.destination as? GraveyardViewController {
                // I should show there the "graveyard items"
            }
            
        }
// WIP: Disallow editing
//        else if segue.identifier == "editItemSegue" {
//            if let addItemViewController = segue.destination as? ItemDetailViewController {
//                // We can get this from the sender, as is the object that was tapped:
//                if let cell = sender as? UITableViewCell,
//                    // now we know where the user taps
//                    let indexPath = tableView.indexPath(for: cell){
//                        let item = todoList.todos[indexPath.row]
//                    addItemViewController.itemToEdit = item
//                    addItemViewController.delegate = self
//                    }
//                }
//            }
        }
    
    func configureText(cell: UITableViewCell, with item: CheckListItem){
        
        if let textCell = cell as? CheckListTableViewCell {
            textCell.todoTextLabel.text = item.text
        }
    }

    func configureTimestamp(cell: UITableViewCell, with item: CheckListItem){
        
        
        if let timestampedCell = cell as? CheckListTableViewCell {
            timestampedCell.itemTimestamp.text = item.timestampString
            
        }
    
    }
    // Configures the cell style based on the remaining time from a CheckListItem
    func configureCellStyle(cell: UITableViewCell, with item: CheckListItem){
        
        if let cell = cell as? CheckListTableViewCell {
            
            // General styles:
            //cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            
            // Background color based on how far is from expiration:
            if todoList.checkRemainingTime(item: item) == .far {
                cell.backgroundColor = .white
            }
            else if todoList.checkRemainingTime(item: item) == .medium {
                cell.backgroundColor = .systemYellow
            }
            else if todoList.checkRemainingTime(item: item) == .close {
                cell.backgroundColor = .systemOrange
            }
            else if todoList.checkRemainingTime(item: item) == .closest {
                cell.backgroundColor = .systemRed
            }
            else {
                cell.backgroundColor = .systemGray2
            }
        }
    }
}

// Implement the new protocol:
extension CheckListViewController: AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(controller: ItemDetailViewController) {
        // pop the view controller out of the stack:
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = todoList.todos.count - 1
        //todoList.todos.append(item) //text    String?    nil    none
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        // Update the TableView:
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
            
        if let index = todoList.todos.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(cell: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        
    }
}

