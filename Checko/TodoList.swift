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
    
    enum deadline { case closest , close, medium, far}
    
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
        // Assign:
        item.objectCreationTimestamp = timestamp
        print("Saving objectCreationTimestamp: ")
        print(timestamp)
        
        let dateFormatter = DateFormatter()
        //let deadline = timestamp.addingTimeInterval(86400) // 86400 seconds in 1 day.
        // 1 - Format the I/O and pass the deadline to each item:
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        item.timestampString = dateFormatter.string(from: timestamp)
        
        
        
        // 2 - Assign note & timestamp:
        savedElement[0] = item.text
        savedElement[1] = item.timestampString
        
        // DEBUG
        //print("Saving item: \(savedElement)")
        //print("Contents of current list: \(storedDataInUserDefaults)")
        
        // 3 - Saving to memory
        storedDataInUserDefaults.append(savedElement)
        UserDefaults.standard.setValue(storedDataInUserDefaults, forKey: "SavedData")
        
    }
    
    func checkRemainingTime(item: CheckListItem) -> deadline {
        
        let currentTime = Date()
        // DEBUG:
//        print("item.objectCreationTimestamp:")
//        print(item.objectCreationTimestamp)
//        print("current time")
//        print(currentTime)
//        print("item.timstampstring")
//        print(item.timestampString)
        
        // 1 . Convert my timestamp String (saved into UserDefaults) back to a Date()
        guard let itemTimestamp = item.timestampString.toDate() else {
            print(" Failed to cast to yyyy-MM-dd HH:mm:ss")
            return .far
        }
        
        // 2. Get time difference from now to my saved timestamp. Returns the difference in seconds. 24h = 86400 seconds
        let delta = currentTime.timeIntervalSince(itemTimestamp)
        
        // Now that I have a delta, I can return different styles ( TODO, remove magical numbers 24h = 86400 seconds )
        if delta >= Constants.farWarning {
            return .far
        }
        else if delta < Constants.farWarning && delta > Constants.mediumWarning {
            return .medium
        }
        else if delta < Constants.closeWarning && delta > Constants.closestWarning {
            return .close
        }
        else {
            return .closest
        }
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
        print("Clearing all list")
//        for i in allItems {
//            i.remove
//        }
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}
