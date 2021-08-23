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
    // Our TODO list
    var todos: [CheckListItem] = []
    
    init(){
        
        initialRowItem.text = "Write your notes below!"
        todos.append(initialRowItem)
        
        // Initial data load from UserDefaults:
        rowItemInUserDefaults = UserDefaults.standard.stringArray(forKey:"SavedData") ?? []
        for i in rowItemInUserDefaults {
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
        
        rowItemInUserDefaults.append(item.text)
        UserDefaults.standard.setValue(rowItemInUserDefaults, forKey: "SavedData")
        
    }
    
    func move(item: CheckListItem, to index: Int){
        guard let currentIndex = todos.firstIndex(of: item) else { return }
        todos.remove(at: currentIndex) // remove from previous loc
        todos.insert(item, at: index) // add to new loc
    }
    
    func clearTodoList(){
        
        //let allItems = UserDefaults.standard.stringArray(forKey:"SavedData") ?? []
        let allItems = UserDefaults.standard
        //let keyValue = allItems.stringArray(forKey: "SavedData")
        allItems.removeObject(forKey: "SavedData")
//        for i in allItems {
//            i.remove
//        }
    }
}
