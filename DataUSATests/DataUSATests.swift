//
//  DataUSATests.swift
//  DataUSATests
//
//  Created by Tiemi Matsumoto on 29/08/2024.

import XCTest
@testable import DataUSA

protocol DataUSStaticApiClient {
    static func getPopulationData(populationDataType: String, success: @escaping (PopulationType?) -> Void, failure: @escaping (PopulationError?) -> Void)
}

class MockDataUSApiClient: DataUSStaticApiClient {
    static var shouldReturnError = false
    static var mockResponse: PopulationType?

    static func getPopulationData(populationDataType: String, success: @escaping (PopulationType?) -> Void, failure: @escaping (PopulationError?) -> Void) {
        if shouldReturnError {
            failure(.invalidData)
        } else {
            success(mockResponse)
        }
    }
}

class MockPopulationService: PopulationService {
    var didCallGetPopulationSuccess = false
    var didCallGetPopulationFailWithError = false
    var receivedPopulation: [PopulationModel]?
    var receivedError: String?

    func getPopulationSuccess(population: [PopulationModel]) {
        didCallGetPopulationSuccess = true
        receivedPopulation = population
    }

    func getPopulationFailWithError(error: String) {
        didCallGetPopulationFailWithError = true
        receivedError = error
    }
}

class PopulationInteractorTests: XCTestCase {

    var interactor: PopulationInteractor!
    var mockService: MockPopulationService!

    override func setUp() {
        super.setUp()
        interactor = PopulationInteractor()
        mockService = MockPopulationService()
        interactor.delegate = mockService
        interactor.dataUSApiClient = MockDataUSApiClient.self
    }

    override func tearDown() {
        interactor = nil
        mockService = nil
        super.tearDown()
    }

    func testGetPopulation_WithEmptyDataType_ShouldReturnError() {
        // Given
        let emptyDataType = ""

        // When
        interactor.getPopulation(dataType: emptyDataType)

        // Then
        XCTAssertTrue(mockService.didCallGetPopulationFailWithError)
        XCTAssertEqual(mockService.receivedError, "Invalid Data Type")
    }

    func testGetPopulation_WithValidDataType_ShouldReturnSuccess() {
        // Given
        let validDataType = "Nation"
        MockDataUSApiClient.shouldReturnError = false
        MockDataUSApiClient.mockResponse = .nation([
            NationPopulation(idNation: "1", nation: "USA", idYear: "2023", year: "2023", population: 331000000, slugNation: "usa")
        ])

        // When
        interactor.getPopulation(dataType: validDataType)

        // Then
        XCTAssertTrue(mockService.didCallGetPopulationSuccess)
        XCTAssertEqual(mockService.receivedPopulation?.count, 1)
        XCTAssertEqual(mockService.receivedPopulation?.first?.location, "USA")
    }

    func testGetPopulation_WithApiError_ShouldReturnError() {
        // Given
        let validDataType = "Nation"
        MockDataUSApiClient.shouldReturnError = true

        // When
        interactor.getPopulation(dataType: validDataType)

        // Then
        XCTAssertTrue(mockService.didCallGetPopulationFailWithError)
        XCTAssertEqual(mockService.receivedError, "Data is invalid")
    }

    func testGetPopulation_WithInvalidURL_ShouldReturnError() {
        // Given
        let validDataType = "Nation"
        MockDataUSApiClient.shouldReturnError = true
        MockDataUSApiClient.mockResponse = nil

        // When
        interactor.getPopulation(dataType: validDataType)

        // Then
        XCTAssertTrue(mockService.didCallGetPopulationFailWithError)
        XCTAssertEqual(mockService.receivedError, "Data is invalid")
    }
}
