import UIKit
import EventKit
import EventKitUI
import WidgetKit
import Core
import Intents

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        WhatsOnPresenterView,
        CalendarTableViewDelegate,
        HeaderViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let pushTransition = EventDetailsPushTransition()
    private let navigationAnimations = EventTransitionNavigationDelegate()
    private let failedAccessView = FailedAccessView()
    private let gestureHandler = AllowsGestureRecognizer()
    private let addNewEventViewControllerFactory = AddNewEventViewControllerFactory()

    private var forceTouchDisplayer: Any?
    private var presenter: WhatsOnPresenter!
    private var eventService: EventsService!

    private lazy var table = CalendarDiffableTableView(tableView: UITableView(), delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground
        title = " "

        eventService = .default
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)

        let header = HeaderView(delegate: self)
        anchor(header)

        table.style()

        navigationController?.delegate = navigationAnimations
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = gestureHandler
    }

    private func anchor(_ header: UIView) {
        let blurView = GradientView()
        blurView.backgroundColor = .windowBackground
        blurView.addSubview(header)
        header.constrain(toSuperview: .top, .trailing, .bottom, insetBy: 16)
        header.hugContent(.vertical)

        failedAccessView.isHidden = true

        let mainView = UIView()
        view.add(mainView, constrainedTo: [.bottom, .leading, .trailing])
        view.add(blurView, constrainedTo: [.top, .leading, .trailing])
        header.constrain(toSafeAreaTopOf: self, insetBy: 16)
        mainView.constrain(.top, to: header, .bottom)
        mainView.add(table.view, constrainedTo: [.top, .bottom])
        table.view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        table.view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        mainView.add(failedAccessView, constrainedTo: [.leading, .top, .trailing, .bottom])

        header.constrain(toSuperviewSafeArea: .leading, .trailing, insetBy: 16)
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
        failedAccessView.isHidden = true
        failedAccessView.isUserInteractionEnabled = false

//        let intent = CheckCalendarIntent()
//        intent.day = PickDay.today
//        let interaction = INInteraction(intent: intent, response: nil)
//        interaction.donate { error in
//            if let error = error {
//                print(error)
//            }
//        }
//
//        let tomorrowIntent = CheckCalendarIntent()
//        tomorrowIntent.day = PickDay.tomorrow
//        INInteraction(intent: tomorrowIntent, response: nil).donate { error in
//            if let error = error {
//                print(error)
//            }
//        }
    }

    func showAccessFailure() {
        failedAccessView.isHidden = false
        failedAccessView.isUserInteractionEnabled = true
    }

    func failedToDelete(_ event: CalendarItem, withError error: Error) {

    }

    func showLoading() {
        failedAccessView.isHidden = true
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
