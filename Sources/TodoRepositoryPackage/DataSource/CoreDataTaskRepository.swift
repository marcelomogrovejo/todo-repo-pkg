//
//  CoreDataTaskRepository.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

class CoreDataTaskRepository: RepositoryProtocol {

    typealias T = TodoTaskDto

    func get(id: String, completion: @escaping (Result<TodoTaskDto?, RepositoryError>) -> Void) {
        // TODO: implement
        completion(.failure(.notFound))
    }

    func list(completion: @escaping (Result<[TodoTaskDto], RepositoryError>) -> Void) {
        // TODO: implement
        completion(.success([]))
    }
    
    func add(_ item: TodoTaskDto, completion: @escaping (Result<TodoTaskDto, RepositoryError>) -> Void) {
        // TODO: implement
        completion(.failure(.notFound))
    }
    
    func edit(_ item: TodoTaskDto, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        // TODO: implement
        completion(.failure(.notFound))
    }
    
    func delete(_ item: TodoTaskDto, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        // TODO: implement
        completion(.failure(.notFound))
    }

}
