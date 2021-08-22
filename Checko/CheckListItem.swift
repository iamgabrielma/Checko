//
//  CheckListItem.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation

final class CheckListItem: NSObject {
    
    //@IBOutlet weak var textField: UITextField!
    var text = ""
    var checked = false
    
    
    /// Description
    func toggleChecked() {
        checked = !checked
    }
}
