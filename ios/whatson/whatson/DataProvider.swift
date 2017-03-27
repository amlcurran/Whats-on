import Foundation

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