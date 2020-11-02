//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var task: Task!
    var newTask: Bool = true

    @IBOutlet var titeTextField: UITextField!
    @IBOutlet var taskDatePicker: UIDatePicker!
    @IBOutlet var additionalNotesTextField: UITextField!
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        if !newTask {
            taskDatePicker.date = task.taskDueDate!
            titeTextField.text = task.taskTitle
            additionalNotesTextField.text = task.taskAdditionalNotes
        }
        else {
            taskDatePicker.minimumDate = Date()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func disableDatePicker(_ sender: UISwitch) {
        
        //Check the status of the UISwitch
        if sender.isOn {
            taskDatePicker.isEnabled = true
        }
        else {
            taskDatePicker.isEnabled = false
        }
    }
    
}
