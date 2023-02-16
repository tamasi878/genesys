//
//  MessagesViewModel.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import UIKit
import Combine

private extension String {
    static let dummyJsonUrl = "https://dummyjson.com/products"
    static let timeFormatString = "HH:mm:ss"
}

final class MessagesViewModel {
    var rowsForSections: [[MessageData]] = [[MessageData]]()
    var sections: [String] = [String]()
    var publisher: PassthroughSubject<[MessageData], Never> = PassthroughSubject<[MessageData], Never>()

    private var manager: MessageManager?
    
    func configure() {
        manager = MessageManager(url: .dummyJsonUrl)
        manager?.delegate = self
    }
    
    func postCommand(_ command: String) {
        let commandValue = MessageManager.Commands.init(rawValue: command) ?? .none
        if commandValue != .none {
            manager?.executeCommand(commandValue)
            sections.append(commandValue.rawValue.uppercased())
            rowsForSections.append([MessageData]())
            publisher.send([MessageData]())
        }
    }
        
    func received(of message: MessageData) -> String {        
        let formatter = DateFormatter()
        formatter.dateFormat = .timeFormatString
        return formatter.string(from: message.receivedAt())
    }
    
    func setImage(for message: MessageData, in view: UIImageView) {
        guard let url = message.thumbnail else { return }
        
        ImageService().download(from: url) { image in
            view.image = image
        }
    }
}

extension MessagesViewModel: MessageManagerDelegate {
    func newMessagesArrived(_ messages: [MessageData]) {
        if var lastSection = rowsForSections.last {
            lastSection.append(contentsOf: messages)
        }
        publisher.send(messages)
    }
    
    func managerResetDone() {
        rowsForSections.removeAll()
        sections.removeAll()
    }
}
