//
//  TaskDetailDelegate.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

protocol TaskDetailDelegate {
    
    func addTask(task: Task)
    func updateTask(oldTask: Task, newTask: Task)
}
