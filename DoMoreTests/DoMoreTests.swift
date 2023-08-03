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
        // Arrange
        let sut = AddEditTaskVC()
        
        // Act
        sut.nameTextField.text = "Boxing"
        sut.timeTextField.text = "45b"
        
        // Assert
        XCTAssertEqual(sut.nameTextField.text, "Boxing")
        XCTAssertFalse(sut.timeTextField.text!.isNumbersOnly)
    }
    
    func testCanSetTimerLabel() {
        // Arrange
        let sut = MusicPlayerVC()
        
        // Act
        sut.setTimerLabel(1800)
        
        // Assert
        XCTAssertTrue(sut.timerLabel.text == "30:00")
    }
    
    func testCanSetSongDurationLabel() {
        // Arrange
        let sut = MusicPlayerVC()
        
        // Act
        sut.setSongDurationLabel(2700)
        
        // Assert
        XCTAssertTrue(sut.songDuration.text == "45:00")
    }
}
