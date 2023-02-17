//
//  MessageCell.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 16..
//

import Foundation
import UIKit

final class MessageCell: UITableViewCell {
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!

    func configure(with decorator: MessageDecorator) {
        contentView.backgroundColor = decorator.cellBackgroundColor
        backgroundColor = decorator.cellBackgroundColor
        cellText.attributedText = decorator.attributedTitle
        dateText.attributedText = decorator.attributedDateTitle
    }
    
    override func prepareForReuse() {
        thumbnailImage.image = nil
    }
}
