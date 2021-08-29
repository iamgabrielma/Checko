//
//  GraveyardTodoList.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 25/8/21.
//

import Foundation

final class GraveyardTodoList {
    
    var welcomeRowItem = CheckListItem()
    var graveyardTodos: [CheckListItem] = []
    
    init(){
        welcomeRowItem.text = "The Graveyard of Shame"
        graveyardTodos.append(welcomeRowItem)
        
    }
}

