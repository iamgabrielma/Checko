//
//  FailedItemListViewController.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 25/8/21.
//

import Foundation
import UIKit

final class GraveyardViewController: UITableViewController {
    
    var graveyardTodoList: GraveyardTodoList
    
    required init?(coder aDecoder: NSCoder) {

        graveyardTodoList = GraveyardTodoList()

        super.init(coder: aDecoder)
        
    }
    
    @IBAction func checkItemGraveyard(_ sender: Any) {
        
        // Tapity-tap, empty for now
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Overrides numberOfRowsInSection
    /// - Returns: The number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graveyardTodoList.graveyardTodos.count
    }
    
    /// Overrides cellForRowAt: Creates and configures an appropriate cell for the given index path.
    /// - Returns: A cell, our CheckListTableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        let item = graveyardTodoList.graveyardTodos[indexPath.row]
        
        configureText(cell: cell, with: item)
        
        return cell
    }
    /// Overrides didSelectRowAt: Tells the delegate a row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) != nil{
            _ = graveyardTodoList.graveyardTodos[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func configureText(cell: UITableViewCell, with item: CheckListItem){
        
        cell.textLabel?.text = item.text
    }
}
