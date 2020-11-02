//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

import UIKit

class TasksViewController: UITableViewController {
    
    var tasksStore: TasksStore!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasksStore.tasks.count == 0 {
            self.tableView.setEmptyMessage("No tasks added yet")
            return 0
        }
        else {
            self.tableView.restore()
            return tasksStore.tasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell

        let task = tasksStore.tasks[indexPath.row]
        cell.taskTitleLabel.text = task.taskTitle
        
        if task.taskDueDate != nil {
            cell.taskDateLabel.text = getRemainingTime(taskDate: task.taskDueDate!)
        }
        else{
            cell.taskDateLabel.text = "No due date"
        }
        
        if task.isCompleted {
            let completionImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), renderingMode: .alwaysOriginal)
            cell.taskCompletionImage.image = completionImage
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let task = tasksStore.tasks[indexPath.row]
            // Removing the task from the tasksList
            tasksStore.removeTask(task)
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        tasksStore.changeTaskPosition(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Check segue type
        switch segue.identifier {
        case "createTask":
            let taskDetailViewController
                = segue.destination as! TaskDetailsViewController
//            taskDetailViewController.tasksStore = self.tasksStore
            taskDetailViewController.newTask = true
            taskDetailViewController.delegate = self
        case "showTask":
            //identify which row task was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                let task = tasksStore.tasks[row]
                let taskDetailViewController
                    = segue.destination as! TaskDetailsViewController
                taskDetailViewController.task = task
                task.indexOfTask = row
                taskDetailViewController.newTask = false
                taskDetailViewController.delegate = self
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    @IBAction func toggleEditing(_ sender: UIButton) {
                
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let completionAction = UIContextualAction(style: .normal, title: "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let task = self.tasksStore.tasks[indexPath.row]
            self.tasksStore.removeTask(task)
            task.isCompleted = true
            self.tasksStore.tasks.append(task)
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            success(true)
        })
        completionAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return UISwipeActionsConfiguration(actions: [completionAction])
        
    }
    
    /// A helper function that returns a custom string based on the remianing time for the task
    /// - Parameter taskDate: the date of the task
    /// - Returns: returns the due date string
    func getRemainingTime(taskDate: Date) -> String{
        let nowDate = Date()
        let timeDiffrence = Calendar.current.dateComponents([.day,.hour , .minute, .second], from: taskDate, to: nowDate)
        let hours = timeDiffrence.hour! * -1
        let minutes = timeDiffrence.minute! * -1
        //let seccond = timeDiffrence.second!
        let days = timeDiffrence.day! * -1
        
        var dueDate = ""
//        if hours < 0 && minutes < 0 && seccond < 0{
//            dueDate = "Past due :("
//        }
         if minutes == 0 {
            dueDate = "Due NOW!"
        }
        else if hours == 0 && minutes > 0{
            dueDate = "Due in about \(minutes) minutes"
        }
        else if days < 1 {
            dueDate = "Due in \(hours ) hours and \(minutes ) minutes"
        }
        
        else {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MMM d, h:mm a"
            dueDate = "Due at " + dateFormatterGet.string(from: taskDate)
        }
        
        return dueDate
    }
}

extension TasksViewController: TaskDetailDelegate {
    
    func addTask(task: Task) {
        tasksStore.addTaskToList(task: task)
        tableView.insertRows(at: [[0,tasksStore.tasks.count-1]], with: .automatic)
        //tableView.reloadData()
    }
    
    func updateTask(oldTask: Task, newTask: Task) {
        tasksStore.updateTaskDetail(oldTask: oldTask, newTask: newTask)
//        tableView.reloadData()
        tableView.reloadRows(at: [[0,oldTask.indexOfTask]], with: .fade )
    }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
