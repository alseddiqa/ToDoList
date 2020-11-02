//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import UIKit

class TaskDetailsViewController: UIViewController, UITextFieldDelegate {
    
    var task: Task!
    var newTask: Bool = true
    var delegate: TaskDetailDelegate!


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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        //Saving changes and edits to the item's information
        if !newTask {
            let oldTask = task
            task.taskTitle = titleTextField.text ?? ""
            task.taskAdditionalNotes = additionalNotesTextField.text ?? ""
            delegate.updateTask(oldTask: oldTask!, newTask: task)
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        view.endEditing(true)
//
//        //Saving changes and edits to the item's information
//        if !newTask {
//            let oldTask = task
//            task.taskTitle = titleTextField.text ?? ""
//            task.taskAdditionalNotes = additionalNotesTextField.text ?? ""
//            delegate.updateTask(oldTask: oldTask!, newTask: task)
//        }
//    }
    
    
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
        
        delegate.addTask(task: task)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
}
