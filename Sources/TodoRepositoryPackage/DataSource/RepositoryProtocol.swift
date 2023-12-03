//
//  RepositoryProtocol.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation
import Combine

protocol RepositoryProtocol {

    associatedtype T

    func get(id: String, completion: @escaping (Result<T?, RepositoryError>) -> Void)
    func list(completion: @escaping (Result<[T], RepositoryError>) -> Void)
    func add(_ item: T, completion: @escaping (Result<T, RepositoryError>) -> Void)
    func edit(_ item: T, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
    func delete(_ item: T, completion: @escaping (Result<Bool, RepositoryError>) -> Void)
}

protocol CombineRepositoryProtocol {

    associatedtype T

    func get(id: String) -> AnyPublisher<T, RepositoryError>
    func list() -> AnyPublisher<[T], RepositoryError>
    func add(_ item: T) -> AnyPublisher<T, RepositoryError>
    func edit(_ item: T) -> AnyPublisher<Bool, RepositoryError>
    func delete(_ item: T) -> AnyPublisher<Bool, RepositoryError>
}
