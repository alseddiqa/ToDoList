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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell

        cell.taskTitleLabel.text = "task \(indexPath.row)"
        cell.taskDateLabel.text = "date"
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Check segue type
        switch segue.identifier {
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

}
