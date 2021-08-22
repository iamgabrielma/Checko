//
//  TodoList.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation
//import UIKit

final class TodoList {
    
    var initialRowItem = CheckListItem()
    var rowItemInUserDefaults : [String]
    var rowItemsInUserDefaults : [String: Int]
    // Our TODO list
    var todos: [CheckListItem] = []
    
    init(){
        
        initialRowItem.text = "Write your notes below! You can add up to 5 tasks"
        todos.append(initialRowItem)
        
        // Temporary DEBUG: Uncomment and execute to delete User Defaults:
        // UserDefaults.resetStandardUserDefaults()
        
        // Initial data load from UserDefaults:
        rowItemInUserDefaults = UserDefaults.standard.stringArray(forKey:"SavedData") ?? []
        for i in rowItemInUserDefaults {
            let item = CheckListItem()
            item.text = i
            todos.append(item)
        }
        
        // Initial data load from Tuple UserDefaults:
        rowItemsInUserDefaults = UserDefaults.standard.array(forKey: "Newdata") as? [String: Int] ?? ["" : 0]
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
        
        rowItemInUserDefaults.append(item.text)
        UserDefaults.standard.setValue(rowItemInUserDefaults, forKey: "SavedData")
        // Trying alternative TUPLE:
        UserDefaults.standard.setValue([item.text, 24], forKey: "TupleData")
        
    }
    
    func move(item: CheckListItem, to index: Int){
        guard let currentIndex = todos.firstIndex(of: item) else { return }
        todos.remove(at: currentIndex) // remove from previous loc
        todos.insert(item, at: index) // add to new loc
    }
    
//    func setRandomItem() -> CheckListItem {
//
//        let item = CheckListItem()
//        let itemsArray = ["this", "is", "a", "random", "array"]
//        let randomIndex = Int.random(in: 1..<itemsArray.count)
//        item.text = itemsArray[randomIndex]
//        item.checked = false
//        todos.append(item)
//        return item
//    }
}
