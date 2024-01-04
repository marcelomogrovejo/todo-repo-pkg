//
//  ApiServiceTests.swift
//
//
//  Created by Marcelo Mogrovejo on 02/01/2024.
//

import XCTest
@testable import TodoRepositoryPackage

final class ApiServiceTests: XCTestCase {
    
    private var localRespo: LocalRepositoryMock?
    
    override func setUpWithError() throws {
        localRespo = LocalRepositoryMock()
    }
    
    override func tearDownWithError() throws {
        localRespo = nil
    }
    
    func testGetOne_onSuccess() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        
        // Act
        localRespo?.get(id: UUID().uuidString) { result in
            // Assert
            switch result {
            case .success(let todoTaskDto):
                if let todoTaskDto = todoTaskDto {
                    XCTAssertNotNil(todoTaskDto, "Success, we got an item.")
                } else {
                    XCTAssertNil(todoTaskDto, "Shouldn't be here, some error occurred")
                }
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Shouldn't be here, it is a success test")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetOne_onFailure_itemNotFoundError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.getOneSuccess = false
        
        // Act
        localRespo?.get(id: UUID().uuidString) { result in
            // Assert
            switch result {
            case .success( _):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Error received \(repoError)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testList_onSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        
        // Act
        localRespo?.list() { result in
            // Assert
            switch result {
            case .success(let todoTaskDtos):
                XCTAssertTrue(todoTaskDtos.count > 0, "There are \(todoTaskDtos.count) items on the list")
            case .failure(_ ):
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testList_onFailure_itemsNotFound() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.listSuccess = false
        
        // Act
        localRespo?.list() { result in
            // Assert
            switch result {
            case .success(_ ):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Not items found: \(repoError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAdd_onSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")

        let newItem = TodoTaskDto(id: UUID().uuidString,
                                  avatar: "",
                                  username: "TestUsername",
                                  title: "Test new title",
                                  description: "Test new description",
                                  date: Date(),
                                  isComplete: false)
        // Act
        localRespo?.add(newItem) { result in
            // Assert
            switch result {
            case .success(let addedItem):
                XCTAssertNotNil(addedItem, "Item added with id \(addedItem.id)")
            case .failure(_ ):
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testAdd_onFailure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.listSuccess = false

        let newItem = TodoTaskDto(id: UUID().uuidString,
                                  avatar: "",
                                  username: "TestUsername",
                                  title: "Test new title",
                                  description: "Test new description",
                                  date: Date(),
                                  isComplete: false)
        // Act
        localRespo?.add(newItem) { result in
            // Assert
            switch result {
            case .success(_ ):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Error adding a new item \(repoError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testUpdate_onSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")

        let itemToUpdate = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: false)
        // Act
        localRespo?.update(itemToUpdate) { result in
            // Assert
            switch result {
            case .success(let itemUpdated):
                XCTAssertNotNil(itemUpdated, "Item with id \(itemUpdated.id) has been updated")
            case .failure(_ ):
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testUpdate_onFailure_itemNotUpdatedError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.updateSuccess = false

        let itemToUpdate = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: false)
        // Act
        localRespo?.update(itemToUpdate) { result in
            // Assert
            switch result {
            case .success(_ ):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Error updating item \(repoError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDelete_onSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")

        let itemToDelete = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: false)
        // Act
        localRespo?.delete(itemToDelete) { result in
            // Assert
            switch result {
            case .success(let success):
                XCTAssertTrue(success, "Items has been deleted")
            case .failure(_ ):
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDelete_onFailure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.deleteSuccess = false

        let itemToDelete = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: false)
        // Act
        localRespo?.delete(itemToDelete) { result in
            // Assert
            switch result {
            case .success(_ ):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Error deleting item \(repoError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testComplete_onSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")

        let itemToUpdate = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: true)
        // Act
        localRespo?.complete(itemToUpdate) { result in
            // Assert
            switch result {
            case .success(let updatedItem):
                XCTAssertNotNil(updatedItem, "Updated item has been got")
                XCTAssertFalse(updatedItem.isComplete, "Item has been updated")
            case .failure(_ ):
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

    }

    func testComplete_onFailure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Expectation description")
        localRespo?.deleteSuccess = false

        let itemToUpdate = TodoTaskDto(id: UUID().uuidString,
                                       avatar: "",
                                       username: "TestUsername",
                                       title: "Test new title",
                                       description: "Test new description",
                                       date: Date(),
                                       isComplete: true)
        // Act
        localRespo?.complete(itemToUpdate) { result in
            // Assert
            switch result {
            case .success(_ ):
                break
            case .failure(let repoError):
                XCTAssertNotNil(repoError, "Error updating item \(repoError.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

    }
}
