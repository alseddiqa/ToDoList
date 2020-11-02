//
//  TaskCell.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import UIKit

class TaskCell: UITableViewCell {
  
    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var taskDateLabel: UILabel!
    @IBOutlet var taskCompletionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
