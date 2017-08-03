import XCTest
import UIKit
@testable import Whatson

class CalendarTableViewTests: XCTestCase, CalendarTableViewDelegate {

    func testIfTheDiffIsEmptyTheTableViewReloadsCompletely() {
        let stubTableView = StubTableView()
        let calendarTableView = CalendarTableView(delegate: self, dataProvider: StubDataProvider(updatedIndexes: []), tableView: stubTableView)
        let newData = SCCalendarSource()

        calendarTableView.update(newData)

        XCTAssertTrue(stubTableView.calledReloadData)
    }

    func testIfTheDiffIsNotEmptyTheTableViewReloadsIndividualRowsOfEvents() {
        let stubTableView = StubTableView()
        let calendarTableView = CalendarTableView(delegate: self, dataProvider: StubDataProvider(updatedIndexes: [0, 3]), tableView: stubTableView)
        let newData = SCCalendarSource()

        calendarTableView.update(newData)

        XCTAssertEqual(stubTableView.reloadedRowIndexes, [IndexPath(row: 1, section: 0), IndexPath(row: 7, section: 0)])
    }

    func addEvent(for item: SCCalendarItem) {
        // no-op
    }

    func showDetails(for item: SCEventCalendarItem, at indexPath: IndexPath, in cell: UITableViewCell) {
        // no-op
    }

    func remove(_ event: SCEventCalendarItem) {
        // no-op
    }

}

class StubDataProvider: DataProvider {

    let updatedIndexes: [Int]

    init(updatedIndexes: [Int]) {
        self.updatedIndexes = updatedIndexes
    }

    override func update(from source: SCCalendarSource) -> [Int] {
        return updatedIndexes
    }

}

class StubTableView: UITableView {

    var calledReloadData = false
    var reloadedRowIndexes: [IndexPath] = []

    override func reloadData() {
        calledReloadData = true
    }

    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        reloadedRowIndexes = indexPaths
    }
}
