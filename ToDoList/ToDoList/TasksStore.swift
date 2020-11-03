//
//  TasksStore.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import UIKit

class TasksStore {
    
    // List of tasks array
    var tasks = [Task]()
    
    //Declaring the path to where tasks should be saved
    var tasksURL: URL = {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let noteURL = baseURL.appendingPathComponent("tasks")
        return noteURL
    }()
    
    
    /// A constructor fot the tasks store to get the tasks stored on disk when the application launches
    init() {
        do {
            let data = try Data(contentsOf: tasksURL)
            let unarchiver = PropertyListDecoder()
            let storedTasks = try unarchiver.decode([Task].self, from: data)
            tasks = storedTasks
        } catch {
            print("Error fetching stored tasks: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    /// A function that adds a task to the list of tasks
    /// - Parameter task: the task to add
    func addTaskToList(task: Task){
        tasks.append(task)
    }

    
    /// A function that removes a task from the list of tasks
    /// - Parameter task: task to remove from the list
    func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(of: task) {
            tasks.remove(at: index)
        }
    }
    
    /// A function that changes where the task is positioned in the list of tasks
    /// - Parameters:
    ///   - fromIndex: initial position of the task
    ///   - toIndex: desiered position of the task
    func changeTaskPosition(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let task = tasks[fromIndex]
        // Removing the task from its old location in the array
        tasks.remove(at: fromIndex)
        // Inserting task in array at new location
        tasks.insert(task, at: toIndex)
    }
    
    /// A function that updates task values
    /// - Parameters:
    ///   - oldTask: old task with unwanted values
    ///   - newTask: the new task holding the new values
    func updateTaskDetail(oldTask: Task, newTask: Task ) {
        let indexOfOldTask = tasks.firstIndex(of: oldTask)
        tasks[indexOfOldTask!] = newTask
        
    }
    
    /// A function that handles saving tasks to disk when the user closes the application
    /// - Throws: an encoding error if tasks weren't saved properly to disk
    @objc func saveChanges() throws {
        print("Saving tasks to: \(tasksURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(tasks)
            try data.write(to: tasksURL, options: [.atomic])
            print("Saved all tasks to disk")
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
    
}
