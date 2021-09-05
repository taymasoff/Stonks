//
//  StockRequests.swift
//  Stonks
//
//  Created by Тимур Таймасов on 04.09.2021.
//

import Foundation

/// Класс запросов для списка компаний, инфорации по акциям и лого
public enum StockRequests: Request {

    case companies
    case companyStock(symbol: String)
    case companyLogoURL(symbol: String)
    case companyLogo(fullPath: String)
    
    /// Базовый URL запроса (у лого другой, поэтому разные)
    public var baseURL: String {
        switch self {
        case .companyLogo(_):
            return ""
        default:
            return "https://cloud.iexapis.com/stable"
        }
    }
    
    /// Путь запроса
    public var path: String {
        switch self {
        case .companies:
            return "/stock/market/list/gainers"
        case .companyStock(let symbol):
            return "/stock/\(symbol)/quote"
        case .companyLogoURL(let symbol):
            return "/stock/\(symbol)/logo"
        case .companyLogo(let fullPath):
            return "\(fullPath)"
        }
    }
    
    /// Метод запроса (у нас везде GET)
    public var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    /// Дополнительные параметры запроса (пока не нужны)
    public var parameters: RequestParams {
        switch self {
        default:
            return .empty
        }
    }
    
    /// Тип доступа (для лого токен не нужен, остальные по токену)
    public var accessType: AccessType {
        switch self {
        case .companyLogo(_):
            return .noToken
        default:
            return .token(token: API.token)
        }
    }
    
    /// В каком формате ожидается получить ответ (JSON/Data)
    public var responseDataType: DataType {
        switch self {
        case .companyLogo(_):
            return .Data
        default:
            return .JSON
        }
    }

}
