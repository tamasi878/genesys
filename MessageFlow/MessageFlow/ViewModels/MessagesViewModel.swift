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
    var datasource: [MessageData] = [MessageData]()
    var publisher: PassthroughSubject<(Int, Int), Never> = PassthroughSubject<(Int, Int), Never>()

    private var manager: MessageManager?
    
    func configure() {
        manager = MessageManager(url: .dummyJsonUrl)
        manager?.delegate = self
    }
    
    func postCommand(_ command: String) {
        let commandValue = MessageManager.Commands.init(rawValue: command) ?? .none
        if commandValue != .none {
            let commandData = MessageData(title: commandValue.rawValue.uppercased())
            let lastIndex = datasource.count
            datasource.append(commandData)
            publisher.send((lastIndex, 1))
            manager?.executeCommand(commandValue)
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
            DispatchQueue.main.async {
                view.image = image
            }
        }
    }
}

extension MessagesViewModel: MessageManagerDelegate {
    func newMessagesArrived(_ messages: [MessageData]) {
        let lastIndex = datasource.count
        datasource.append(contentsOf: messages)
        publisher.send((lastIndex, messages.count))
    }
    
    func managerResetDone() {
        datasource.removeAll()
    }
}
