import UIKit
import EventKit
import EventKitUI
import WidgetKit
import Core
import Intents

struct PresenterEventList: View {
    
    @ObservedObject var presenter: WhatsOnPresenter
    
    var body: some View {
        EventList(events: $presenter.events,
                  redaction: $presenter.redaction)
            .onAppear {
                presenter.beginPresenting()
            }
            .onDisappear {
                presenter.stopPresenting()
            }
    }
    
}

class WhatsOnViewController: UIViewController {

    private lazy var presenter = WhatsOnPresenter(eventStore: .instance, eventService: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground
        title = " "

        let hostingView = UIHostingController(
            rootView: VStack(spacing: 0) {
                HeaderView2 { [weak self] in
                    self?.snapshotAndShare()
                }
                PresenterEventList(presenter: presenter)
            }
        )
        
        view.add(hostingView.view, constrainedTo: [.bottom, .leading, .trailing])
        hostingView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        hostingView.didMove(toParent: self)

//        table.style()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func snapshotAndShare() {
        UIView.performWithoutAnimation {
            presenter.redact()
        }
//        defer {
//            UIView.performWithoutAnimation {
//                presenter.unredact()
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            if let snapshot = self.view.getImageFromCurrentContext(bounds: nil) {
                if let png = snapshot.pngData(),
                   let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                    do {
                        let temporary = url.appendingPathComponent("temporary.png")
                        try png.write(to: temporary)
                        let viewController = UIActivityViewController(activityItems: [temporary], applicationActivities: nil)
                        self.present(viewController, animated: true) {
                            self.presenter.unredact()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

}

class EventTransitionNavigationDelegate: NSObject, UINavigationControllerDelegate {

    private let pushTransition = EventDetailsPushTransition()

    func prepareTransition(from indexPath: IndexPath, using cell: UIView & Row) {
        pushTransition.selectedIndexPath = indexPath
        pushTransition.selectedCell = cell
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC is EventDetailsViewController && BuildConfig.Supports.eventTransitions {
            return pushTransition
        }
        return nil
    }

}

import SwiftUI

struct WhatsOnViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        SimplePreviews {
            WhatsOnViewController()
        }
    }
    
}

struct SimplePreviews<T: UIViewController>: View {
    
    let builder: () -> T
    
    var body: some View {
        Group {
            ViewControllerPreview(builder: builder)
            ViewControllerPreview(builder: builder)
                .preferredColorScheme(.dark)
        }
    }
    
}

struct ViewControllerPreview<T: UIViewController>: UIViewControllerRepresentable {
    typealias UIViewControllerType = T
    
    let builder: () -> T
    
    func makeUIViewController(context: Context) -> T {
        builder()
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
        
    }
    
}

import CoreGraphics

extension UIView {
    func getImageFromCurrentContext(bounds: CGRect? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds?.size ?? self.bounds.size, false, 0.0)
        self.drawHierarchy(in: bounds ?? self.bounds, afterScreenUpdates: true)

        guard let currentImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()

        return currentImage
    }
}
