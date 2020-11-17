//
//  TasksProcessingOperation.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/16/20.
//

import Foundation

class TasksProcessingOperation: Operation {
    
    var tasksURL: URL = {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let noteURL = baseURL.appendingPathComponent("tasks")
        return noteURL
    }()
    
    var tasks: [Task]
    var saving: Bool
    var loading: Bool
    
    
    init(theTasks: [Task], save: Bool , load: Bool) {
        tasks = theTasks
         saving = save
         loading = load
    }
    
    private func saveChanges() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.tasks)
            try data.write(to: self.tasksURL, options: [.atomic])
            print("Saved all tasks to disk")
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
    
    private func loadTasks() {
        do {
            let data = try Data(contentsOf: self.tasksURL)
            let unarchiver = PropertyListDecoder()
            let storedTasks = try unarchiver.decode([Task].self, from: data)
            self.tasks = storedTasks
            
        } catch {
            print("Error fetching stored tasks: \(error)")
        }
    }
    
    override func main() {
        if saving {
            saveChanges()
        }
        else {
            loadTasks()
        }
    }
}
