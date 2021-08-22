//
//  TodoList.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation
//import UIKit

final class TodoList {
    
    var rowItem0 = CheckListItem()
    var test_rowItemFromUserDefaults : [String]
    var todos: [CheckListItem] = []
    
    init(){
        
        rowItem0.text = "Write your notes below!"
        todos.append(rowItem0)
        
        // Temporary DEBUG: Uncomment and execute to delete User Defaults:
        UserDefaults.resetStandardUserDefaults()
        
        // Initial data load from Userdefaults:
        // TODO: Move into a function.
        test_rowItemFromUserDefaults = UserDefaults.standard.stringArray(forKey:"SavedData") ?? []
        for i in test_rowItemFromUserDefaults {
            let item = CheckListItem()
            item.text = i
            todos.append(item)
        }
    }
    
    func newTodoItem() -> CheckListItem {
        
        let item = CheckListItem()
        item.text = "New item"
        todos.append(item)
        return item
    }
    
    /// Saves to UserDefaults
    /// - Parameter item: TODO item.
    func saveTodoItem(item: CheckListItem){
        
        test_rowItemFromUserDefaults.append(item.text)
        UserDefaults.standard.setValue(test_rowItemFromUserDefaults, forKey: "SavedData")
        
    }
    
    func move(item: CheckListItem, to index: Int){
        guard let currentIndex = todos.firstIndex(of: item) else { return }
        todos.remove(at: currentIndex) // remove from previous loc
        todos.insert(item, at: index) // add to new loc
    }
    
    func setRandomItem() -> CheckListItem {
        
        let item = CheckListItem()
        let itemsArray = ["this", "is", "a", "random", "array"]
        let randomIndex = Int.random(in: 1..<itemsArray.count)
        item.text = itemsArray[randomIndex]
        item.checked = false
        todos.append(item)
        return item
    }
}
