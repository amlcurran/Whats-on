import Foundation

class DataProvider: NSObject {

    private var items: [SCCalendarItem?] = []
    private var slots: [SCCalendarSlot] = []

    var count: Int {
        get {
            return slots.count
        }
    }

    func update(from source: SCCalendarSource) -> [IndexPath] {
        var changedIndexes = [IndexPath]()
        let oldItems = items
        let oldSlots = slots
        items.removeAll()
        slots.removeAll()
        let sourceCount = Int(source.count())
        for i in 0 ..< sourceCount {
            let newItem = source.itemAt(with: jint(i))
            let newSlot = source.slotAt(with: jint(i))
            items.append(newItem)
            slots.append(newSlot)
            if i.isWithinBounds(of: oldSlots) && i.isWithinBounds(of: oldItems) {
                if !newSlot.view(matches: oldSlots[i]) || !matchViews(newItem, oldItems[i]) {
                    changedIndexes.append(IndexPath(row: i, section: 0))
                }
            }
        }
        if oldSlots.count != Int(source.count()) {
            changedIndexes.removeAll()
        }
        return changedIndexes
    }

    func item(at indexPath: IndexPath) -> SCCalendarItem? {
        return items[indexPath.row]
    }

    func slot(at indexPath: IndexPath) -> SCCalendarSlot? {
        return slots[indexPath.row]
    }

}

extension Int {

    func isWithinBounds<T>(of array: Array<T>) -> Bool {
        return self < array.count
    }

}

extension SCCalendarSlot {

    func view(matches otherSlot: SCCalendarSlot) -> Bool {
        return count() == otherSlot.count()
    }

}

func matchViews(_ one: SCCalendarItem?, _ two: SCCalendarItem?) -> Bool {
    if let one = one, let two = two {
        return one.title() == two.title() &&
                one.startTime().getMillis() == two.startTime().getMillis()
    } else if one == nil && two == nil {
        return true
    } else {
        return false
    }
}