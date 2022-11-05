//
//  String+Ext.swift
//  DoMore
//
//  Created by Josue Cruz on 10/28/22.
//

import Foundation

extension String {
    
    var isNumbersOnly: Bool {
        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
        let stringFromTextField = NSCharacterSet.init(charactersIn: self)
        return numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
    }
}
