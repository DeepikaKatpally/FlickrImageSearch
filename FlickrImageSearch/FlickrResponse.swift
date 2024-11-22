//
//  FlickrResponse.swift
//  FlickrImageSearch
//
//  Created by Deepika Katpally on 11/21/24.
//


import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrImage]
}

// MARK: - FlickrImage
struct FlickrImage: Codable, Identifiable {
    let id: UUID = UUID()
    
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author, authorID, tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorID = "author_id"
        case tags
    }
}

// MARK: - Media
struct Media: Codable {
    let m: String
}

