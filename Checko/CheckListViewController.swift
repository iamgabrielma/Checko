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
        // Needs to also update the rows:
        // TODO: Fatal error: *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'attempt to delete row 2 from section 0 which only contains 2 rows before the update'
//        let existingRowIndex = todoList.todos.count
//        let indexPath = IndexPath(row: existingRowIndex, section: 0 )
//        let indexPaths = [indexPath]
//        tableView.deleteRows(at: indexPaths, with: .automatic)
//        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {

        todoList = TodoList()

        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Timer functions
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
        configureTimestamp(cell: cell, with: item)
        configureCellStyle(cell: cell, with: item)
        
        return cell
    }
    /// Overrides didSelectRowAt: Tells the delegate a row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            //item.toggleChecked() deprecated.
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
        
        if let textCell = cell as? CheckListTableViewCell {
            textCell.todoTextLabel.text = item.text
        }
    }

    func configureTimestamp(cell: UITableViewCell, with item: CheckListItem){
        
        
        if let timestampedCell = cell as? CheckListTableViewCell {
            timestampedCell.itemTimestamp.text = item.timestampString
            //timestampedCell.itemTimestamp.text = String(NSDate().timeIntervalSince1970)
            //timestampedCell.itemTimestamp.text = String("\(item.timeRemaining):00h")
            
        }
    
    }
    
    func configureCellStyle(cell: UITableViewCell, with item: CheckListItem){
        
        if let cell = cell as? CheckListTableViewCell {
            if todoList.checkRemainingTime(item: item) == .far {
                cell.backgroundColor = .systemGray2
            }
            else if todoList.checkRemainingTime(item: item) == .medium {
                cell.backgroundColor = .systemGray3
            }
            else if todoList.checkRemainingTime(item: item) == .close {
                cell.backgroundColor = .systemGray4
            }
            else if todoList.checkRemainingTime(item: item) == .closest {
                cell.backgroundColor = .systemGray5
            }
            else {
                cell.backgroundColor = .white
            }
        }
        //let currentTime = Constants.currentTime
        //print("Current time: \(Constants.currentTime)")
        /* UTC
         Current time: 2021-08-24 08:19:30 +0000
         Current time: 2021-08-24 08:19:30 +0000
         Current time: 2021-08-24 08:19:30 +0000
         **/
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.dateFormat = "MM-dd HH:mm"
        //item.timestampString = dateFormatter.string(from: currentTime)
        //let now = dateFormatter.string(from: currentTime)
        //print(item.timestampString)
        /*
         08-24 10:34
         08-24 10:34
         08-24 10:34
         */
        
        //if let cell = cell as? CheckListTableViewCell {
            //let timeDiff = currentTime.timeIntervalSince(item.timestamp)
            //print(timeDiff)
            // wut 0.34887802600860596
            //let fmt = ISO8601DateFormatter()
            // TODO: Need to go back and change these to use this format instead:
            //guard let fromDate = fmt.date(from: item.timestampString) else { return }
            //guard let toDate = fmt.date(from: now) else { return }
            //let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate)
            //print("Time diff: \(diffComponents)")
        //}
        
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

