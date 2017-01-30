import UIKit
import EventKit
import EventKitUI

class WhatsOnViewController: UIViewController,
        EKEventEditViewDelegate,
        UIViewControllerPreviewingDelegate,
        WhatsOnPresenterDelegate,
        CalendarDataSourceDelegate,
        UINavigationControllerDelegate,
        HeaderViewDelegate {

    private let dateFormatter = DateFormatter(dateFormat: "EEE")
    private let eventStore = EKEventStore.instance
    private let tableView = UITableView()
    private let timeRepo = TimeRepository()
    private let pushDelegate = EventDetailsPushTransition()

    private var presenter: WhatsOnPresenter!
    private var eventService: SCEventsService!
    private var failedAccessView: UIView?

    lazy var dataSource: CalendarDataSource = {
        return CalendarDataSource(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = .windowBackground
        title = " "

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }

        let eventRepo = EventStoreRepository(timeRepository: timeRepo)
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator.instance)
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)

        let header = HeaderView(delegate: self)
        anchor(header)

        styleTable(offsetAgainst: header)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func anchor(_ header: UIView) {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.addSubview(header)
        header.constrainToSuperview(edges: [.leading], withOffset: 16)
        header.constrainToSuperview(edges: [.trailing, .bottom], withOffset: -16)

        let mainView = UIView()
        view.add(mainView, constrainedTo: [.bottom, .leading, .trailing])
        view.add(blurView, constrainedTo: [.leading, .trailing, .top])
        header.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16).isActive = true
        mainView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        failedAccessView = failedToAccessView()
        mainView.add(tableView, constrainedTo: [.leading, .top, .trailing, .bottom])
        mainView.add(failedAccessView!, constrainedTo: [.leading, .top, .trailing, .bottom])
    }
    
    private func failedToAccessView() -> UIView {
        let view = UIView()
        let label = UILabel()
        label.set(style: .lower)
        label.numberOfLines = 0
        view.addSubview(label)
        label.constrainToSuperview(edges: [.leading, .top], withOffset: 32)
        label.constrainToSuperview(edges: [.trailing, .bottom], withOffset: -32)
        label.textAlignment = .center
        label.hugContent(.vertical)
        label.text = "CalendarAccessError".localized()
        return view
    }

    private func styleTable(offsetAgainst header: HeaderView) {
        let newCellNib = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        tableView.register(newCellNib, forCellReuseIdentifier: "day")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: header.intrinsicContentSize.height + 38, left: 0, bottom: 16, right: 0)
    }

    func eventsChanged() {
        presenter.refreshEvents()
    }

    func didTapEdit() {
        present(OptionsViewController().inNavigationController(), animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsChanged), name: NSNotification.Name.EKEventStoreChanged, object: eventStore)
        presenter.beginPresenting(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        presenter.stopPresenting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addEvent(for item: SCCalendarItem) {
        navigationController?.present(EKEventEditViewController(calendarItem: item, delegate: self), animated: true, completion: nil)
    }

    func showDetails(for item: SCEventCalendarItem) {
        navigationController?.pushViewController(EventDetailsViewController(eventItem: item), animated: true)
    }

    // MARK: - edit view delegate

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - peek and pop

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath),
              let item = dataSource.item(at: indexPath) else {
            return nil
        }

        previewingContext.sourceRect = cell.frame

        if item.isEmpty() {
            return nil
        } else {
            let details = EventDetailsViewController(item: item)
            details?.preferredContentSize = view.frame.size
            return details
        }
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

    func didUpdateSource(_ source: SCCalendarSource) {
        dataSource.update(source)
        tableView.reloadData()
        failedAccessView?.alpha = 0
        failedAccessView?.isUserInteractionEnabled = true
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = false
    }

    func failedToAccessCalendar(_ error: NSError) {
        failedAccessView?.alpha = 1
        failedAccessView?.isUserInteractionEnabled = false
        tableView.alpha = 0
        tableView.isUserInteractionEnabled = true
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
