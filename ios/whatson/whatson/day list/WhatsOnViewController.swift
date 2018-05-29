import UIKit
import EventKit
import EventKitUI

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        WhatsOnPresenterView,
        CalendarTableViewDelegate,
        HeaderViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let dataProvider = DataProvider()
    private let timeRepo = TimeRepository()
    private let pushTransition = EventDetailsPushTransition()
    private let navigationAnimations = EventTransitionNavigationDelegate()
    private let failedAccessView = FailedAccessView()
    private let loadingView = LoadingView(pathColor: .accent)
    private let gestureHandler = AllowsGestureRecognizer()
    private let addNewEventViewControllerFactory = AddNewEventViewControllerFactory()

    private var forceTouchDisplayer: Any?
    private var presenter: WhatsOnPresenter!
    private var eventService: SCEventsService!
    private var loadingDelay = DispatchTimeInterval.milliseconds(1500)

    lazy var table: CalendarTableView = {
        return CalendarTableView(delegate: self, dataProvider: self.dataProvider, tableView: UITableView())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = .windowBackground
        title = " "

        let displayer = EventForceTouchDisplayer(table: table, navigationController: navigationController)
        registerForPreviewing(with: displayer, sourceView: table.view)
        forceTouchDisplayer = displayer

        let eventRepo = EventStoreRepository(timeRepository: timeRepo, calendarPreferenceStore: CalendarPreferenceStore())
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator.instance)
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService, dataProvider: dataProvider)

        let header = HeaderView(delegate: self)
        anchor(header)

        table.style()

        navigationController?.delegate = navigationAnimations
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = gestureHandler

        loadingDelay = DispatchTimeInterval.milliseconds(1500)
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
        mainView.add(table.view, constrainedTo: [.leading, .top, .trailing, .bottom])
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

    func addEvent(for item: SCCalendarItem) {
        navigationController?.present(addNewEventViewControllerFactory.newEventController(for: item, delegate: self), animated: true, completion: nil)
    }

    func showDetails(for item: SCEventCalendarItem, at indexPath: IndexPath, in cell: UITableViewCell) {
        navigationAnimations.prepareTransition(from: indexPath, using: cell)
        navigationController?.show(EventDetailsViewController(eventItem: item), sender: nil)
    }

    func remove(_ event: SCEventCalendarItem) {
        presenter.remove(event)
    }

    // MARK: - edit view delegate

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - peek and pop

    func showCalendar(_ source: SCCalendarSource) {
        table.update(source)
        loadingView.animateAlpha(to: 0)
        loadingView.isHidden = true
        failedAccessView.isHidden = true
        failedAccessView.isUserInteractionEnabled = false
        table.show()
    }

    func showAccessFailure() {
        loadingView.isHidden = true
        failedAccessView.isHidden = false
        failedAccessView.isUserInteractionEnabled = true
        table.hide()
    }

    func failedToDelete(_ event: SCCalendarItem, withError error: Error) {

    }

    func showLoading() {
        loadingView.isHidden = false
        failedAccessView.isHidden = true
        table.hide()
    }

}

class EventTransitionNavigationDelegate: NSObject, UINavigationControllerDelegate {

    private let pushTransition = EventDetailsPushTransition()

    func prepareTransition(from indexPath: IndexPath, using cell: UITableViewCell) {
        pushTransition.selectedIndexPath = indexPath
        pushTransition.selectedCell = cell
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC is EventDetailsViewController && BuildConfig.Supports.eventTransitions {
            return pushTransition
        }
        return nil
    }

}
