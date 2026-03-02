//
//  TodoAppEndToEndTests.swift
//  TodoAppEndToEndTests
//
//  Created by RaviShankar Kushwaha on 02/03/26.
//

import XCTest

final class TodoAppEndToEndTests: XCTestCase {

    func test_should_not_display_any_tasks() {
        
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let taskList = app.tables["taskList"]
        XCTAssertEqual(0, taskList.cells.count)
    }
    
    override class func tearDown() {
        Springboard.deleteApp()
    }
}

class when_user_saves_a_new_task: XCTestCase {
    
    func test_should_be_able_to_display_task_successfully() {
        
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let titleTextField = app.textFields["titleTextField"]
        titleTextField.tap()
        titleTextField.typeText("Mow the lawn")
        
        let saveTaskButton = app.buttons["saveTaskButton"]
        saveTaskButton.tap()
        
        let taskList = app.tables["taskList"]
        XCTAssertEqual(1, taskList.cells.count)
    }
    
    override class func tearDown() {
        Springboard.deleteApp()
    }
}
