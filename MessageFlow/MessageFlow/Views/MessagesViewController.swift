//
//  MessagesViewController.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import UIKit
import Combine

class MessagesViewController: UIViewController {
    @IBOutlet weak var commandField: UITextField!
    
    private let viewModel: MessagesViewModel = MessagesViewModel()
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commandField.autocorrectionType = .no
        
        viewModel.configure()
        cancellable = viewModel.publisher.sink { newMessages in
            for message in newMessages {
                print(message.receivedAt())
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cancellable?.cancel()
    }
}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        
        let commandText = textField.text
        textField.text = .empty
        if let text = commandText?.lowercased() {
            self.viewModel.postCommand(text)
        }
        return false
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsForSections[safe: section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

