import Foundation

class DataProvider: NSObject {

    private var slots: [SCCalendarSlot] = []

    var count: Int {
        get {
            return slots.count
        }
    }

    func update(from source: SCCalendarSource) {
        slots.removeAll()
        let sourceCount = Int(source.count())
        for i in 0 ..< sourceCount {
            slots.append(source.slotAt(with: jint(i)))
        }
    }

    func item(at indexPath: IndexPath) -> SCCalendarItem? {
        return slot(at: indexPath).firstItem()
    }

    func slot(at indexPath: IndexPath) -> SCCalendarSlot {
        return slots[indexPath.row]
    }

}