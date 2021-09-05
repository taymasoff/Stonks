//
//  Logo.swift
//  Stonks
//
//  Created by Тимур Таймасов on 05.09.2021.
//

import UIKit

// Необходимо для корректной работы NetworkManager (требуется Decodable результат)
struct Logo: Codable {
    let logo: Data
    
    public init(logo: UIImage) {
        self.logo = logo.pngData()!
    }
}

struct LogoURL: Codable {
    let url: String
}
