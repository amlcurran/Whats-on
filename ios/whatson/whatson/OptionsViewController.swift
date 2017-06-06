import Foundation
import UIKit

class OptionsViewController: UIViewController, BoundaryPickerViewDelegate {

    private let analytics = Analytics()
    private let startPicker = UIDatePicker()
    private let boundaryPicker = BoundaryPickerView()
    private let timeStore = UserDefaultsTimeStore()
    private let minuteLimitationLabel = UILabel()
    private let picker: UIDatePicker = UIDatePicker()
    private var pickerHeightConstraint: NSLayoutConstraint!
    private var minuteLimitationHeightConstraint: NSLayoutConstraint?

    private var editState: BoundaryPickerView.EditState = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .windowBackground

        layoutViews()
        styleViews()
        boundaryPicker.delegate = self
        picker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        picker.datePickerMode = .time

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Navigation Item"), style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Navigation Item"), style: .plain, target: self, action: #selector(doneTapped))

        updateText()
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func styleViews() {
        minuteLimitationLabel.set(style: .lower)
        minuteLimitationLabel.text = NSLocalizedString("Options.MinuteLimitation", comment: "Showing that users can only pick hours")
        minuteLimitationLabel.alpha = 0
        minuteLimitationLabel.textAlignment = .center
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pickerHeightConstraint.isActive = false
            self?.view.layoutIfNeeded()
        })
    }

    private func layoutViews() {
        let holdingView = UIView()

        holdingView.add(boundaryPicker, constrainedTo: [.leading, .trailing])
        boundaryPicker.centerYAnchor.constraint(equalTo: holdingView.centerYAnchor).isActive = true

        view.add(holdingView, constrainedTo: [.top, .leading, .trailing])
        view.addSubview(minuteLimitationLabel)
        minuteLimitationLabel.constrain(.leading, to: view, .leading, withOffset: 16)
        minuteLimitationLabel.constrain(.trailing, to: view, .trailing, withOffset: -16)
        minuteLimitationLabel.constrain(.top, to: holdingView, .bottom)
        pickerHeightConstraint = picker.constrain(height: 0)
        pickerHeightConstraint.isActive = true
        view.add(picker, constrainedTo: [.leading, .trailing, .bottom])
        picker.constrain(.top, to: minuteLimitationLabel, .bottom)
    }

    func doneTapped() {
        analytics.changedTimes(starting: timeStore.startTime, finishing: timeStore.endTime)
        dismiss(animated: true, completion: nil)
    }

    func updateText() {
        if editState == .start {
            timeStore.startTime = picker.hour.or(17)
        }
        if editState == .end {
            timeStore.endTime = picker.hour.or(23)
        }
        boundaryPicker.updateText(from: timeStore)
    }

    func spinnerUpdated() {
        updateText()
        showMinuteLimitation()
    }

    func showMinuteLimitation() {
        if picker.hasMinutes {
            analytics.requestMinutes(repeatedTry: minuteLimitationLabel.alpha == 1)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.minuteLimitationLabel.alpha = 1
            })
            picker.removeMinutes()
        }
    }

    func boundaryPickerDidBeginEditing(in state: BoundaryPickerView.EditState) {
        showPicker()
        editState = state
        if editState == .start {
            picker.set(hour: timeStore.startTime, limitedBefore: timeStore.endTime)
        }
        if editState == .end {
            picker.set(hour: timeStore.endTime, limitedAfter: timeStore.startTime)
        }
    }

}
