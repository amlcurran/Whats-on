//
//  WhatsOnViewController.swift
//  whatson
//
//  Created by Alex on 02/10/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class WhatsOnViewController: UIViewController, EKEventEditViewDelegate, UIViewControllerPreviewingDelegate, WhatsOnPresenterDelegate, CalendarDataSourceDelegate {
    
    var dateFormatter : DateFormatter!;
    var eventStore : EKEventStore!;
    var dayColor : UIColor!;
    var presenter : WhatsOnPresenter!
    var eventService : SCEventsService!;
    let timeCalculator = NSDateCalculator();
    let tableView = UITableView()
    lazy var dataSource: CalendarDataSource = {
        return CalendarDataSource(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = .windowBackground
        eventStore = EKEventStore()
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView);
        }
        dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "EEE";
        dayColor = UIColor.black.withAlphaComponent(0.54);
        let timeRepo = TimeRepository()
        let eventRepo = EventStoreRepository(timeRepository: timeRepo)
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator())
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        let header = HeaderView()
        blurView.add(header, constrainedTo: [.leading], withOffset: 16)
        header.constrainToSuperview(edges: [.trailing, .bottom], withOffset: -16)
        
        view.add(tableView, constrainedTo: [.bottom, .leading, .trailing])
        view.add(blurView, constrainedTo: [.leading, .trailing, .top])
        header.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.contentInset = UIEdgeInsets(top: header.intrinsicContentSize.height + 38, left: 0, bottom: 16, right: 0)
        
        title = " "
        
        let newCellNib = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        tableView.register(newCellNib, forCellReuseIdentifier: "day")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
    }
    
    func eventsChanged() {
        presenter.refreshEvents()
    }
    
    func editTapped() {
        let options = OptionsViewController.create()
        let navigationController = UINavigationController(rootViewController: options)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        NotificationCenter.default.addObserver(self, selector:#selector(eventsChanged), name: NSNotification.Name.EKEventStoreChanged, object: eventStore)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.beginPresenting(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self);
        presenter.stopPresenting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addEvent(for item: SCCalendarItem) {
        let addController = EKEventEditViewController(calendarItem: item, delegate: self, calculator: timeCalculator)
        navigationController?.present(addController, animated: true, completion: nil)
    }
    
    func showDetails(for item: SCEventCalendarItem) {
        navigationController?.pushViewController(editEventController(item), animated: true)
    }
    
    func editEventController(_ calendarItem: SCEventCalendarItem) -> UIViewController {
        let itemId = calendarItem.id__();
        guard let event = eventStore.event(withIdentifier: itemId!) else {
            preconditionFailure("Trying to view an event which doesnt exist")
        }
        let showController = EventDetailsViewController(event: event)
        return showController;
    }
    
    // MARK: - edit view delegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        navigationController?.dismiss(animated: true, completion: nil);
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
            return nil;
        } else {
            let vc = editEventController(item as! SCEventCalendarItem)
            vc.preferredContentSize = self.view.frame.size
            return vc
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true);
    }
    
    func didUpdateSource(_ source: SCCalendarSource) {
        dataSource.update(source)
        tableView.reloadData()
    }
    
    func failedToAccessCalendar(_ error: NSError?) {
        print(error)
    }

}

fileprivate extension EKEventEditViewController {
    
    convenience init(calendarItem: SCCalendarItem, delegate: EKEventEditViewDelegate, calculator: NSDateCalculator, eventStore: EKEventStore = EKEventStore.instance) {
        self.init()
        self.eventStore = eventStore
        self.event = EKEvent(representing: calendarItem, calculator: calculator, eventStore: eventStore)
        self.editViewDelegate = delegate
    }
    
}

fileprivate extension EKEvent {
    
    convenience init(representing calendarItem: SCCalendarItem, calculator: NSDateCalculator, eventStore: EKEventStore = EKEventStore.instance) {
        self.init(eventStore: eventStore)
        self.startDate = calculator.date(calendarItem.startTime())
        self.endDate = calculator.date(calendarItem.endTime())
    }
    
}
