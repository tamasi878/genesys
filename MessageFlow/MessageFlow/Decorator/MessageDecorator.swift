//
//  MessageDecorator.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 16..
//

import Foundation
import UIKit

final class MessageDecorator {
    private var textInCell: String?
    private var isCommandCell: Bool = false
    private var dateInCell: String?
    
    init(with text: String, isCommand: Bool, dateString: String?) {
        textInCell = text
        isCommandCell = isCommand
        dateInCell = dateString
    }
    
    var attributedTitle: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any]
        if isCommandCell {
            attributes = [.foregroundColor: UIColor.black,
                          .font: UIFont.systemFont(ofSize: 16.0)]
        } else {
            attributes = [.foregroundColor: UIColor.black,
                          .font: UIFont.systemFont(ofSize: 14.0)]
        }
        return NSAttributedString(string: textInCell ?? .empty,
                                  attributes: attributes)
    }
    
    var attributedDateTitle: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black,
                                                         .font: UIFont.systemFont(ofSize: 12.0)]
        return NSAttributedString(string: dateInCell ?? .empty,
                                  attributes: attributes)
    }

    
    var cellBackgroundColor: UIColor {
        if isCommandCell {
            return .yellow
        }
        return .green
    }
}
