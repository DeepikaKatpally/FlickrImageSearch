//
//  FlickrImageDetailsView.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//

import SwiftUI

struct FlickrImageDetailsView: View {
    let image: FlickrImage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: image.media.m)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else if phase.error != nil {
                        Color.red.frame(height: 200)
                    } else {
                        Color.gray.frame(height: 200)
                    }
                }

                Text("Title: \(image.title)")
                    .font(.headline)
                    .padding()

                Text(image.description)
                    .font(.body)
                    .padding()
                
                Text("Author: \(image.author)")
                    .padding()

                Text("Published: \(formattedDate(image.published))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }
            .navigationTitle("Image Details")
        }
    }

    private func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "Invalid Date" }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        
        return displayFormatter.string(from: date)
    }
}

