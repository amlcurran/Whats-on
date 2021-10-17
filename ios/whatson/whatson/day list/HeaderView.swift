import UIKit
import SwiftUI

class HeaderView: UIView {

    let todayLabel = UILabel()
    let appLabel = UILabel()
    let dateFormatter = DateFormatter()
    let editButton = UIButton()

    private weak var delegate: HeaderViewDelegate?

    init(delegate: HeaderViewDelegate) {
        super.init(frame: .zero)
        layout()
        styleTodayLabel()
        styleAppLabel()
        styleEditButton()
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        let view = UIView()
        view.add(todayLabel, constrainedTo: [.top, .trailing, .leading])
        view.add(appLabel, constrainedTo: [.bottom, .trailing, .leading])
        appLabel.constrain(.top, to: todayLabel, .bottom, withOffset: 4)
        add(view, constrainedTo: [.top, .leading, .bottom])
        add(editButton, constrainedTo: [.top, .trailing, .bottom])
        view.constrain(.trailing, to: editButton, .leading)
        editButton.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }

    func styleTodayLabel() {
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        todayLabel.text = (dateFormatter.string(from: Date()) as NSString).uppercased
        todayLabel.textColor = .accent
        todayLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    func styleAppLabel() {
        appLabel.text = "What’s on"
        appLabel.textColor = .secondary
        appLabel.font = .systemFont(ofSize: 32, weight: .heavy)
    }

    func styleEditButton() {
        editButton.setImage(UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(pointSize: 20, weight: .light)), for: .normal)
        editButton.tintColor = .accent
//        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.accent, for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }

    @objc func editTapped() {
        delegate?.didTapEdit()
    }

    override var intrinsicContentSize: CGSize {
        let height = todayLabel.font.pointSize + 3 + appLabel.font.pointSize
        return CGSize(width: 0, height: height)
    }

}

protocol HeaderViewDelegate: AnyObject {
    func didTapEdit()
}
