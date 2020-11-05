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
    let typesList = [NSLocalizedString("Any", comment: ""),NSLocalizedString("Family", comment: ""),NSLocalizedString("Work", comment: "")]
    let dateFormatterGet = DateFormatter()
    
    @IBOutlet var dateSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var taskDatePicker: UIDatePicker!
    @IBOutlet var additionalNotesTextField: UITextField!
    @IBOutlet var taskTypePicker: UIPickerView!
    @IBOutlet var dateCreatedLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        dateFormatterGet.dateFormat = "MMM d, h:mm a"

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
            if task.taskType == "Any" {
                taskTypePicker.selectRow(0, inComponent: 0, animated: true)
            }else if task.taskType == "Family" {
                taskTypePicker.selectRow(1, inComponent: 0, animated: true)
            }
            else {
                taskTypePicker.selectRow(2, inComponent: 0, animated: true)
            }
        }
        else {
            taskDatePicker.minimumDate = Date()
            let today = Date()
            dateCreatedLabel.text?.append(dateFormatterGet.string(from: today))
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        titleTextField.layer.borderColor = #colorLiteral(red: 0.06274509804, green: 0.2156862745, blue: 0.3607843137, alpha: 1)
        titleTextField.layer.borderWidth = 1.0
        additionalNotesTextField.layer.borderColor = #colorLiteral(red: 0.06274509804, green: 0.2156862745, blue: 0.3607843137, alpha: 1)
        additionalNotesTextField.layer.borderWidth = 1.0
        
        taskTypePicker.delegate = self
        taskTypePicker.dataSource = self
        
        taskTypePicker.setValue(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), forKeyPath: "textColor")

    }
    
    /// function to disable the date picker if the user decided not to select a date
    /// - Parameter sender: <#sender description#>
    @IBAction func disableDatePicker(_ sender: UISwitch) {
        
        //Check the status of the UISwitch
        if sender.isOn {
            taskDatePicker.isEnabled = true
        }
        else {
            taskDatePicker.isEnabled = false
        }
    }
    
    
    /// A function that adds the task to the list of tasks
    /// - Parameter sender: the submit button
    @IBAction func submitTask(_ sender: UIBarButtonItem) {
        if !validateInputFields() {
            return
        }
        let title = titleTextField.text!
        let notes = additionalNotesTextField.text!
        let type = getSelectedTaskType()
        let task = Task(title: title, notes: notes,type: type)

        if taskDatePicker.isEnabled {
            let date = taskDatePicker.date
            task.taskDueDate = date
        }
        
        delegate.addTask(task: task)
        print(task.taskType)
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
    
    /// A function that moves the keyboard down when user has done typing
    /// - Parameter textField: the textfield where the user hit enter
    /// - Returns: true when the user is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// A helper function that unshow the keyboard when the user taps on the background
    /// - Parameter sender: the background of the app
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
    
    /// A function that checks wether the user filled the title field
    /// - Returns: false if user didn't type anything, true if user typed something
    private func validateInputFields() -> Bool {
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
    
    /// A helper function to get the selected task type from the list
    /// - Returns: the a string of the selected task type from the
    private func getSelectedTaskType() -> String{
        let index = taskTypePicker.selectedRow(inComponent: 0)
        switch index {
        case 0:
            return "Any"
        case 1:
            return "Family"
        case 2:
            return "Work"
        default:
            return ""
        }
    }
}

extension TaskDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesList.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesList[row]
    }
    
}

extension UIViewController{
    
    /// A helper function to show a toast when somehting is completed
    /// - Parameters:
    ///   - message: the message to diplay if an action is complete
    ///   - seconds: the amount of secconds to be diplayed
func showToast(message : String, seconds: Double){
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
 }
