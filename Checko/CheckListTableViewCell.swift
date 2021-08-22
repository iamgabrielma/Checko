//
//  CheckListTableViewCell.swift
//  Checko
//
//  Created by Gabriel Maldonado Almendra on 21/8/21.
//

import UIKit

final class CheckListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var todoTextLabel: UILabel!
    @IBOutlet weak var itemTimestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
