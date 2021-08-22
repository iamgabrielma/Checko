//
//  ViewController.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 18/8/21.
//

import UIKit

/// <#Description#>
final class CheckListViewController: UITableViewController {
    
    /// Our TodoList object. Holds all TodoItems
    var todoList: TodoList
    
    /// Adds an item to our TODO list object
    /// - Parameter sender: The "+" button on UI
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = todoList.todos.count
        let item = todoList.newTodoItem()
        //_ = todoList.setRandomItem()
        let indexPath = IndexPath(row: newRowIndex, section: 0 )
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    required init?(coder aDecoder: NSCoder) {

        todoList = TodoList()

        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
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
        configureCheckMark(cell: cell, with: item)
        
        return cell
    }
    /// Overrides didSelectRowAt: Tells the delegate a row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            item.toggleChecked()
            configureCheckMark(cell: cell, with: item)
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
        } else if segue.identifier == "editItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                // We can get this from the sender, as is the object that was tapped:
                if let cell = sender as? UITableViewCell,
                    // now we know where the user taps
                    let indexPath = tableView.indexPath(for: cell){
                        let item = todoList.todos[indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self
                    }
                }
            }
        }
    
    func configureText(cell: UITableViewCell, with item: CheckListItem){
        
        if let checkMarkCell = cell as? CheckListTableViewCell {
            checkMarkCell.todoTextLabel.text = item.text
        }
    }
    
    func configureCheckMark(cell: UITableViewCell, with item: CheckListItem){
        
        guard let checkMarkCell = cell as? CheckListTableViewCell else {
            return
        }
        
        if item.checked {
            checkMarkCell.checkMarkLabel.text = "✅"
        } else {
            checkMarkCell.checkMarkLabel.text = ""
        }
        //item.toggleChecked()
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

