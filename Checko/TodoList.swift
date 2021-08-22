//
//  TodoList.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation

final class TodoList {

    let rowItem0 = CheckListItem()
    var todos: [CheckListItem] = []
    
    init(){
        
        rowItem0.text = "Write your notes below!"
        todos.append(rowItem0)
    }
    
    func newTodoItem() -> CheckListItem {
        
        let item = CheckListItem()
        item.text = "New item"
        todos.append(item)
        return item
    }
    
    func move(item: CheckListItem, to index: Int){
        guard let currentIndex = todos.index(of: item) else { return }
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
