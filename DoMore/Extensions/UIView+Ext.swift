//
//  UIView+Ext.swift
//  DoMore
//
//  Created by Josue Cruz on 10/20/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
