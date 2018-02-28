//
//  Duck_Duck_GoTests.swift
//  Duck Duck GoTests
//
//  Created by Parthiban on 2/28/18.
//  Copyright © 2018 Ossum. All rights reserved.
//

import XCTest
@testable import Duck_Duck_Go

class Duck_Duck_GoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        //comment - enable to test
//        self.testServiceCall()

        self.testPerformanceExample()

    }
    
    func testServiceCall() {
        
        ServiceManager.sharedInstance.getResultsFor(searchText: "seinfeld+characters", completion: { error, response in
            
            if let err = error {
                XCTAssert(false, err.localizedDescription)
            }
            else {
                
                guard let respData = response else {
                    
                    XCTAssert(false, "getResultsFor seinfeld+characters failed - response nil")
                    
                    return
                }
                
                if respData.count > 0 {
                    XCTAssert(true, "getResultsFor seinfeld+characters exists - success")
                }
                else {
                    XCTAssert(false, "getResultsFor seinfeld+characters des not exist - fail")
                }
            }
        })

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
            ServiceManager.sharedInstance.getResultsFor(searchText: "seinfeld+characters", completion: { error, response in
                
                if let err = error {
                    XCTAssert(false, err.localizedDescription)
                }
                else {
                    
                    guard let respData = response else {
                        
                        XCTAssert(false, "getResultsFor seinfeld+characters failed - response nil")
                        
                        return
                    }
                    
                    if respData.count > 0 {
                        XCTAssert(true, "getResultsFor seinfeld+characters exists - success")
                    }
                    else {
                        XCTAssert(false, "getResultsFor seinfeld+characters des not exist - fail")
                    }
                }
            })

        }
    }
    
}
