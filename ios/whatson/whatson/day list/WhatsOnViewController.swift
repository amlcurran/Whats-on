import UIKit
import EventKit
import EventKitUI
import WidgetKit
import Core
import Intents

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        WhatsOnPresenterView,
        CalendarTableViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let pushTransition = EventDetailsPushTransition()
    private let navigationAnimations = EventTransitionNavigationDelegate()
    private let gestureHandler = AllowsGestureRecognizer()
    private let addNewEventViewControllerFactory = AddNewEventViewControllerFactory()

    private var forceTouchDisplayer: Any?
    private var presenter: WhatsOnPresenter!
    private var eventService: EventsService!

    private lazy var table = CalendarDiffableTableView(delegate: self)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground
        title = " "

        eventService = .default
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)
        let header = HeaderView2 { [weak self] in
            self?.didTapEdit()
        } onShareModeTapped: { [weak self] in
            self?.snapshotAndShare()
        }
        let hostingView = UIHostingController(rootView: header)
        anchor(hostingView.view)
        hostingView.didMove(toParent: self)

//        table.style()

        navigationController?.delegate = navigationAnimations
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = gestureHandler
    }
    
    private func snapshotAndShare() {
        UIView.performWithoutAnimation {
            table.sharingMode = true
        }
        defer {
            UIView.performWithoutAnimation {
                table.sharingMode = false
            }
        }
        if let snapshot = view.getImageFromCurrentContext(bounds: nil) {
            if let png = snapshot.pngData(),
               let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                do {
                    let temporary = url.appendingPathComponent("temporary.png")
                    try png.write(to: temporary)
                    let viewController = UIActivityViewController(activityItems: [temporary], applicationActivities: nil)
                    present(viewController, animated: true, completion: nil)
                } catch {
                    print(error)
                }
            }
        }
    }

    private func anchor(_ header: UIView) {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(table.view)
        
        view.add(stackView, constrainedTo: [.bottom, .leading, .trailing])
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

    func didTapEdit() {
        let settings = OptionsViewController {
            self.presenter.refreshEvents()
        }
        present(settings, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginPresenting(on: self, delayingBy: .seconds(0))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.stopPresenting()
    }

    func addEvent(for item: CalendarSlot) {
        navigationController?.present(addNewEventViewControllerFactory.newEventController(for: item, delegate: self), animated: true, completion: nil)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func showDetails(for item: EventCalendarItem, at indexPath: IndexPath, in cell: UIView & Row) {
        navigationAnimations.prepareTransition(from: indexPath, using: cell)
        navigationController?.show(EventDetailsViewController(eventItem: item, showingNavBar: true), sender: nil)
    }

    func remove(_ event: EventCalendarItem) {
        presenter.remove(event)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func showCalendar(_ source: [CalendarSlot]) {
        table.view.animateAlpha(to: 1) { _ in }
        table.update(source)
    }

    func showAccessFailure() {
    }

    func failedToDelete(_ event: CalendarItem, withError error: Error) {

    }

    func showLoading() {
        
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
