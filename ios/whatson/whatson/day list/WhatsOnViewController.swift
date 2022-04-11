import UIKit
import EventKit
import EventKitUI
import WidgetKit
import Core
import Intents
import SwiftUI

struct PresenterEventList: View {
    
    @ObservedObject var presenter: WhatsOnPresenter
    
    var body: some View {
        EventList(events: $presenter.events,
                  redaction: $presenter.redaction) { event in
            presenter.remove(event)
        }
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
    
    private lazy var hostingView = UIHostingController(
        rootView: VStack(spacing: 0) {
            HeaderView2 { [weak self] in
                self?.snapshotAndShare()
            }
            PresenterEventList(presenter: presenter)
        }
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
    
    private func snapshotAndShare() {
        UIView.performWithoutAnimation {
            presenter.redact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let snapshot = self.hostingView.rootView.snapshot(withWidth: 375)
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

extension View {
    func snapshot(withWidth width: Int? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        var targetSize = controller.view.intrinsicContentSize
        if let width = width {
            targetSize.width = CGFloat(width)
        }
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
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
