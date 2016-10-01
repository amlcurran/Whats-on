import Foundation
import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    
    let dateFormatter = DateFormatter()
    
    static func create() -> OptionsViewController {
        let nib = UINib(nibName: "OptionsViewController", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first! as! OptionsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "HH:mm"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        startPicker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        endPicker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        spinnerUpdated()
    }
    
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func doneTapped() {
        let startComponents = Calendar.current.dateComponents([.hour], from: startPicker.date)
        let endComponents = Calendar.current.dateComponents([.hour], from: endPicker.date)
        UserDefaults.standard.set(startComponents.hour, forKey: "startHour")
        UserDefaults.standard.set(endComponents.hour, forKey: "endHour")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func spinnerUpdated() {
        label.text = "From \(dateFormatter.string(from: startPicker.date)) to \(dateFormatter.string(from: endPicker.date))"
        endPicker.minimumDate = startPicker.date
    }
    
}
