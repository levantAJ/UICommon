//
//  Utils.swift
//  UICommon
//
//  Created by Le Tai on 10/17/15.
//  Copyright © 2015 AJ. All rights reserved.
//

import UIKit

class Utils: NSObject {}

extension String {
    public func sizeWithFont(font: UIFont, forWidth width: CGFloat) -> CGSize {
        let fString = self as NSString
        let maximumSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = fString.boundingRect(with: maximumSize,
                                        options: NSStringDrawingOptions.truncatesLastVisibleLine.union(NSStringDrawingOptions.usesLineFragmentOrigin),
                                        attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return rect.size
    }
}
