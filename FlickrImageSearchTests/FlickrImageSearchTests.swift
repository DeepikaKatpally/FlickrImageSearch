//
//  FlickrImageSearchTests.swift
//  FlickrImageSearchTests
//
//  Created by Deepika Katpally on 11/21/24.
//

import XCTest
@testable import FlickrImageSearch

final class FlickrImageSearchTests: XCTestCase {
    
    private var viewModel: FlickrImageSearchViewModel!
    private var mockService: MockFlickrService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockFlickrService()
        viewModel = FlickrImageSearchViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.images.isEmpty, "Images should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false initially")
        XCTAssertEqual(viewModel.searchText, "", "searchText should be empty initially")
    }
    
    func testSearchTextUpdatesTriggerFetch() {
        let expectation = self.expectation(description: "Images should be updated after search")
        
        // Mock data
        let mockImages = [FlickrImage(title: "mock image", link: "https://www.flickr.com/photos/196506958@N06/54156811859/", media: .init(m: "https://live.staticflickr.com/65535/54156811859_1bac512aeb_m.jpg"), dateTaken: "2024-11-20T21:05:39-08:00", description: " mock description ", published: "2024-11-22T04:02:10Z", author: "nobody@flickr.com (\"donovan_terry\")", authorID: "196506958@N06", tags: "chrysanthemum flower nikon z9 105mm polarizer focusstacking focusstack")]
        mockService.fetchImagesPublisherResult = Just(mockImages)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Observe changes to images
        viewModel.$images
            .dropFirst()
            .sink { images in
                XCTAssertEqual(images.count, 1, "Images count should match the mock response")
                XCTAssertEqual(images.first?.title, "mock image", "Image title should match the mock response")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger the pipeline
        viewModel.searchText = "Nature"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testErrorHandling() {
        let expectation = self.expectation(description: "ViewModel should handle errors gracefully")
        
        // Simulate an error in the service
        mockService.fetchImagesPublisherResult = Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
        
        // Observe changes to images
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, "The operation couldn’t be completed. (NSURLErrorDomain error -1011.)", "Images should remain empty when an error occurs")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger the pipeline
        viewModel.searchText = "ErrorTest"
        
        wait(for: [expectation], timeout: 2.0)
    }
}

import Combine
import Foundation

class MockFlickrService: FlickrServiceProtocol {
    var fetchImagesPublisherResult: AnyPublisher<[FlickrImage], Error> = Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    func fetchImagesPublisher(for tags: String) -> AnyPublisher<[FlickrImage], Error> {
        return fetchImagesPublisherResult
    }
}

