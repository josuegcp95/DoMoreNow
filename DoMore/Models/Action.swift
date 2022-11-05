//
//  Action.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import Foundation

struct Action: Codable {
    var name: String
    var time: Int
    var songs: [Item]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case time
        case songs
    }
    
    init(name: String, time: Int, songs: [Item]? = []) {
        self.name = name
        self.time = time
        self.songs = songs
    }
}
