//
//  Profile.swift
//  ProfileSofi
//
//  Created by Phil Wright on 6/12/22.
//

import Foundation

struct Profile : Codable {
    var id: Int
    var bio: String
    var firstName: String
    var lastName: String
    var title: String
    var photoURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case photoURL = "avatar"
        case bio
        case firstName
        case lastName
        case title
        case id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: CodingKeys.firstName)
        lastName = try values.decode(String.self, forKey: CodingKeys.lastName)
        bio = try values.decode(String.self, forKey: CodingKeys.bio)
        title = try values.decode(String.self, forKey: CodingKeys.title)
        
        let urlString = try values.decode(String.self, forKey: CodingKeys.photoURL)
        
        if let url = URL(string: urlString) {
            photoURL = url
        }
        
        let idString = try values.decode(String.self, forKey: CodingKeys.id)
        id = Int(idString) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(firstName, forKey: CodingKeys.firstName)
        try container.encode(lastName, forKey: CodingKeys.lastName)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(bio, forKey: CodingKeys.bio)
        try container.encode(photoURL, forKey: CodingKeys.photoURL)
    }
}

