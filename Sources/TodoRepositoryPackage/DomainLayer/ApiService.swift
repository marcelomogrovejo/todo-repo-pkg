//
//  ApiService.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

public protocol ApiServiceProtocol {
    func getOne(id: String, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func getAll(completion: @escaping (Result<[DomainTodoTask], RepositoryError>) -> Void)
    func new(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func update(_ item: DomainTodoTask, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    func delete(_ item: DomainTodoTask, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
}

public struct ApiService {

    public let localRepository: UserDefaultsTaskRepository

    public init(localRepository: UserDefaultsTaskRepository = UserDefaultsTaskRepository()) {
        self.localRepository = localRepository
    }

}

extension ApiService: ApiServiceProtocol {
    public func getOne(id: String, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void) {
        localRepository.get(id: id) { result in
            switch result {
            case .success(let todoTaskDto):
                guard let todoTaskDto = todoTaskDto else {
                    return completion(.failure(.notFound))
                }
                let domainTodoTask = DomainTodoTask(id: todoTaskDto.id,
                                                    avatar: todoTaskDto.avatar,
                                                    username: todoTaskDto.username,
                                                    title: todoTaskDto.title,
                                                    date: todoTaskDto.date,
                                                    description: todoTaskDto.description,
                                                    isCompleted: todoTaskDto.isComplete)
                completion(.success(domainTodoTask))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }
    
    public func getAll(completion: @escaping (Result<[DomainTodoTask], RepositoryError>) -> Void) {
        localRepository.list { result in
            switch result {
            case .success(let todoTaskDtos):
                let domainTodoTasks = todoTaskDtos.map{ DomainTodoTask(id: $0.id,
                                                                       avatar: $0.avatar,
                                                                       username: $0.username,
                                                                       title: $0.title,
                                                                       date: $0.date,
                                                                       description: $0.description,
                                                                       isCompleted: $0.isComplete)
                }
                completion(.success(domainTodoTasks))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }
    
    public func new(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void) {
        let todoTaskDto = TodoTaskDto(id: UUID().uuidString,
                                      avatar: item.avatar,
                                      username: item.username,
                                      title: item.title,
                                      description: item.description,
                                      date: item.date,
                                      isComplete: item.isCompleted)
        localRepository.add(todoTaskDto) { result in
            switch result {
            case .success(let todoTaskDto):
                let domainTodoTask = DomainTodoTask(id: todoTaskDto.id,
                                                    avatar: todoTaskDto.avatar,
                                                    username: todoTaskDto.username,
                                                    title: todoTaskDto.title,
                                                    date: todoTaskDto.date,
                                                    description: todoTaskDto.description,
                                                    isCompleted: todoTaskDto.isComplete)
                completion(.success(domainTodoTask))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }
    
    public func update(_ item: DomainTodoTask, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let todoTaskDto = TodoTaskDto(id: item.id,
                                      avatar: item.avatar,
                                      username: item.username,
                                      title: item.title,
                                      description: item.description,
                                      date: item.date,
                                      isComplete: item.isCompleted)
        localRepository.edit(todoTaskDto) { result in
            switch result {
            case .success(let isUpdated):
                completion(.success(isUpdated))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }
    
    public func delete(_ item: DomainTodoTask, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let todoTaskDto = TodoTaskDto(id: item.id,
                                      avatar: item.avatar,
                                      username: item.username,
                                      title: item.title,
                                      description: item.description,
                                      date: item.date,
                                      isComplete: item.isCompleted)
        localRepository.edit(todoTaskDto) { result in
            switch result {
            case .success(let isDeleted):
                completion(.success(isDeleted))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }

}
