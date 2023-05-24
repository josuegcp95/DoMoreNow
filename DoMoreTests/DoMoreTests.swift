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
        let sut = AddEditTaskVC()
        sut.nameTextField.text = "Boxing"
        sut.timeTextField.text = "45b"
        XCTAssertEqual(sut.nameTextField.text, "Boxing")
        XCTAssertFalse(sut.timeTextField.text!.isNumbersOnly)
    }
    
    func testCanSetTimerLabel() {
        let sut = MusicPlayerVC()
        sut.setTimerLabel(1800)
        XCTAssertTrue(sut.timerLabel.text == "30:00")
    }
    
    func testCanSetSongDurationLabel() { 
        let sut = MusicPlayerVC()
        sut.setSongDurationLabel(2700)
        XCTAssertTrue(sut.songDuration.text == "45:00")
    }
}
