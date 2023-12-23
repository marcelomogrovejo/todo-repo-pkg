//
//  TodoTaskDto.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

struct TodoTaskDto: Codable {
    var id: String
    var avatar: String
    var username: String
    var title: String
    var description: String
    var date: Date
    var isComplete: Bool

    /*
     {
         avatarUrl = "";
         date = "13 December 2023 13:0";
         description = "Do something else";
         id = "EB3E1753-7A4B-45BF-952A-01403F27F460";
         isCompleted = false;
         title = "Task #2";
         username = mogro;
     }
     */
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case avatar = "avatarUrl"
        case username = "username"
        case title = "title"
        case description = "description"
        case date = "date"
        case isComplete = "isCompleted"
    }
}
