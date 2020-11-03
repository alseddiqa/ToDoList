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
    
    @IBOutlet var dateSwitch: UISwitch!
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
                dateSwitch.isOn = false
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
        
        //Saving changes and edits to the task's information
        if !newTask {
            makeChangesToTask()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskDatePicker.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
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
        if !validateInputFields() {
            return
        }
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
    
    /// A function that handles the changes made to task information
    private func makeChangesToTask() {
        let oldTask = task
        task.taskTitle = titleTextField.text ?? ""
        task.taskAdditionalNotes = additionalNotesTextField.text ?? ""
        if taskDatePicker.isEnabled == true {
            task.taskDueDate = taskDatePicker.date
        }
        delegate.updateTask(oldTask: oldTask!, newTask: task)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
    
    /// A function that checks wether the user filled the title field
    /// - Returns: false if user didn't type anything, true if user typed something
    func validateInputFields() -> Bool {
        let title = titleTextField.text!
        
        if title.count == 0 {
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            titleTextField.layer.borderWidth = 1.0
            let alert = UIAlertController(title: "Task title is empty!", message: "Am I a joke to you?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sorry, I'll fill them now", style: .destructive, handler: nil))
            self.present(alert, animated: true)
            
            return false
        }
        
        return true
    }
}
