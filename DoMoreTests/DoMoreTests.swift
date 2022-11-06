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
    
    func testCanValidateTextFields() {
        let testVC = AddEditTaskVC()
        testVC.nameTextField.text = "Boxing"
        testVC.timeTextField.text = "45b"
        XCTAssertEqual(testVC.nameTextField.text, "Boxing")
        XCTAssertFalse(testVC.timeTextField.text!.isNumbersOnly)
    }
    
    func testCanSetTimerLabel() {
        let destVC = MusicPlayerVC()
        destVC.setTimerLabel(1800)
        XCTAssertTrue(destVC.timerLabel.text == "30:00")
    }
    
    func testCanSetSongDurationLabel() { 
        let destVC = MusicPlayerVC()
        destVC.setSongDurationLabel(2700)
        XCTAssertTrue(destVC.songDuration.text == "45:00")
    }
}
