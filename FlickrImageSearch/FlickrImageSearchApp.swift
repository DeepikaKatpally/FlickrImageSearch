//
//  FlickrImageSearchApp.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//

import SwiftUI

@main
struct FlickrImageSearchApp: App {
    var body: some Scene {
        WindowGroup {
            FlickrImageSearchView(viewModel: FlickrImageSearchViewModel(service: FlickrService()))
        }
    }
}
