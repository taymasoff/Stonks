//
//  NetworkManager.swift
//  Stonks
//
//  Created by Тимур Таймасов on 05.09.2021.
//

import UIKit

public enum NetworkErrors: Error {
    case badInput
    case noData
    case invalidResponse
    case invalidStatusCode(Int)
    case failedToDecode(String)
}

class NetworkManager {
    
    func perform<T: Decodable>(request: Request,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        // Ответ должен возвращаться в главном потоке
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let req = try? self.prepareURLRequest(for: request) else {
            completionOnMain(.failure(NetworkErrors.badInput))
            return
        }
        
        let urlSession = URLSession.shared.dataTask(with: req) { data, response, error in
            // Сначала проверяем на ошибку
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            // Проверяем валидный ли ответ и удачен ли запрос (по статус коду)
            guard let urlResponse = response as? HTTPURLResponse else {
                return completionOnMain(.failure(NetworkErrors.invalidResponse))
            }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(
                    .failure(NetworkErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            // Декодируем дату
            guard let data = data else { return }
            switch request.responseDataType {
            case .JSON:
                // Если ответ в виде JSON'а, пробуем декодировать в нашу модель
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionOnMain(.success(decodedData))
                } catch {
                    completionOnMain(
                        .failure(NetworkErrors.failedToDecode(error.localizedDescription)))
                }
            case .Data:
                // Если ответ Data, пробуем преобразовать в изображение
                guard let image = UIImage(data: data) else {
                    return completionOnMain(
                        .failure(NetworkErrors.failedToDecode("Невозможно представить data как UIImage")))
                }
                completionOnMain(.success(Logo(logo: image) as! T))
            }
        }
        
        urlSession.resume()
    }
}

// MARK: Сборка URLRequest'а
extension NetworkManager {
    /// Метод, собирающий HTTPRequest
    /// - Parameter request: объект типа Request
    /// - Throws: NetworkErrors
    /// - Returns: Request
    func prepareURLRequest(for request: Request) throws -> URLRequest {
        // Собираем URL
        guard var urlComponents = URLComponents(
                string: "\(request.baseURL + request.path)"),
              let url = urlComponents.url else {
            throw NetworkErrors.badInput
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Добавляем параметры
        switch request.parameters {
        case .body(let params):
            // Если параметры в теле запроса
            if let params = params as? [String: String] {
                urlRequest.httpBody = try JSONSerialization.data(
                    withJSONObject: params,
                    options: .init(rawValue: 0))
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params):
            // Если параметры в URL
            if let params = params as? [String: String] {
                let queryParameters = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                urlComponents.queryItems = queryParameters
            } else {
                throw NetworkErrors.badInput
            }
        case .empty:
            // Если доп. параметров нет, просто пропускаем
            break
        }
        
        // Добавляем токен, если он есть
        switch request.accessType {
        case .token(let token), .sandboxToken(let token):
            let tokenParameter = URLQueryItem(name: "token", value: token)
            // Если queryItems уже есть, добавляем еще один элемент, если нет - создаем
            if var queryParameters = urlComponents.queryItems {
                queryParameters.append(tokenParameter)
                urlComponents.queryItems = queryParameters
            } else {
                urlComponents.queryItems = [tokenParameter]
            }
        case .noToken:
            // Если токена нет, ничего не добавляем
            break
        }
        
        // Собираем реквест еще раз, с дополнительными параметрами
        urlRequest.url = urlComponents.url
        // Добавляем http метод
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
