import UIKit

class CalendarDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let dataProvider: DataProvider
    private weak var delegate: CalendarDataSourceDelegate?

    init(delegate: CalendarDataSourceDelegate, dataProvider: DataProvider) {
        self.delegate = delegate
        self.dataProvider = dataProvider
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as? CalendarSourceViewCell,
                let item = dataProvider.item(at: indexPath),
                let slot = dataProvider.slot(at: indexPath) else {
            preconditionFailure("Tried to dequeue a cell which wasn't a Calendar cell")
        }
        cell.bind(item, slot: slot)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count
    }

    func update(_ source: SCCalendarSource) {
        dataProvider.update(from: source)
    }

    func item(at index: IndexPath) -> SCCalendarItem? {
        return dataProvider.item(at: index)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataProvider.item(at: indexPath) else {
            preconditionFailure("Calendar didn't have item at expected index \((indexPath as NSIndexPath).row)")
        }
        if item.isEmpty() {
            delegate?.addEvent(for: item)
        } else {
            guard let item = item as? SCEventCalendarItem else {
                preconditionFailure("Item isn't empty, but isn't event")
            }
            delegate?.showDetails(for: item, at: indexPath)
        }
    }

}

protocol CalendarDataSourceDelegate: class {
    func addEvent(for item: SCCalendarItem)

    func showDetails(for item: SCEventCalendarItem, at indexPath: IndexPath)
}

class DataProvider: NSObject {

    private var items: [SCCalendarItem?] = []
    private var slots: [SCCalendarSlot] = []

    var count: Int {
        get {
            return slots.count
        }
    }

    func update(from source: SCCalendarSource) {
        items.removeAll()
        slots.removeAll()
        let sourceCount = Int(source.count())
        for i in 0 ..< sourceCount {
            items.append(source.itemAt(with: jint(i)))
            slots.append(source.slotAt(with: jint(i)))
        }
    }

    func item(at indexPath: IndexPath) -> SCCalendarItem? {
        return items[indexPath.row]
    }

    func slot(at indexPath: IndexPath) -> SCCalendarSlot? {
        return slots[indexPath.row]
    }

}
