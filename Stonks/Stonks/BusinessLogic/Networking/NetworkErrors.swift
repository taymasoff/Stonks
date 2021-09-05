//
//  NetworkErrors.swift
//  Stonks
//
//  Created by Тимур Таймасов on 05.09.2021.
//

import Foundation

/// Все возможные ошибки сети
public enum NetworkErrors: Error {
    case badInput
    case noData
    case invalidResponse
    case invalidStatusCode(Int)
    case failedToDecode(String)
}

// Описания ошибок
extension NetworkErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badInput:
            return NSLocalizedString("😢 В запросе были переданы некорректные данные", comment: "Bad Input")
        case .noData:
            return NSLocalizedString("😢 Запрос не вернул никаких данных", comment: "No Data")
        case .invalidResponse:
            return NSLocalizedString("😢 Неудачный ответ", comment: "Invalid Response")
        case .invalidStatusCode(let code):
            return NSLocalizedString("😢 Получен код ошибки: \(code)", comment: "Invalid Status Code")
        case .failedToDecode(let message):
            return NSLocalizedString("😢 \(message)", comment: "Failed to Decode Data")
        }
    }
}
