import UIKit

class BuildableTableSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    let sections: [TableSection]

    init(sections: [TableSection], tableView: UITableView) {
        self.sections = sections
        TitleTableItem.register(in: tableView)
        SwitchTableItem.register(in: tableView)
        CustomViewTableItem.register(in: tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].item(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        item.bind(to: cell)
        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if item(at: indexPath).isSelectable {
            return indexPath
        } else {
            return nil
        }
    }

    private func item(at indexPath: IndexPath) -> TableItem {
        return sections[indexPath.section].item(at: indexPath.row)
    }

}
