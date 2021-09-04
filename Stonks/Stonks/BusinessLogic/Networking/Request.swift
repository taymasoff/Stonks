//
//  Request.swift
//  Stonks
//
//  Created by Тимур Таймасов on 04.09.2021.
//

import Foundation

/// Абстракция запроса
public protocol Request {
    
    /// Путь запроса (напр. /stock/(symbol)/quote)
    var path: String { get }
    
    /// Метод запроса
    var method: HTTPMethod { get }
    
    /// Параметры запроса. Передаются с телом запроса или URL
    var parameters: RequestParams { get }
    
    /// Дополнительные заголовки к запросу
    var headers: [String: Any]? { get }
    
    /// Какой тип данных мы ожидаем на выходе Data/JSON
    var dataType: DataType { get }
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
}
