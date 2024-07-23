//
//  ApiService.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

public protocol ApiServiceProtocol {
    func getOne(id: String, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func getOneAsync(id: String) async throws -> DomainTodoTask
    func getAll(completion: @escaping (Result<[DomainTodoTask], RepositoryError>) -> Void)
    func getAllAsync() async throws -> [DomainTodoTask]
    func new(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func newAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask
    func update(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func updateAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask
    func delete(_ item: DomainTodoTask, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    func deleteAsync(_ item: DomainTodoTask) async throws -> Bool
    func completeTask(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void)
    func completeTaskAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask
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

    public func getOneAsync(id: String) async throws -> DomainTodoTask {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DomainTodoTask, Error>) in
            getOne(id: id) { result in
                switch result {
                case .success(let domainTodoTask):
                    continuation.resume(returning: domainTodoTask)
                case .failure(let repositoryError):
                    continuation.resume(throwing: repositoryError)
                }
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

    public func getAllAsync() async throws -> [DomainTodoTask] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[DomainTodoTask], Error>) in
            getAll() { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // TODO: Warning ! implement
    /*
    func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<DetailedImage, Error>) in
            downloadImageAndMetadata(imageNumber: imageNumber) { image, error in
                if let image = image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        })
    }
     */


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
    public func newAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DomainTodoTask, Error>) in
            new(item) { result in
                switch result {
                case .success(let domainTodoTask):
                    continuation.resume(returning: domainTodoTask)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func update(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void) {
        let todoTaskDto = TodoTaskDto(id: item.id,
                                      avatar: item.avatar,
                                      username: item.username,
                                      title: item.title,
                                      description: item.description,
                                      date: item.date,
                                      isComplete: item.isCompleted)
        localRepository.update(todoTaskDto) { result in
            switch result {
            case .success(let updatedTodoTaskDto):
                let domainTodoTask = DomainTodoTask(id: updatedTodoTaskDto.id,
                                                    avatar: updatedTodoTaskDto.avatar,
                                                    username: updatedTodoTaskDto.username,
                                                    title: updatedTodoTaskDto.title,
                                                    date: updatedTodoTaskDto.date,
                                                    description: updatedTodoTaskDto.description,
                                                    isCompleted: updatedTodoTaskDto.isComplete)
                completion(.success(domainTodoTask))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }

    public func updateAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DomainTodoTask, Error>) in
            update(item) { result in
                switch result {
                case .success(let domainTodoTask):
                    continuation.resume(returning: domainTodoTask)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
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
        localRepository.delete(todoTaskDto) { result in
            switch result {
            case .success(let isDeleted):
                completion(.success(isDeleted))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }

    public func deleteAsync(_ item: DomainTodoTask) async throws -> Bool {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            delete(item) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func completeTask(_ item: DomainTodoTask, completion: @escaping (Result<DomainTodoTask, RepositoryError>) -> Void) {
//        let todoTaskDto = TodoTaskDto(id: item.id,
//                                      avatar: item.avatar,
//                                      username: item.username,
//                                      title: item.title,
//                                      description: item.description,
//                                      date: item.date,
//                                      isComplete: item.isCompleted)
//        localRepository.complete(todoTaskDto) { result in
//            switch result {
//            case .success(let updatedTodoTaskDto):
//                let domainTodoTask = DomainTodoTask(id: updatedTodoTaskDto.id,
//                                                    avatar: updatedTodoTaskDto.avatar,
//                                                    username: updatedTodoTaskDto.username,
//                                                    title: updatedTodoTaskDto.title,
//                                                    date: updatedTodoTaskDto.date,
//                                                    description: updatedTodoTaskDto.description,
//                                                    isCompleted: updatedTodoTaskDto.isComplete)
//                completion(.success(domainTodoTask))
//            case .failure(let repositoryError):
//                completion(.failure(repositoryError))
//            }
//        }
        let completedItem = DomainTodoTask(id: item.id,
                                           avatar: item.avatar,
                                           username: item.username,
                                           title: item.title,
                                           date: item.date,
                                           description: item.description,
                                           isCompleted: true)
        update(completedItem) { result in
            switch result {
            case .success(let domainTodoTask):
                completion(.success(domainTodoTask))
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }
    }

    public func completeTaskAsync(_ item: DomainTodoTask) async throws -> DomainTodoTask {
        let updatedDomainItem = DomainTodoTask(id: item.id,
                                               avatar: item.avatar,
                                               username: item.username,
                                               title: item.title,
                                               date: item.date,
                                               description: item.description,
                                               isCompleted: true)
        // TODO: Why not calling updateAsync() ?
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DomainTodoTask, Error>) in
            update(updatedDomainItem) { result in
                switch result {
                case .success(let domainTodoTask):
                    continuation.resume(returning: domainTodoTask)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}
