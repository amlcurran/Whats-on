import UIKit
import EventKit
import EventKitUI

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        UIViewControllerPreviewingDelegate,
        WhatsOnPresenterView,
        CalendarTableViewDelegate,
        HeaderViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let dataProvider = DataProvider()
    private let timeRepo = TimeRepository()
    private let pushTransition = EventDetailsPushTransition()
    //swiftlint:disable:next weak_delegate this is a delegate for something else 
    private let navigationDelegate = EventTransitionNavigationDelegate()
    private let failedAccessView = FailedAccessView()
    private let gestureHandler = AllowsGestureRecognizer()

    private var presenter: WhatsOnPresenter!
    private var eventService: SCEventsService!

    lazy var table: CalendarTableView = {
        return CalendarTableView(delegate: self, dataProvider: self.dataProvider, tableView: UITableView())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = .windowBackground
        title = " "

        table.enablePreviewing(with: self, in: self)

        let eventRepo = EventStoreRepository(timeRepository: timeRepo)
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator.instance)
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService, dataProvider: dataProvider)

        let header = HeaderView(delegate: self)
        anchor(header)

        styleTable(offsetAgainst: header)

        navigationController?.delegate = navigationDelegate
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = gestureHandler
    }

    private func anchor(_ header: UIView) {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.addSubview(header)
        header.constrainToSuperview([.leading, .trailing, .bottom], insetBy: 16)

        let mainView = UIView()
        view.add(mainView, constrainedTo: [.bottom, .leading, .trailing])
        view.add(blurView, constrainedTo: [.leading, .trailing, .top])
        header.constrainToTopLayoutGuide(of: self, insetBy: 16)
        mainView.constrainToTopLayoutGuide(of: self)

        mainView.add(table.view, constrainedTo: [.leading, .top, .trailing, .bottom])
        mainView.add(failedAccessView, constrainedTo: [.leading, .top, .trailing, .bottom])
    }

    private func styleTable(offsetAgainst header: HeaderView) {
        table.style(offsetAgainst: header)
    }

    func didTapEdit() {
        present(OptionsViewController().inNavigationController(), animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginPresenting(on: self)
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
        navigationController?.present(EKEventEditViewController(calendarItem: item, delegate: self), animated: true, completion: nil)
    }

    func showDetails(for item: SCEventCalendarItem, at indexPath: IndexPath, in cell: UITableViewCell) {
        navigationDelegate.prepareTransition(from: indexPath, using: cell)
        navigationController?.pushViewController(EventDetailsViewController(eventItem: item), animated: true)
    }

    func remove(_ event: SCEventCalendarItem) {
        presenter.remove(event)
    }

    // MARK: - edit view delegate

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - peek and pop

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = table.indexPath(under: location),
            let cell = table.cell(at: indexPath),
              let item = table.item(at: indexPath) else {
            return nil
        }

        previewingContext.sourceRect = cell.frame

        if item.isEmpty() {
            return nil
        } else {
            return EventDetailsViewController(item: item)
        }
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

    func showCalendar(_ source: SCCalendarSource) {
        table.update(source)
        failedAccessView.alpha = 0
        failedAccessView.isUserInteractionEnabled = false
        table.show()
    }

    func showAccessFailure() {
        failedAccessView.alpha = 1
        failedAccessView.isUserInteractionEnabled = true
        table.hide()
    }

    func failedToDelete(_ event: SCCalendarItem, withError error: Error) {

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

fileprivate extension EKEventEditViewController {

    convenience init(calendarItem: SCCalendarItem,
                     delegate: EKEventEditViewDelegate,
                     eventStore: EKEventStore = EKEventStore.instance) {
        self.init()
        self.eventStore = eventStore
        self.event = EKEvent(representing: calendarItem)
        self.editViewDelegate = delegate
    }

}

fileprivate extension EKEvent {

    convenience init(representing calendarItem: SCCalendarItem,
                     calculator: NSDateCalculator = NSDateCalculator.instance,
                     eventStore: EKEventStore = EKEventStore.instance) {
        self.init(eventStore: eventStore)
        self.startDate = calculator.date(calendarItem.startTime())
        self.endDate = calculator.date(calendarItem.endTime())
    }

}
