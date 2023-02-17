//
//  MessagesViewController.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import UIKit
import Combine

private extension String {
    static let messageCellIdentifier = "MessageCell"
    static let commandCellIdentifier = "CommandCell"
}

private extension CGFloat {
    static let baseMargin = 16.0
}

class MessagesViewController: UIViewController {
    @IBOutlet weak var commandField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commandFieldBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: MessagesViewModel = MessagesViewModel()
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commandField.autocorrectionType = .no
        
        viewModel.configure()
        cancellable = viewModel.publisher.sink { (lastIndex, newMessageCount) in
            DispatchQueue.main.async {
                var indexes: [IndexPath] = [IndexPath]()
                for row in 0...newMessageCount - 1 {
                    indexes.append(IndexPath(row: lastIndex + row, section: 0))
                }
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexes, with: .automatic)
                self.tableView.endUpdates()
                let lastRowIndex = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
                self.tableView.scrollToRow(at: lastRowIndex, at: .bottom, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessagesViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessagesViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cancellable?.cancel()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        self.commandFieldBottomConstraint.constant = .baseMargin + keyboardSize.height
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.commandFieldBottomConstraint.constant = .baseMargin
        self.view.layoutIfNeeded()
    }
}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let commandText = textField.text
        textField.text = .empty
        if let text = commandText?.lowercased() {
            self.viewModel.postCommand(text)
        }
        textField.resignFirstResponder()

        return false
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datasource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.datasource[indexPath.row]
        
        if message.isCommandName() {
            let cell = tableView.dequeueReusableCell(withIdentifier: .commandCellIdentifier, for: indexPath) as! CommandCell
            let decorator = MessageDecorator(with: message.description ?? .empty,
                                             isCommand: true,
                                             dateString: viewModel.received(of: message))
            cell.configure(with: decorator)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: .messageCellIdentifier, for: indexPath) as! MessageCell
        let decorator = MessageDecorator(with: message.description ?? .empty,
                                         isCommand: false,
                                         dateString: viewModel.received(of: message))
        cell.configure(with: decorator)
        viewModel.setImage(for: message, in: cell.thumbnailImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

