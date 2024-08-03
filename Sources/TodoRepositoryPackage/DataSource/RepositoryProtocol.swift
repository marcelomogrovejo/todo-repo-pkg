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

    /// Fetch one item by `id`.
    ///
    /// - Parameters:
    ///   - id:The item unique identifier.
    ///   - completion: A result with the item itself or a repository error.
    func get(id: String, completion: @escaping (Result<T?, RepositoryError>) -> Void)

    /// Fetch a list of items.
    ///
    /// - Parameter completion: A result with an array of items or a repository error.
    func list(completion: @escaping (Result<[T], RepositoryError>) -> Void)

    /// Add a new item.
    ///
    /// - Parameters:
    ///   - item: The `item` which will be added.
    ///   - completion: The result with the just added item or a repository error.
    func add(_ item: T, completion: @escaping (Result<T, RepositoryError>) -> Void)

    /// Update an item.
    ///
    /// - Parameters:
    ///   - item: The `item` which will be updated.
    ///   - completion: The result with the just updated item or a repository error.
    func update(_ item: T, completion: @escaping (Result<T, RepositoryError>) -> Void)

    /// Remove an item.
    ///
    /// - Parameter item: The `item` which will be removed.
    /// - Parameter completion The result with a boolean value or a repository error.
    ///
    /// > Waring: This method should return anything.
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
