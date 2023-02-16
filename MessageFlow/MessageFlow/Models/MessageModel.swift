//
//  MessageModel.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import Foundation

struct MessageModel: Decodable {
    let products: [MessageData]
}

class MessageData: Decodable {
    let description: String?
    let thumbnail: String?
    
    private var receivedAtTime: Date?
        
    func receivedAt() -> Date {
        if receivedAtTime == nil {
            receivedAtTime = Date()
        }
        return receivedAtTime ?? Date()
    }
}
