//
//  CheckListItem.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation

class CheckListItem: NSObject {
    
    //@IBOutlet weak var textField: UITextField!
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
