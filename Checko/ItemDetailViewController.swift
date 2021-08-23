//
//  AddItemTableViewController.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 20/8/21.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    // Any ViewController that wants to get a new CheckListItem back, has to implement this protocol
    
    // Notified the callee that the user cancelled the "add" action.
    func addItemViewControllerDidCancel(controller: ItemDetailViewController)
    // Call when the item is created
    func addItemViewController(controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
    
    func addItemViewController(controller: ItemDetailViewController, didFinishEditing item: CheckListItem)
}

final class ItemDetailViewController: UITableViewController {
    
    weak var delegate: AddItemViewControllerDelegate?
    // Passing data between views:
    weak var todoList: TodoList?
    weak var itemToEdit: CheckListItem?

    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(controller: self)
    }
    @IBAction func done(_ sender: Any) {
        // edit case
        if itemToEdit != nil {
            if let item = itemToEdit, let text = textField.text {
                item.text = text
                delegate?.addItemViewController(controller: self, didFinishEditing: item)
            }
        } else {
            // add case
            //navigationController?.popViewController(animated: true)
            //let tempItem = CheckListItem()
            if let item = todoList?.newTodoItem() {
                if let textFieldText = textField.text {
                    item.text = textFieldText
                }
                //item.checked = false deprecated
                delegate?.addItemViewController(controller: self, didFinishAdding: item)
                todoList?.saveTodoItem(item: item)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit item"
            textField.text = item.text
            addBarButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        
        // Before we implement a method I can tell the TextField I'm becoming a delegate of it, this is one way:
        //textField.delegate = self

    }
    // Let's make the keyboard appear as soon as we have the editing view, rather than make the user to tap on the row first.
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    // Determines wether the row can be selected or not, so. This way when the keyboard is out, we can't tap the table.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// Problem: We want the text field to go away when the user taps "done" after writing their note, I want to resign that first-responder status.
// Solution: A way to react to textfield events is becoming a delegate of the textfield, we can implement a textfield protocol for this.
extension ItemDetailViewController: UITextFieldDelegate {
    
    // Method that is called when use taps "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    // Method that is called when user taps character on keyboard, before is actually refleted on screen.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // If either of these return nil, we return out of the method:
        guard let oldText = textField.text,
              let stringRange = Range(range, in: oldText) else {
            return false
        }
        // The one the user is actually typing in the keyboard:
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
        
        return true
    }
    
}
