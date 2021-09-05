//
//  Company.swift
//  Stonks
//
//  Created by Тимур Таймасов on 05.09.2021.
//

import UIKit

/// Модель компании
struct Company: Codable {
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
}
