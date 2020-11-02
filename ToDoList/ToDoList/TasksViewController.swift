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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
        
        if task.taskDueDate != nil {
            cell.taskDateLabel.text = "Due at " + dateFormatterGet.string(from: task.taskDueDate!)
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
            taskDetailViewController.tasksStore = self.tasksStore
            taskDetailViewController.newTask = true
        case "showTask":
            
            //identify which row task was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                let task = Task(title: "Life", notes: "not good")
                task.taskDueDate = Date()
                let taskDetailViewController
                    = segue.destination as! TaskDetailsViewController
                taskDetailViewController.task = task
                taskDetailViewController.newTask = false
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
