//
//  DoMoreTests.swift
//  DoMoreTests
//
//  Created by Josue Cruz on 11/5/22.
//

import XCTest
@testable import DoMore

final class DoMoreTests: XCTestCase {
    
    func testCanAuthorizeMusicKit() async throws {
        await NetworkManager.shared.requestAuthorization { error in
                XCTAssertNil(error)
        }
    }
    
    func testCanFetchMusic() async throws {
        await NetworkManager.shared.fetchMusic(term: "512") { result in
            switch result {
            case .success(let music):
                XCTAssertFalse(music.isEmpty)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
