//
//  WebViewModelTest.swift
//  Softgames TestTests
//
//  Created by Hamza Ahmed on 21/02/2022.
//

import XCTest
@testable import Softgames_Test

class WebViewModelTest: XCTestCase {
   
    var  sut:WebViewModel!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut =  WebViewModelImplementation()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    func testGetAgeFunction() {
        let age = sut.calculateAge(dateOfBirth: "1991-01-20")
        XCTAssertEqual(age, 31)
    }
    func testCreateJsonForJavaScript() {
        let json = ["fullName":"Hamza Ahmed"]
        let jsonString = sut.createJsonForJavaScript(for:json)
        XCTAssertEqual(jsonString, "{  \"fullName\" : \"Hamza Ahmed\"}")
    }
}
