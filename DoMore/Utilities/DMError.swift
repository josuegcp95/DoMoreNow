//
//  DMError.swift
//  DoMore
//
//  Created by Josue Cruz on 10/24/22.
//

import Foundation

enum DMError: String, Error {
    case unableToSave = "There was an error saving your data. Please try again later."
    case unableToRetrieve = "There was an error retrieving your data. Please try again later."
    case unableToProceed = "Please allow access/subscribe to Apple Music to continue."
    case accessDenied = "Please go to your Settings and allow access to Media & Apple Music."
    case unavailableConnection = "Please check your internet connection."
    case allFields = "Please fill out all fields."
    case onlyNumbers = "Please enter only whole numbers in time field."
}






