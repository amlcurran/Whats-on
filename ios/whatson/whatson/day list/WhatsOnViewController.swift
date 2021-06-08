import UIKit
import EventKit
import EventKitUI
import Core

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        WhatsOnPresenterView,
        CalendarTableViewDelegate,
        HeaderViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let timeRepo = NSDateTimeRepository()
    private let pushTransition = EventDetailsPushTransition()
    private let navigationAnimations = EventTransitionNavigationDelegate()
    private let failedAccessView = FailedAccessView()
    private let loadingView = LoadingView(pathColor: .accent)
    private let gestureHandler = AllowsGestureRecognizer()
    private let addNewEventViewControllerFactory = AddNewEventViewControllerFactory()

    private var forceTouchDisplayer: Any?
    private var presenter: WhatsOnPresenter!
    private var eventService: EventsService!
    private var loadingDelay = DispatchTimeInterval.milliseconds(1000)

    lazy var table: CalendarTable = {
//        if #available(iOS 13.0, *) {
//            return CalendarDiffableTableView(tableView: UITableView(), delegate: self)
//        } else {
            return CalendarTableView(delegate: self, tableView: UITableView())
//        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .windowBackground
        title = " "

        let eventRepo = EventKitEventRepository(timeRepository: timeRepo, calendarPreferenceStore: CalendarPreferenceStore())
        eventService = EventsService(timeRepository: timeRepo, eventsRepository: eventRepo, timeCalculator: NSDateCalculator.instance)
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)

        let header = HeaderView(delegate: self)
        anchor(header)

        table.style()

        navigationController?.delegate = navigationAnimations
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = gestureHandler

        loadingDelay = DispatchTimeInterval.milliseconds(600)
        showLoading()
    }

    private func anchor(_ header: UIView) {
        let blurView = GradientView()
        blurView.colors = [.windowBackground, .windowBackground, UIColor.windowBackground.withAlphaComponent(0)]
        blurView.locations = [0.0, 0.85, 1.0]
        blurView.addSubview(header)
        header.constrain(toSuperview: .top, .trailing, .bottom, insetBy: 16)
        header.hugContent(.vertical)

        let mainView = UIView()
        view.add(mainView, constrainedTo: [.bottom, .leading, .trailing])
        view.add(blurView, constrainedTo: [.top, .leading, .trailing])
        header.constrain(toSafeAreaTopOf: self, insetBy: 16)
        mainView.constrain(.top, to: header, .bottom, withOffset: -16)
        mainView.add(table.view, constrainedTo: [.top, .bottom])
        table.view.leadingAnchor.constraint(equalTo: mainView.readableContentGuide.leadingAnchor).isActive = true
        table.view.trailingAnchor.constraint(equalTo: mainView.readableContentGuide.trailingAnchor).isActive = true
        mainView.add(failedAccessView, constrainedTo: [.leading, .top, .trailing, .bottom])

        header.constrain(toSuperviewSafeArea: .leading, .trailing, insetBy: 16)

        view.addSubview(loadingView)
        loadingView.constrain(.centerX, to: view, .centerX)
        loadingView.constrain(.centerY, to: view, .centerY)
        loadingView.constrain(height: 96)
        loadingView.constrain(width: 96)
    }

    func didTapEdit() {
        let settings = OptionsViewController()
        present(settings.inNavigationController(), animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginPresenting(on: self, delayingBy: loadingDelay)
        loadingDelay = DispatchTimeInterval.milliseconds(0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.stopPresenting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addEvent(for item: CalendarSlot) {
        navigationController?.present(addNewEventViewControllerFactory.newEventController(for: item, delegate: self), animated: true, completion: nil)
    }

    func showDetails(for item: EventCalendarItem, at indexPath: IndexPath, in cell: UIView & Row) {
        navigationAnimations.prepareTransition(from: indexPath, using: cell)
        navigationController?.show(EventDetailsViewController(eventItem: item, showingNavBar: true), sender: nil)
    }

    func remove(_ event: EventCalendarItem) {
        presenter.remove(event)
    }

    // MARK: - edit view delegate

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - peek and pop

    func showCalendar(_ source: CalendarSource) {
        table.view.alpha = 0
        table.view.animateAlpha(to: 1) { _ in }
        table.update(source)
        loadingView.animateAlpha(to: 0) { $0.isHidden = true }
        failedAccessView.isHidden = true
        failedAccessView.isUserInteractionEnabled = false
    }

    func showAccessFailure() {
        loadingView.isHidden = true
        failedAccessView.isHidden = false
        failedAccessView.isUserInteractionEnabled = true
    }

    func failedToDelete(_ event: CalendarItem, withError error: Error) {

    }

    func showLoading() {
        loadingView.isHidden = false
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
