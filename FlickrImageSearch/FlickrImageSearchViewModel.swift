//
//  FlickrImageSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//

import Foundation
import Combine

class FlickrImageSearchViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = "" // Input bound to the search bar.
    @Published var errorMessage: String = ""

    private let service: FlickrServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: FlickrServiceProtocol) {
        self.service = service
        setupSearchPipeline()
    }

    private func setupSearchPipeline() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map { [weak self, service] text in
                self?.isLoading = true
                return service.fetchImagesPublisher(for: text)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] images in
                self?.isLoading = false
                self?.images = images
            }
            .store(in: &cancellables)
    }
}

