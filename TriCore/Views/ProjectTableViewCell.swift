//
//  ProjectTableViewCell.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/12/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var projectTitleAndNumber: UILabel!
    @IBOutlet weak var taskCodeName: UILabel!
    @IBOutlet weak var sprintCategoryName: UILabel!

    @IBOutlet var textFieldContainerCollection: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
