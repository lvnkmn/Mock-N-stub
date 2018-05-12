import XCTest
import Quick
import Nimble
import CanMock

class MockTableViewDataSourceSpec: QuickSpec {
    
    override func spec() {
        describe("MockTableViewDataSource") {
            
            var sut: MockTableViewDataSource!
            let tableView = UITableView()
            let indexPath = IndexPath()
            var mockFailureHandler: MockFailureHandler!
            
            context("Mocking", {
                beforeEach {
                    sut = MockTableViewDataSource()
                }
                
                context("Expecting failures", {
                    beforeEach {
                        mockFailureHandler = MockFailureHandler()
                        sut.given("failureHandler", willReturn: mockFailureHandler)
                        mockFailureHandler.expect(callTo: "fail(with:at:)")
                    }
                    
                    it("Fails when expected methods are not called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)))
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Fails when expected methods are not called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:cellForRowAt:)))
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Fails when expected methods are not called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:cellForRowAt:)))
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)))
                        _ = sut.tableView(tableView, cellForRowAt: indexPath)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Fails when expected methods are not called with arguments that don't match", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)), withArgumentsThatMatch: ArgumentMatcher(matcher: { (args: (UITableView, Int)) -> Bool in
                            return args.0 === tableView && args.1 == 42
                        }))
                        _ = sut.tableView(tableView, numberOfRowsInSection: 22)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Fails when expected methods are called with incorrect matcher type", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)), withArgumentsThatMatch: ArgumentMatcher(matcher: { (args: (UITableView, Int, Any)) -> Bool in
                            return args.0 === tableView && args.1 == 42
                        }))
                        _ = sut.tableView(tableView, numberOfRowsInSection: 42)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                })
                
                context("Not expecting failures", {
                    
                    it("Doesn't fail when expected methods are called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)))
                        _ = sut.tableView(tableView, numberOfRowsInSection: 42)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Doesn't fail when expected methods are called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:cellForRowAt:)))
                        _ = sut.tableView(tableView, cellForRowAt: indexPath)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Doesn't fail when expected methods are called", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:cellForRowAt:)))
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)))
                        _ = sut.tableView(tableView, cellForRowAt: indexPath)
                        _ = sut.tableView(tableView, numberOfRowsInSection: 42)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                    
                    it("Doesn't fail when expected methods are called with arguments that match", closure: {
                        //Arrange
                        sut.expect(callTo: #selector(sut.tableView(_:numberOfRowsInSection:)), withArgumentsThatMatch: ArgumentMatcher(matcher: { (args: (UITableView, Int)) -> Bool in
                            return args.0 === tableView && args.1 == 42
                        }))
                        _ = sut.tableView(tableView, numberOfRowsInSection: 42)
                        
                        //Act
                        verify(sut)
                        
                        //Assert
                        verify(mockFailureHandler)
                    })
                })
            })
        }
    }
}