//
//  CheckListItem.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 19/8/21.
//

import Foundation

final class CheckListItem: NSObject, Codable {
    
    //@IBOutlet weak var textField: UITextField!
    var text = ""
    var checked = false
    let timestamp = NSDate().timeIntervalSince1970
    
//    init(){
//        self.timestamp = NSDate().timeIntervalSince1970
//    }
    
    
    /// Description
    func toggleChecked() {
        checked = !checked
    }
}
