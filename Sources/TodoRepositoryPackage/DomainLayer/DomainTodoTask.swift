//
//  DomainTodoTask.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

public struct DomainTodoTask {
    public let id: String
    public let avatar: String
    public let username: String
    public let title: String
    public let date: Date
    public let description: String
    public let isCompleted: Bool

    public init(id: String,
                avatar: String,
                username: String,
                title: String,
                date: Date,
                description: String,
                isCompleted: Bool = false) {
        self.id = id
        self.avatar = avatar
        self.username = username
        self.title = title
        self.date = date
        self.description = description
        self.isCompleted = isCompleted
    }
}
