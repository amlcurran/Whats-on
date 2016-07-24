import Foundation
import UIKit

class OptionsViewController: UIViewController {
    
    static func create() -> OptionsViewController {
        let nib = UINib(nibName: "OptionsViewController", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first! as! OptionsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
    }
    
    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func doneTapped() {
        print("Will do something here!")
        dismiss(animated: true, completion: nil)
    }
    
}
