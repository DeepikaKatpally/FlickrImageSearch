//
//  FlickrService.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//

import Foundation
import Combine

protocol FlickrServiceProtocol {
    func fetchImagesPublisher(for tags: String) -> AnyPublisher<[FlickrImage], Error>
}

class FlickrService: FlickrServiceProtocol {
    func fetchImagesPublisher(for tags: String) -> AnyPublisher<[FlickrImage], Error> {
        let formattedTags = tags.replacingOccurrences(of: " ", with: ",")
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(formattedTags)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .map(\.items)
            .eraseToAnyPublisher()
    }
}

