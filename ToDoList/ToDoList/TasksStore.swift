//
//  TasksStore.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

class TasksStore {
    
    var tasks = [Task]()
    
    func addTaskToList(task: Task){
        tasks.append(task)
    }

    func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(of: task) {
            tasks.remove(at: index)
        }
    }
    
    func changeTaskPosition(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = tasks[fromIndex]
        // Removing the task from array
        tasks.remove(at: fromIndex)
        // Inserting task in array at new location
        tasks.insert(movedItem, at: toIndex)
    }
    
}
