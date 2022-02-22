//
//  WebViewControllerTest.swift
//  Softgames TestTests
//
//  Created by Hamza Ahmed on 21/02/2022.
//

import XCTest
@testable import Softgames_Test
class WebViewControllerTest: XCTestCase {
    var webViewExpectation: XCTestExpectation!
    var sut:WebViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        setupViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    private func setupViewController(){
        let storyboard = UIStoryboard(name: Constant.storyboardIdentifier, bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        guard let vc : WebViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else{
            return XCTFail("Could not instantiate SearchViewController")
        }
        sut = vc
        UIApplication.shared.windows.first{ $0.isKeyWindow }!.rootViewController = UINavigationController.init(rootViewController: vc)
        sut.loadViewIfNeeded()
    }
    func testWebViewExist() {
       XCTAssertNotNil(sut.webView, "Controller should have a web view")
    }
}
