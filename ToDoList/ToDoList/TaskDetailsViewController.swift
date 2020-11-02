//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import UIKit

class TaskDetailsViewController: UIViewController, UITextFieldDelegate {
    
    var task: Task!
    var tasksStore: TasksStore!
    var newTask: Bool = true

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var taskDatePicker: UIDatePicker!
    @IBOutlet var additionalNotesTextField: UITextField!
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !newTask {
            if task.taskDueDate != nil {
                taskDatePicker.date = task.taskDueDate!
            }
            else {
                taskDatePicker.isEnabled = false
            }
            titleTextField.text = task.taskTitle
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
    
    
    @IBAction func submitTask(_ sender: UIBarButtonItem) {
        let title = titleTextField.text!
        let notes = additionalNotesTextField.text!
        let task = Task(title: title, notes: notes)

        if taskDatePicker.isEnabled {
            let date = taskDatePicker.date
            task.taskDueDate = date
        }
        
        tasksStore.addTaskToList(task: task)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
