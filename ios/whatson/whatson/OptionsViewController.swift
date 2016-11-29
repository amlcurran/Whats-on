import Foundation
import UIKit

class OptionsViewController: UIViewController {

    private let startPicker = UIDatePicker()
    private let beginningLabel = UILabel()
    private let intermediateLabel = UILabel()
    private let startSelectableView = TimeLabel()
    private let endSelectableView = TimeLabel()
    private let timeStore = UserDefaultsTimeStore()
    private let dateFormatter = DateFormatter()
    private let picker = UIDatePicker()
    private var pickerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .windowBackground

        layoutViews()
        styleViews()
        startSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = true
            self?.endSelectableView.selected = false
            self?.showPicker()
        }
        endSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = false
            self?.endSelectableView.selected = true
            self?.showPicker()
        }

        dateFormatter.dateFormat = "HH:mm"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))

        spinnerUpdated()
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func styleViews() {
        beginningLabel.set(style: .header)
        intermediateLabel.set(style: .header)
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pickerHeightConstraint.isActive = false
            self?.view.layoutIfNeeded()
        })
    }

    private func layoutViews() {
        let holdingView = UIView()

        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4

        stackView.addArrangedSubview(beginningLabel)
        stackView.addArrangedSubview(startSelectableView)
        stackView.addArrangedSubview(intermediateLabel)
        stackView.addArrangedSubview(endSelectableView)

        [beginningLabel, startSelectableView, intermediateLabel, endSelectableView].forEach({ $0.hugContent(.vertical) })
        holdingView.add(stackView, constrainedTo: [.leading, .trailing])
        stackView.centerYAnchor.constraint(equalTo: holdingView.centerYAnchor).isActive = true
        stackView.hugContent(.vertical)


        view.add(holdingView, constrainedTo: [.top, .leading, .trailing])
        pickerHeightConstraint = picker.constrain(height: 0)
        pickerHeightConstraint.isActive = true
        view.add(picker, constrainedTo: [.leading, .trailing, .bottom])
        picker.constrain(.top, to: holdingView, .bottom)
    }

    func doneTapped() {
//        let startComponents = Calendar.current.dateComponents([.hour], from: startPicker.date)
//        let endComponents = Calendar.current.dateComponents([.hour], from: 23)
//        timeStore.startTime = startComponents.hour
//        timeStore.endTime = endComponents.hour
        dismiss(animated: true, completion: nil)
    }

    func spinnerUpdated() {
        beginningLabel.text = "Show me events from"
        startSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.startTimestamp))
        intermediateLabel.text = "to"
        endSelectableView.text = dateFormatter.string(from: NSDateCalculator.instance.date(timeStore.endTimestamp))
    }

}

fileprivate struct UserDefaultsTimeStore {

    private let userDefaults: UserDefaults
    private let dateCalculator = NSDateCalculator.instance

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var startTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(startTime))
        }
    }

    var endTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(endTime))
        }
    }

    var startTime: Int {
        get {
            if let startTime = userDefaults.value(forKey: "startHour") as? Int {
                return startTime
            }
            return 17
        }
        set {
            userDefaults.set(newValue, forKey: "startHour")
        }
    }

    var endTime: Int {
        get {
            if let endTime = userDefaults.value(forKey: "endHour") as? Int {
                return endTime
            }
            return 23
        }
        set {
            userDefaults.set(newValue, forKey: "endHour")
        }
    }

}
