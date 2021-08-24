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
    var storedDataInUserDefaults : [[String]]
    var savedElement: [String]
    // Our TODO list
    var todos: [CheckListItem] = []
    
    init(){
        
        initialRowItem.text = "Write your notes below!"
        initialRowItem.timestampString = "2021-08-23 19:48:37"
        todos.append(initialRowItem)
        
        // Initial data load from UserDefaults:
        storedDataInUserDefaults = UserDefaults.standard.array(forKey:"SavedData") as? [[String]] ?? [["", ""]]
        print("Init() Load contents of current list: \(storedDataInUserDefaults)")
        
        for eachItem in storedDataInUserDefaults {
            let item = CheckListItem()
            item.text = eachItem[0] // Note
            item.timestampString = eachItem[1] // Timestamp
            todos.append(item)
        }
        // WIP:
        savedElement = ["", ""]
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
        
        // Each CheckListItem has 2 parts, the String that is saved as a note, and a timestamp:
        let timestamp = Date()
        let dateFormatter = DateFormatter()
        let deadline = timestamp.addingTimeInterval(86400) // 86400 seconds in 1 day.
        // 1 - Format the I/O and pass the deadline to each item:
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "MM-dd HH:mm"
        //item.timestamp = dateFormatter.string(from: timestamp)
        item.timestampString = dateFormatter.string(from: deadline)
        
        
        
        // 2 - Assign note & timestamp:
        savedElement[0] = item.text
        savedElement[1] = item.timestampString
        
        // DEBUG
        print("Saving item: \(savedElement)")
        print("Contents of current list: \(storedDataInUserDefaults)")
        
        // 3 - Saving to memory
        storedDataInUserDefaults.append(savedElement)
        UserDefaults.standard.setValue(storedDataInUserDefaults, forKey: "SavedData")
        
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
