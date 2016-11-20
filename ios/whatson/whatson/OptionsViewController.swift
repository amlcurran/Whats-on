import Foundation
import UIKit

class OptionsViewController: UIViewController {
    
    let startPicker = UIDatePicker()
    let beginningLabel = UILabel()
    let intermediateLabel = UILabel()
    var startSelectableView = TimeLabel()
    var endSelectableView = TimeLabel()
    private let timeStore = UserDefaultsTimeStore()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .windowBackground

        layoutViews()
        styleViews()

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
        let holdingView = UIView()

        holdingView.addSubview(beginningLabel)
        beginningLabel.constrainToSuperview(edges: [.top, .leading, .trailing])

        createSelectableView(startSelectableView, selector: #selector(startSelected))
//        _ = startLabel.surrounded(by: startSelectableView, inset: 4)
        holdingView.addSubview(startSelectableView)
        startSelectableView.constrainToSuperview(edges: [.leading, .trailing])
        startSelectableView.constrain(.top, to: beginningLabel, .bottom)

        holdingView.addSubview(intermediateLabel)
        intermediateLabel.constrainToSuperview(edges: [.leading, .trailing])
        intermediateLabel.constrain(.top, to: startSelectableView, .bottom)

        createSelectableView(endSelectableView, selector: #selector(endSelected))
        holdingView.addSubview(endSelectableView)
        endSelectableView.constrainToSuperview(edges: [.leading, .trailing, .bottom])
        endSelectableView.constrain(.top, to: intermediateLabel, .bottom)

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

    private func createSelectableView(_ view: TimeLabel, selector: Selector) {
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(gestureRecogniser)
    }

    @objc func startSelected(recogniser: UITapGestureRecognizer) {
        startSelectableView.selected = true
        endSelectableView.selected = false
    }

    @objc func endSelected(recogniser: UITapGestureRecognizer) {
        startSelectableView.selected = false
        endSelectableView.selected = true
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
