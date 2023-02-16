//
//  BaseService.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import Foundation


protocol BaseService {
    func getMessages(url: String,
                     limit: Int,
                     skip: Int,
                     completion: @escaping (Result<[MessageData], Error>) -> Void)
}
