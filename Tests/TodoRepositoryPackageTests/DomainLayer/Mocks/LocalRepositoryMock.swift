//
//  LocalRepositoryMock.swift
//
//
//  Created by Marcelo Mogrovejo on 02/01/2024.
//

import Foundation
@testable import TodoRepositoryPackage

class LocalRepositoryMock: RepositoryProtocol {

    typealias T = TodoTaskDto

    var getOneSuccess = true
    var listSuccess = true
    var addSuccess = true
    var updateSuccess = true
    var deleteSuccess = true

    func get(id: String, completion: @escaping (Result<TodoTaskDto?, RepositoryError>) -> Void) {
        if getOneSuccess {
            completion(.success(TodoTaskDto(id: id,
                                            avatar: "",
                                            username: "TestUsername",
                                            title: "Test title",
                                            description: "Test description",
                                            date: Date(),
                                            isComplete: false)))
        } else {
            completion(.failure(.notFound))
        }
    }

    func list(completion: @escaping (Result<[TodoTaskDto], RepositoryError>) -> Void) {
        if listSuccess {
            var todoTaskDtos: [TodoTaskDto] = []
            for i in 0...5 {
                todoTaskDtos.append(TodoTaskDto(id: UUID().uuidString,
                                                avatar: "",
                                                username: "TestUsername\(i)",
                                                title: "Test Task #\(i)",
                                                description: "Test description \(i)",
                                                date: Date(),
                                                isComplete: (((i % 2) != 0) ? true : false)))
            }
            completion(.success(todoTaskDtos))
        } else {
            completion(.failure(.notFound))
        }
    }
    
    func add(_ item: TodoTaskDto, completion: @escaping (Result<TodoTaskDto, RepositoryError>) -> Void) {
        if addSuccess {
            completion(.success(item))
        } else {
            completion(.failure(.notFound))
        }
    }
    
    func update(_ item: TodoTaskDto, completion: @escaping (Result<TodoTaskDto, RepositoryError>) -> Void) {
        if updateSuccess {
            completion(.success(item))
        } else {
            completion(.failure(.notFound))
        }
    }
    
    func delete(_ item: TodoTaskDto, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        if deleteSuccess {
            completion(.success(true))
        } else {
            completion(.failure(.notFound))
        }
    }

}
