import Foundation
import UIKit

class OptionsViewController: UIViewController {
    
    let startPicker = UIDatePicker()
    let beginningLabel = UILabel()
    let intermediateLabel = UILabel()
    let startSelectableView = TimeLabel()
    let endSelectableView = TimeLabel()
    private let timeStore = UserDefaultsTimeStore()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .windowBackground

        layoutViews()
        styleViews()
        startSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = true
            self?.endSelectableView.selected = false
        }
        endSelectableView.tapClosure = { [weak self] in
            self?.startSelectableView.selected = false
            self?.endSelectableView.selected = true
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

    private func layoutViews() {
        let holdingView = UIStackView()
        holdingView.alignment = .center
        holdingView.axis = .vertical
        holdingView.distribution = .equalSpacing
        holdingView.spacing = 4

        holdingView.addArrangedSubview(beginningLabel)
        holdingView.addArrangedSubview(startSelectableView)
        holdingView.addArrangedSubview(intermediateLabel)
        holdingView.addArrangedSubview(endSelectableView)

        [beginningLabel, startSelectableView, intermediateLabel, endSelectableView].forEach({ $0.hugContent(.vertical) })
        view.addSubview(holdingView)
        holdingView.constrainToSuperview(edges: [.leading, .trailing])
        holdingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        holdingView.hugContent(.vertical)
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
        startSelectableView.text = "\(timeStore.startTime)"
        intermediateLabel.text = "to"
        endSelectableView.text = "\(timeStore.endTime)"
    }
    
}

fileprivate struct UserDefaultsTimeStore {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
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
