//
//  Rick_MortyTests.swift
//  Rick&MortyTests
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import XCTest
import Combine
@testable import Rick_Morty

final class NetworkManagerTests: XCTestCase {
    
    var listVM: CharactersListViewModel!
    
    override func setUp() {
        super.setUp()
        listVM = CharactersListViewModel(networkManager: MockHTTPClient())
    }
    
    override func tearDown() {
        super.tearDown()
        listVM = nil
    }
    
    func testGetAllCharactersSuccessfully() {
        let expectation = self.expectation(description: "Loading characters")
          
          listVM.showCharacters()
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              XCTAssertEqual(self.listVM.displayedCharacters.value.count, 1)
              expectation.fulfill()
          }
          
          waitForExpectations(timeout: 2.0, handler: nil)
      }
    }

