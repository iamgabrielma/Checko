//
//  ViewController.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 18/8/21.
//

import UIKit

class CheckListViewController: UITableViewController {
    
    /// Our TodoList object. Holds all TodoItems
    var todoList: TodoList
    
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodoItem()
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        
        configureText(cell: cell, with: item)
        configureCheckMark(cell: cell, with: item)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            configureCheckMark(cell: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row)
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
        
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    func configureCheckMark(cell: UITableViewCell, with item: CheckListItem){
        
        guard let checkmark = cell.viewWithTag(1001) as? UILabel else { return }
        
        if item.checked {
            checkmark.text = "✅"
        } else {
            checkmark.text = ""
        }
        item.toggleChecked()
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

