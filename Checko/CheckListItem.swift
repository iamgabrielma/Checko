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
    let timeRemaining = 24
    let timestamp = Date()
    // Test to save this to UserDefaults:
    var textAndRemainingTime: (String, Int) = ("", 0)
    
    
    //let timestamp = NSDate().timeIntervalSince1970
    //let twentyFour: Timer
    
//    func checkDiff(){
//        
//    }
    /// Description
    func toggleChecked() {
        checked = !checked
    }
}
