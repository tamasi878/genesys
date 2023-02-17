//
//  MessageManager.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import Foundation

extension TimeInterval {
    static let refreshTimeInSec = 5.0
    static let delaySeconds = 0.5
}

extension String {
    static let APIPrefix = "http"
}

extension Int {
    static let limit = 1
    static let initialSkip = 0
}

protocol MessageManagerDelegate: AnyObject {
    func newMessagesArrived(_ messages: [MessageData])
    func managerResetDone()
}

final class MessageManager {
    enum Commands: String {
        case start = "start"
        case stop = "stop"
        case pause = "pause"
        case resume = "resume"
        case none = ""
    }
    
    private enum States {
        case active
        case paused
        case inactive
    }

    public weak var delegate: MessageManagerDelegate?
    
    private let service: BaseService
    private let url: String!
    private var timer: Timer?
    private var previousCommand: Commands = .none
    private var skip: Int = .initialSkip
    private var managerState: States = .inactive
    
    private var stack: [MessageData] = [MessageData]()

    init(url: String) {
        self.url = url
        if url.starts(with: String.APIPrefix) {
            service = APIService()
        } else {
            service = FileService()
        }
    }
    
    func executeCommand(_ command: Commands) {
        if previousCommand == command  { return }
        
        switch(command) {
        case .start:
            if managerState != .active {
                managerState = .active
                getMessages(setTimer: true)
            }
            
        case .stop: resetManagerState()
            
        case .resume:
            if managerState == .paused {
                DispatchQueue.main.asyncAfter(deadline: .now() + .delaySeconds) {
                    self.delegate?.newMessagesArrived(self.stack)
                    self.stack.removeAll()
                }
                managerState = .active
            }
            
        case .pause: managerState = .paused
            
        default: break
        }
    }
    
    private func resetManagerState() {
        stopTimer()
        self.skip = .initialSkip
        self.stack.removeAll()
        managerState = .inactive
    }
    
    private func getMessages(setTimer: Bool) {
        self.service.getMessages(url: self.url, limit: .limit, skip: self.skip) { result in
            switch(result) {
            case .failure(let error) :
                print(error)
            
            case .success(let newMessages):
                self.skip += 1
                if self.managerState == .active {
                    self.delegate?.newMessagesArrived(newMessages)
                } else {
                    self.stack.append(contentsOf: newMessages)
                }
            }
        }
        if setTimer {
            self.startTimer()
        }
    }
    
    private func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: .refreshTimeInSec, repeats: true) {_ in
            self.getMessages(setTimer: false)
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
