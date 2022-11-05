//
//  Item.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import Foundation
import MusicKit

struct Item: Codable, Equatable, Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = MusicItemID.RawValue()
    let name: String
    let artist: String
    let imageURL: URL?
    let duration: Double?
}

