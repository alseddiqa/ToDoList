//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//


import UIKit
import UserNotifications

class TasksViewController: UITableViewController {
    
    //Declaring the task store to hold tasks
    var tasksStore: TasksStore!
    var allTasks = [Task]()
    var all = true
    
    @IBOutlet var segmentView: UIView!
    @IBOutlet var taskTypeSegmentController: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
        taskTypeSegmentController.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06271465868, green: 0.1547748148, blue: 0.2115044296, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasksStore.tasks.count == 0 {
            self.tableView.setEmptyMessage("No tasks added in this section!")
            return 0
        }
        else {
            self.tableView.restore()
            return tasksStore.tasks.count
        }
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        tasksStore.tasks = tasksStore.getSortedTasks()
        
        let task = tasksStore.tasks[indexPath.row]
        cell.taskTitleLabel.text = task.taskTitle
        
        if task.taskDueDate != nil {
            cell.taskDateLabel.text = getRemainingTime(task: task)
        }
        else{
            cell.taskDateLabel.text = "No due date"
        }
        
        cell.taskCompletionImage.image = UIImage(systemName: "target")
        
        if task.taskNotificationId.count != 0 {
            let notificationImage = UIImage(systemName: "bell.circle")?.withTintColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), renderingMode: .alwaysOriginal)
            cell.taskCompletionImage.image = notificationImage
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
            
            let alert = UIAlertController(title: "Are you sure about deletion?", message: "You better be sure :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes, I'm aware of consequences", style: .destructive, handler: { action in
                self.deleteSafely(task: task, indexPath: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: "No, backup", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        tasksStore.changeTaskPosition(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    /// A function that presentes task detail view controller depending on what user wants to do
    /// if the user wants to create a new task, detail view will be prepared with empty fields
    /// if the user would like to modify, will present detail view with current values of the tapped on task
    /// - Parameters:
    ///   - segue: segue identifier
    ///   - sender: could be a tapped task to edit, or add new task on the top right corner
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
    
    // A the leading cell action setter for completion and
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let completionAction = UIContextualAction(style: .normal, title: "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let task = self.tasksStore.tasks[indexPath.row]
            self.tasksStore.removeTask(task)
            task.isCompleted = true
            self.tasksStore.tasks.append(task)
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            success(true)
            self.showToast(message: "Well Done!", seconds: 1.0)
        })
        completionAction.image = UIImage(systemName: "checkmark")
        completionAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let notification = UIContextualAction(style: .normal, title: "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let task = self.tasksStore.tasks[indexPath.row]
            if task.taskNotificationId.count != 0 {
                self.removeRegisteredNotification(forTask: task)
                let temp = task
                temp.taskNotificationId = ""
                self.updateTask(oldTask: task, newTask: temp)
                self.showToast(message: "Alert Removed", seconds: 1.0)
            }else {
                self.registerTaskNotification(task: task)
                self.showToast(message: "You'll be alerted about it!", seconds: 1.0)
            }
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            success(true)
        })
        notification.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        notification.image = UIImage(systemName: "bell.circle")
        return UISwipeActionsConfiguration(actions: [completionAction , notification])
        
        
    }
    
    /// A helper function that returns a custom string based on the remianing time for the task
    /// - Parameter taskDate: the date of the task
    /// - Returns: returns the due date string
    func getRemainingTime(task: Task) -> String{
        
        if task.isCompleted {
            return "Task Achieved!"
        }
        let taskDate = task.taskDueDate
        let nowDate = Date()
        let timeDiffrence = Calendar.current.dateComponents([.day,.hour , .minute, .second], from: taskDate!, to: nowDate)
        let hours = timeDiffrence.hour! * -1
        let minutes = timeDiffrence.minute! * -1
        let seccond = taskDate!.timeIntervalSince(nowDate)
        let days = timeDiffrence.day! * -1
        
        var dueDate = ""
        if seccond < 0{
            dueDate = "Past due :("
        }
        else if minutes == 0 {
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
            dueDate = "Due at " + dateFormatterGet.string(from: taskDate!)
        }
        
        return dueDate
    }
    
    /// A helper function that deletes the task from the list after user is alerted
    /// - Parameters:
    ///   - task: the task to delete
    ///   - indexPath: the location of the task to be deleted
    func deleteSafely(task: Task , indexPath: IndexPath) {
        tasksStore.removeTask(task)
        // Also remove that row from the table view with an animation
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        removeRegisteredNotification(forTask: task)
        
    }
    
    /// A helper function that regissters notification for a specifc task to remind the user about
    /// this function gets called when the user swipes right and selects the notification button
    /// - Parameter task: the task to be notified about
    func registerTaskNotification(task: Task) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.badge,.alert, .sound])
        { (granted, Error) in}
        
        let content = UNMutableNotificationContent()
        content.title = "You have a task to do now"
        content.body = task.taskTitle
//        content.badge = 1
        
        let date = task.taskDueDate
        let dateComponents = Calendar.current.dateComponents([.year, .hour , .minute, .month , .second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationId = UUID().uuidString
        let notificationRequest = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        notificationCenter.add(notificationRequest) { (error) in}
        
        
        
        let tempTask = task
        tempTask.taskNotificationId = notificationId
        updateTask(oldTask: task, newTask: tempTask)
        
    }
    
    /// A function that removes the notification for a specific task in case it was deleted
    /// - Parameter task: the task to remove the notification from
    func removeRegisteredNotification(forTask task: Task) {
        if task.taskNotificationId.count != 0 {
            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
              for request in requests {
                if request.identifier == task.taskNotificationId{
                  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.taskNotificationId])
                }
              }
            }
        }
    }
    
    @IBAction func sortTasks(_ sender: UISegmentedControl) {
       
        if sender.selectedSegmentIndex == 1 {
            if all == true {
                all = false
                allTasks = tasksStore.tasks
            }
            else {
                tasksStore.tasks = allTasks
                all = true
            }
            tasksStore.tasks = tasksStore.getWorkTasks()
            self.showToast(message: "Work Tasks", seconds: 1.0)
        } else if sender.selectedSegmentIndex == 2 {
            if all == false {
                tasksStore.tasks = allTasks
                all = true
            }
            else {
                all = false
                allTasks = tasksStore.tasks
            }
            tasksStore.tasks = tasksStore.getFamilyTasks()
            self.showToast(message: "Family Tasks", seconds: 1.0)
        }
        else {
            all = true
            tasksStore.tasks =  allTasks
            self.showToast(message: "All Tasks", seconds: 1.0)

        }
        
        
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
}

extension TasksViewController: TaskDetailDelegate {
    
    /// the delegate function that allows adding a task to the list of tasks
    /// - Parameter task: the task to be added
    func addTask(task: Task) {
        tasksStore.addTaskToList(task: task)
//        tableView.insertRows(at: [[0,tasksStore.tasks.count-1]], with: .automatic)
        tableView.reloadData()
    }
    
    /// the delegate function that allows task update
    /// - Parameters:
    ///   - oldTask: the old task values
    ///   - newTask: the new task values
    func updateTask(oldTask: Task, newTask: Task) {
        tasksStore.updateTaskDetail(oldTask: oldTask, newTask: newTask)
        tableView.reloadData()
//        tableView.reloadRows(at: [[0,oldTask.indexOfTask]], with: .fade )
    }
    
    
}

extension UITableView {
    
    /// A function that sets a message for the table view to display when there are no tasks
    /// - Parameter message: the message to display
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    /// A function that restores the table seprator
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UISegmentedControl {

    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }

}
