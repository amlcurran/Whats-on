import Foundation
import UIKit

class OptionsViewController: UIViewController {
    
    let startPicker = UIDatePicker()
    let label = UILabel()
    private let timeStore = UserDefaultsTimeStore()
    
    let dateFormatter = DateFormatter()
    
    static func create() -> OptionsViewController {
        return OptionsViewController(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground

        layoutViews()

        dateFormatter.dateFormat = "HH:mm"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        spinnerUpdated()
    }
    
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func layoutViews() {
        view.addSubview(label)
        label.constrainToSuperview(edges: [.leading, .top, .trailing, .bottom])
    }

    func doneTapped() {
//        let startComponents = Calendar.current.dateComponents([.hour], from: startPicker.date)
//        let endComponents = Calendar.current.dateComponents([.hour], from: 23)
//        timeStore.startTime = startComponents.hour
//        timeStore.endTime = endComponents.hour
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func spinnerUpdated() {
        label.text = "From \(timeStore.startTime) to \(timeStore.endTime)"
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
