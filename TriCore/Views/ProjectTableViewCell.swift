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
    
    var textFields:[JVFloatLabeledTextField]?
    var controller:TimesheetsViewController?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.textFields = []
        
        for i in 1...7
        {
            textFields!.append( JVFloatLabeledTextField())
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        for container in self.textFieldContainerCollection
        {
            let index =  self.textFieldContainerCollection.indexOf(container)
            let textField = setupTextField(withContainer: container, andIndex: index!)
            self.textFields!.append(textField)
            self.addSubview(textField)
            container.backgroundColor = UIColor.clearColor()
        }
        print("Draw rect")
    }
    
    func setupTextField(withContainer container:UIView, andIndex index:Int) -> JVFloatLabeledTextField
    {
        let textField = textFields![index]
        textField.frame = container.frame
        textField.attributedPlaceholder = NSAttributedString(string: Constants.weekNameStrings[index],
            attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor().colorWithAlphaComponent(0.8)])
        textField.floatingLabelTextColor = UIColor.darkGrayColor()
        textField.font = UIFont.systemFontOfSize(15)
        textField.floatingLabelFont = UIFont.systemFontOfSize(13)
        textField.center = container.center
        textField.backgroundColor = UIColor(red:0.97, green:0.59, blue:0.11, alpha:1.0).colorWithAlphaComponent(0.2)
        textField.textAlignment = NSTextAlignment.Center
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.returnKeyType = UIReturnKeyType.Done
        addButtonsTo(textField)
        
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.blackColor().CGColor
        textField.layer.borderWidth = 1.0
        
        return textField
    }
    
    private func addButtonsTo(textField: UITextField) {
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "didTapDone:")
        
        var rightArrowImage = UIImage(named:"Right Arrow")
        rightArrowImage = rightArrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        var leftArrowImage = UIImage(named:"Left Arrow")
        leftArrowImage = leftArrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let leftArrowButton = UIBarButtonItem(image: leftArrowImage,
            style: UIBarButtonItemStyle.Bordered, target: self, action: "hitLeftButton")
        let rightArrowButton = UIBarButtonItem(image: rightArrowImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "hitRightButton")
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.tintColor = self.tintColor
        keyboardToolbar.sizeToFit()
        keyboardToolbar.items = [leftArrowButton, rightArrowButton, flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
    }
    
    func didTapDone(sender: AnyObject?) {
        self.controller!.didTapDone(sender)
    }
    
    func hitRightButton()
    {
        self.controller!.hitArrowButtonRight(yes: true)
    }
    
    func hitLeftButton()
    {
        self.controller!.hitArrowButtonRight(yes: false)
    }
}
