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
        //dateFormatter.dateFormat = "MM-dd HH:mm"
        //item.timestamp = dateFormatter.string(from: timestamp)
        item.timestampString = dateFormatter.string(from: timestamp)
        
        
        
        // 2 - Assign note & timestamp:
        savedElement[0] = item.text
        savedElement[1] = item.timestampString
        // Problem: If I don't use dateformatter, this is not being saved: [["Test", ""], ["Melón", ""], ["Sandia", ""], ["Mas sandia", ""]] --> after using the formatter: Saving item: ["Test", "2021-08-24 11:18:05"]
        
        // DEBUG
        print("Saving item: \(savedElement)")
        print("Contents of current list: \(storedDataInUserDefaults)")
        
        // 3 - Saving to memory
        storedDataInUserDefaults.append(savedElement)
        UserDefaults.standard.setValue(storedDataInUserDefaults, forKey: "SavedData")
        
    }
    
    func checkRemainingTime(item: CheckListItem) -> deadline {
        
        let currentTime = Date()
        print("item.objectCreationTimestamp:")
        print(item.objectCreationTimestamp) // --> This is wrong, is returning the current time.
        print("current time")
        print(currentTime) // 2021-08-24 11:53:21 +0000
        print("item.timstampstring")
        print(item.timestampString) // --> correct ( despite not being UTC but local ) . I need to compare this with curent time.
        
        // No tengo que comparar 2 fechas guardadas, si tengo la fecha actual:
        // 1 . Convierto my timestamp String to Dates()
        guard let date1 = item.timestampString.toDate() else {
            print(" Failed to cast to yyyy-MM-dd HH:mm:ss")
            return .far
        }
        
        let comparison = date1.compare(currentTime) // Hasta este punto tengo fechas diferentes, va bien.
        print(date1, currentTime, comparison) // NSComparisonResult
        let delta = currentTime.timeIntervalSince(date1)
        print("delta:")
        print(delta) // <-- Solved, in seconds.
        
        // Now that I have a delta, I can return different styles:
        // 24h = 86400 seconds.
        if delta >= 80000 {
            return .far
        }
        else if delta < 80000 && delta > 40000 {
            return .medium
        }
        else {
            return .close
        }
        //return .far
        
        
        //print("Time now is: \(currentTime)")"
        
        // 1 - Cuando guardo un item, tengo esto: Saving item: ["Melón", "2021-08-24 13:51:11"] . Siendo 2021-08-24 13:51:11 el item.timestamp.
        
//        let calendar = Calendar.current
//
//        let itemDate = item.timestamp // Date()
//        let timeNow = Date()
//
//        let itemYear = calendar.component(.year, from: itemDate)
//        let itemMonth = calendar.component(.month, from: itemDate)
//        let itemDay = calendar.component(.day, from: itemDate)
//        let itemHour = calendar.component(.hour, from: itemDate)
//        let itemMinute = calendar.component(.minute, from: itemDate)
        
        //var itemDateComponents = DateComponents()
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy"
        //let itemYear = dateFormatter.string(from: itemDate)
        //let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: timeNow)
//        let year = components.year
//        let month = components.month
//        let day = components.day
//        let hour = components.hour
//        let minute = components.minute
//
//        let currentTime = DateComponents(calendar: .current, year: year, month: month, day: day, hour: hour, minute: minute).date!
        
        // Fill this up from saved component.
//        let itemTime = DateComponents(calendar: .current,
//                                      year: itemYear,
//                                      month: itemMonth,
//                                      day: itemDay,
//                                      hour: itemHour,
//                                      minute: itemMinute).date!
        
        //let minutes = currentTime.minutes(from: itemTime) // +7 minutes at 13:37. So current time is 7 minutes away from itemTime
        // 24 ok
        //let minutes = date2.minutes(from: date1) // 1440 ok
        
        //print(hours, minutes)
        //print(minutes) // 1062759564 mmmmmm
        
//        let currentTimeString = Constants.currentTimeString
//
//        let fmt = ISO8601DateFormatter() // Use this class to create ISO 8601 representations of dates and create dates from text strings in ISO 8601 format.
//        let fromDate = fmt.date(from: item.timestampString)
//        let toDate = fmt.date(from: currentTimeString)
//
//        //print(timeDiff)
//        // wut 0.34887802600860596
//        //let fmt = ISO8601DateFormatter()
//        // TODO: Need to go back and change these to use this format instead:
//        //guard let fromDate = fmt.date(from: item.timestampString) else { return }
//        //guard let toDate = fmt.date(from: now) else { return }
//        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: fromDate ?? Constants.currentTime, to: toDate ?? Constants.currentTime.addingTimeInterval(86400))
//        //print("Time diff: \(diffComponents)")
//        // Nope -> Time diff: hour: 0 minute: 0 isLeapMonth: false
//        //let timeDiff = Constants.currentTime.timeIntervalSince(item.timestamp) // 0.4772489070892334
//        let timeDiff = item.timestamp.timeIntervalSinceNow // -0.5026559829711914
//        print(diffComponents) // hour: 24 minute: 0 isLeapMonth: false
//        print(timeDiff) // -0.3649529218673706

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
