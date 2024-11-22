//
//  FlickrImageSearchView.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//

import SwiftUI

struct FlickrImageSearchView: View {
    @StateObject var viewModel: FlickrImageSearchViewModel

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    // Search Bar
                    TextField("Search for images...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Progress Bar
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding(.horizontal)
                    }
                }

                // Image Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(viewModel.images) { image in
                            NavigationLink(destination: FlickrImageDetailsView(image: image)) {
                                AsyncImage(url: URL(string: image.media.m)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Color.red.frame(width: 100, height: 100)
                                    } else {
                                        Color.gray.frame(width: 100, height: 100)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}


//#Preview {
//    FlickrImageSearchView()
//}
