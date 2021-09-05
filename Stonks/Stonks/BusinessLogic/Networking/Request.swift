//
//  Request.swift
//  Stonks
//
//  Created by Тимур Таймасов on 04.09.2021.
//

import Foundation

/// Абстракция запроса
public protocol Request {
    
    /// Базовый URL запроса
    var baseURL: String { get }
    
    /// Путь запроса (напр. /stock/(symbol)/quote)
    var path: String { get }
    
    /// Метод запроса
    var method: HTTPMethod { get }
    
    /// Параметры запроса. Передаются с телом запроса или URL
    var parameters: RequestParams { get }
    
    /// Какой тип данных мы ожидаем на выходе Data/JSON
    var responseDataType: DataType { get }
    
    /// Тип доступа (token/sandbox/notoken)
    var accessType: AccessType { get }
}

public enum DataType {
    case JSON
    case Data
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
    case empty
}

public enum AccessType {
    case token(token: String)
    case sandboxToken(token: String)
    case noToken
}


