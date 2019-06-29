import Foundation
import Core

class DataProvider: NSObject {

    private var items: [CalendarItem?] = []
    private var slots: [CalendarSlot] = []

    var count: Int {
        get {
            return slots.count
        }
    }

    func update(from source: CalendarSource) -> [Int] {
        var changedIndexes = [Int]()
        let oldItems = items
        let oldSlots = slots
        items.removeAll()
        slots.removeAll()
        let sourceCount = Int(source.count())
        for index in 0..<sourceCount {
            let newItem = source.item(at: index)
            let newSlot = source.slotAt(index)
            items.append(newItem)
            slots.append(newSlot)
            if index.isWithinBounds(of: oldSlots) && index.isWithinBounds(of: oldItems) {
                if !newSlot.view(matches: oldSlots[index]) || !matchViews(newItem, oldItems[index]) {
                    changedIndexes.append(index)
                }
            }
        }
        if oldSlots.count != Int(source.count()) {
            changedIndexes.removeAll()
        }
        return changedIndexes
    }

    func item(at indexPath: IndexPath) -> CalendarItem? {
        return items[indexPath.row]
    }

    func slot(at indexPath: IndexPath) -> CalendarSlot? {
        return slots[indexPath.row]
    }

}

extension Int {

    func isWithinBounds<T>(of array: [T]) -> Bool {
        return self < array.count
    }

}

extension CalendarSlot {

    func view(matches otherSlot: CalendarSlot) -> Bool {
        return count() == otherSlot.count()
    }

}

func matchViews(_ one: CalendarItem?, _ two: CalendarItem?) -> Bool {
    if let one = one, let two = two {
        return one.title == two.title &&
                one.startTime.millis == two.startTime.millis
    } else if one == nil && two == nil {
        return true
    } else {
        return false
    }
}
