//
//  UserDefaultsTaskRepository.swift
//  TodoMVP
//
//  Created by Marcelo Mogrovejo on 02/12/2023.
//

import Foundation

public class UserDefaultsTaskRepository: RepositoryProtocol {

    typealias T = TodoTaskDto

    let keyPrefix = "todo-task-"
    
    /// Public initializer.
    public init() {}

    /// Fetch one item by `id`.
    ///
    /// - Parameters:
    ///   - id:The item unique identifier.
    ///   - completion: A result with the item itself or a repository error.
    func get(id: String, completion: @escaping (Result<TodoTaskDto?, RepositoryError>) -> Void) {
        let key = "\(keyPrefix)\(id)"
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            do {
                let item = try JSONDecoder().decode(TodoTaskDto.self, from: data)
                completion(.success(item))
            } catch {
                print("Error: Unable to Decode object (\(error))")
                completion(.failure(.notFound))
            }
        } else {
            print("Error: Object not found.")
            completion(.failure(.notFound))
        }
    }

    /// Fetch a list of items.
    ///
    /// - Parameter completion: A result with an array of items or a repository error.
    func list(completion: @escaping (Result<[TodoTaskDto], RepositoryError>) -> Void) {
        var todos: [TodoTaskDto] = []
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            #if DEBUG
//            print("\(key): \(value)")
            #endif
            if key.contains(keyPrefix) {
                let data = UserDefaults.standard.data(forKey: key)
                guard let data = data else {
                    return completion(.failure(.notFound))
                }
                do {
                    let dataDocoded = try JSONDecoder().decode(TodoTaskDto.self, from: data)
                    todos.append(dataDocoded)
                } catch {
                    print("Error: Unable to Decode object (\(error))")
                    completion(.failure(.notFound))
                }
            }
        }

        // Mocks moved to the extension
        // let todos = getTodos()

        completion(.success(todos))
    }

    /// Add a new item.
    ///
    /// - Parameters:
    ///   - item: The `item` which will be added.
    ///   - completion: The result with the just added item or a repository error.
    func add(_ item: TodoTaskDto, completion: @escaping (Result<TodoTaskDto, RepositoryError>) -> Void) {
        // UserDefauls just accept things like NSArray, NSDictionary, NSString, NSData, NSNumber, and NSDate NOT custome objects
        do {
            let data = try JSONEncoder().encode(item)
            let key = "\(keyPrefix)\(item.id)"
            UserDefaults.standard.set(data, forKey: key)
            completion(.success(item))
        } catch {
            print("Error: Unable to Encode object (\(error))")
            completion(.failure(.notFound))
        }
    }

    /// Update an item.
    ///
    /// - Parameters:
    ///   - item: The `item` which will be updated.
    ///   - completion: The result with the just updated item or a repository error.
    func update(_ item: TodoTaskDto, completion: @escaping (Result<TodoTaskDto, RepositoryError>) -> Void) {
        get(id: item.id) { result in
            switch result {
            case .success(let todoTaskDto):
                guard var todoTaskToBeUpdated = todoTaskDto else {
                    completion(.failure(.notFound))
                    return
                }
                todoTaskToBeUpdated.avatar = item.avatar
                todoTaskToBeUpdated.title = item.title
                todoTaskToBeUpdated.description = item.description
                todoTaskToBeUpdated.isComplete = item.isComplete
                todoTaskToBeUpdated.date = item.date
                todoTaskToBeUpdated.username = item.username
                do {
                    let data = try JSONEncoder().encode(todoTaskToBeUpdated)
                    let key = "\(self.keyPrefix)\(todoTaskToBeUpdated.id)"
                    UserDefaults.standard.set(data, forKey: key)
                    completion(.success(todoTaskToBeUpdated))
                } catch {
                    print("Error: Unable to Encode object (\(error))")
                    completion(.failure(.notFound))
                }
            case .failure(let repositoryError):
                completion(.failure(repositoryError))
            }
        }

        /*
        let key = "\(keyPrefix)\(item.id)"
        guard var todoTaskToBeUpdated = UserDefaults.standard.object(forKey: key) as? TodoTaskDto else {
            return completion(.failure(.notFound))
        }
        todoTaskToBeUpdated.title = item.title
        todoTaskToBeUpdated.avatar = item.avatar
        todoTaskToBeUpdated.description = item.description
        todoTaskToBeUpdated.isComplete = item.isComplete
        UserDefaults.standard.set(todoTaskToBeUpdated, forKey: key)
        completion(.success(true))
         */
    }

    /// Remove an item.
    ///
    /// - Parameter item: The `item` which will be removed.
    /// - Parameter completion The result with a boolean value or a repository error.
    ///
    /// > Waring: This method should return anything.
    func delete(_ item: TodoTaskDto, completion: @escaping (Result<Bool, RepositoryError>) -> Void) {
        let key = "\(keyPrefix)\(item.id)"
        UserDefaults.standard.removeObject(forKey: key)
        completion(.success(true))
    }

}

extension UserDefaultsTaskRepository {

    // MARK: - Just for quick testing purposes
    /*
    func getTodos(cant: Int = 3) -> [TodoTaskDto] {
        var todos: [TodoTaskDto] = []
        let todo1 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Do groceries", description: "Go to the supermarket and buy whatever Marge request", date: "3/11/2023 10:10:00", isComplete: false)
        todos.append(todo1)
        let todo2 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Do laundry", description: "Go to the laundromatic and wash whatever Marge request", date: "7/12/2023 11:30:00", isComplete: true)
        todos.append(todo2)
        let todo3 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Pay rent", description: "Go to pay de rent", date: "10/12/2023 14:30:00", isComplete: false)
        todos.append(todo3)
        let todo4 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Take bart to Moe's", description: "Go for a duff with Bart", date: "13/12/2023 16:00:00", isComplete: false)
        todos.append(todo4)
        let todo5 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Hang out with Barnie", description: "Go for a duff to share with Barnie at Moe's", date: "16/12/2023 15:45:00", isComplete: true)
        todos.append(todo5)
        let todo6 = TodoTaskDto(id: UUID().uuidString, avatar: "", username: "hsimpson", title: "Watch TV", description: "Sit on the couch as always and turn on the TV", date: "19/12/2023 20:00:00", isComplete: false)
        todos.append(todo6)
        return todos
    }
     */
}
