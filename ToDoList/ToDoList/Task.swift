//
//  Task.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

class Task: Codable{
    
    var taskTitle: String
    var taskAdditionalNotes: String
    var taskDueDate: Date?
    var completed: Bool
    
    init(title: String, notes: String) {
        taskTitle = title
        taskAdditionalNotes =  notes
        completed = false
    }
    
    
}
