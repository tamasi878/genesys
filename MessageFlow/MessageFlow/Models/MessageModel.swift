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
    
    private var isCommand: Bool? = false
    private var receivedAtTime: Date?
    
    init(title: String) {
        description = title
        thumbnail = nil
        isCommand = true
    }
        
    func receivedAt() -> Date {
        if receivedAtTime == nil {
            receivedAtTime = Date()
        }
        return receivedAtTime ?? Date()
    }
    
    func isCommandName() -> Bool {
        return isCommand ?? false
    }
}
