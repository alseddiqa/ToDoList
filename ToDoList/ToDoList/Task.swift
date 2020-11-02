//
//  Task.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

class Task: Codable , Equatable{
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.taskTitle == rhs.taskTitle
            && lhs.taskAdditionalNotes == rhs.taskAdditionalNotes
            && lhs.taskDueDate == rhs.taskDueDate
    }
    
    
    var taskTitle: String
    var taskAdditionalNotes: String
    var taskDueDate: Date?
    var isCompleted: Bool
    var indexOfTask: Int = 0
    
    init(title: String, notes: String) {
        taskTitle = title
        taskAdditionalNotes =  notes
        isCompleted = false
    }
    
    
}
