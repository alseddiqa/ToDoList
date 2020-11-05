//
//  Task.swift
//  ToDoList
//
//  Created by Abdullah Alseddiq on 11/2/20.
//

import Foundation

class Task: Codable , Equatable{
    
    //Define the variables holding tasks information
    var taskTitle: String
    var taskAdditionalNotes: String
    var taskDueDate: Date?
    var isCompleted: Bool
    var indexOfTask: Int = 0
    var taskNotificationId = ""
    var taskType: String
    var creationDate = Date()
    
    
    /// The task constructor that takes three args
    /// - Parameters:
    ///   - title: the title of the task
    ///   - notes: the additional notes of the the task
    ///   - type: the type of the task
    init(title: String, notes: String, type: String) {
        taskTitle = title
        taskAdditionalNotes =  notes
        isCompleted = false
        taskType = type
    }
    
    /// Check equality funtion
    /// - Parameters:
    ///   - lhs: task one to be compared
    ///   - rhs: task two to be compared
    /// - Returns: true if tasks are identical
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.taskTitle == rhs.taskTitle
            && lhs.taskAdditionalNotes == rhs.taskAdditionalNotes
            && lhs.taskDueDate == rhs.taskDueDate
            && lhs.creationDate == rhs.creationDate
    }
    
}
