//
//  UserModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let username: String
    var profilePicture: String?
    var points: Int
    var isDev: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profilePicture
        case points
    }
}
