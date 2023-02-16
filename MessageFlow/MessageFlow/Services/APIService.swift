//
//  Service.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import Foundation

private extension String {
    static let queryParamaters = "limit=%d&skip=%d"
}

final class APIService: BaseService {
    private var dataTask: URLSessionDataTask?
    
    func getMessages(url: String,
                     limit: Int,
                     skip: Int,
                     completion: @escaping (Result<[MessageData], Error>) -> Void)
    {
        let session = URLSession(configuration: .default)
        
        if var components = URLComponents(string: url) {
            components.query = String(format: .queryParamaters, limit, skip)
            guard let url = components.url else {
                return
            }
            dataTask = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let result = try jsonDecoder.decode(MessageModel.self, from: data)
                        completion(.success(result.products))
                    } catch (let error) {
                        completion(.failure(error))
                    }
                }
            }
            dataTask?.resume()
        }
    }
}
