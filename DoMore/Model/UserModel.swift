//
//  UserModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import Foundation
import SwiftUI

struct UserModel: Codable {
    enum LoginMethod: String, Codable {
        case apple
        case mobile
    }
    
    let id: String
    let username: String
    var profilePicture: String?
    var points: Int
    var totalBlockedTime: TimeInterval?
    var userColorString: String?
    var userColor: Color? {
        get { userColorString.flatMap { Color(hex: $0) } }
        set { userColorString = newValue?.toHex() }
    }
    var isDev: Bool? = false
    var loginMethod: LoginMethod?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profilePicture
        case points
        case userColorString = "userColor"
        case isDev
        case loginMethod
    }
}
