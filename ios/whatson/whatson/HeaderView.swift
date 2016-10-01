import UIKit

class HeaderView: UIView {
    
    let todayLabel = UILabel()
    let appLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        styleTodayLabel()
        styleAppLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        add(todayLabel, constrainedTo: [.top, .trailing, .leading])
        add(appLabel, constrainedTo: [.bottom, .trailing, .leading])
        appLabel.constrain(.top, to: todayLabel, .bottom, withOffset: 3)
    }

    func styleTodayLabel() {
        todayLabel.text = "Hello world"
        todayLabel.textColor = .accent
        todayLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
    }
    
    func styleAppLabel() {
        appLabel.text = "What's on"
        appLabel.textColor = .secondary
        appLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFontWeightHeavy)
    }
    
    override var intrinsicContentSize: CGSize {
        let height = todayLabel.font.pointSize + 3 + appLabel.font.pointSize
        return CGSize(width: 0, height: height)
    }
    
}
