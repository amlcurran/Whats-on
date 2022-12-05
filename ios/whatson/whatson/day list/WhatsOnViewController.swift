import UIKit
import EventKit
import EventKitUI
import WidgetKit
import Core
import Intents
import SwiftUI

struct WhatsOnView: View {
    
    let presenter = WhatsOnPresenter(eventStore: .instance, eventService: .default)
    @State var shareUrl: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView2 {
                self.snapshotAndShare()
            }
            PresenterEventList(presenter: presenter)
        }
        .sheet(item: $shareUrl, onDismiss: presenter.unredact) { temporary in
            UIActivityView(url: temporary)
        }
        .tint(Color("accent"))
    }
    
    private func snapshotAndShare() {
        UIView.performWithoutAnimation {
            presenter.redact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let snapshot = self.snapshot(withWidth: 375)
            if let png = snapshot.pngData(),
               let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                do {
                    let temporary = url.appendingPathComponent("temporary.png")
                    try png.write(to: temporary)
                    self.shareUrl = temporary
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

extension URL: Identifiable {
    
    public var id: String {
        absoluteString
    }
    
}

class WhatsOnViewController: UIViewController {
    
    private lazy var hostingView = UIHostingController(
        rootView: WhatsOnView()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground
        title = " "
        
        view.add(hostingView.view, constrainedTo: [.bottom, .leading, .trailing])
        hostingView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        hostingView.didMove(toParent: self)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
