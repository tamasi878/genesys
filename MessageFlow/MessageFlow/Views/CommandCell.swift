//
//  CommandCell.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 17..
//

import Foundation
import UIKit

final class CommandCell: UITableViewCell {
    @IBOutlet weak var commandText: UILabel!

    func configure(with decorator: MessageDecorator) {
        contentView.backgroundColor = decorator.cellBackgroundColor
        backgroundColor = decorator.cellBackgroundColor
        commandText.attributedText = decorator.attributedTitle
    }
}
