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

class WhatsOnViewController: UIViewController, EKEventEditViewDelegate, UIViewControllerPreviewingDelegate, WhatsOnPresenterDelegate,
    UITableViewDelegate, UITableViewDataSource {
    
    var dateFormatter : DateFormatter!;
    var eventStore : EKEventStore!;
    var dayColor : UIColor!;
    var presenter : WhatsOnPresenter!
    var calendarSource : SCCalendarSource?;
    var eventService : SCEventsService!;
    let timeCalculator = NSDateCalculator();
    let tableView = UITableView()

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
        
        title = "What's On";
        
        let newCellNib = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        tableView.register(newCellNib, forCellReuseIdentifier: "day")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let slot = self.calendarSource?.slotAt(with: jint((indexPath as NSIndexPath).row)),
            let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
            preconditionFailure("Accessing a slot which doesn't exist")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as! CalendarSourceViewCell;
        cell.bind(item, slot: slot);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = calendarSource?.count() {
            return Int(count);
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
            preconditionFailure("Calendar didn't have item at expected index \((indexPath as NSIndexPath).row)")
        }
        if item.isEmpty() {
            let addController = addEventController(item);
            self.navigationController?.present(addController, animated: true, completion: nil);
        } else {
            if let editController = editEventController(item as! SCEventCalendarItem) {
                self.navigationController?.pushViewController(editController, animated: true)
            }
        }
    }
    
    func addEventController(_ calendarItem: SCCalendarItem) -> UIViewController {
        let newEvent = EKEvent(eventStore: eventStore);
        let startDate = timeCalculator.date(calendarItem.startTime());
        let endDate = timeCalculator.date(calendarItem.endTime());
        let editController = EKEventEditViewController();
        newEvent.startDate = startDate;
        newEvent.endDate = endDate;
        editController.eventStore = eventStore;
        editController.event = newEvent;
        editController.editViewDelegate = self;
        return editController;
    }
    
    func editEventController(_ calendarItem: SCEventCalendarItem) -> UIViewController? {
        let itemId = calendarItem.id__();
        guard let event = eventStore.event(withIdentifier: itemId!) else {
            return nil
        }
//        let showController = EKEventViewController();
//        showController.event = event;
        let showController = EventDetailsViewController(event: event)
        return showController;
    }
    
    // MARK: - edit view delegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    
    // MARK: - peek and pop
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath),
            let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
                return nil
        }
    
        previewingContext.sourceRect = cell.frame
        
        if item.isEmpty() {
            return nil;
        } else {
            let vc = editEventController(item as! SCEventCalendarItem)
            vc?.preferredContentSize = self.view.frame.size
            return vc
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true);
    }
    
    func didUpdateSource(_ source: SCCalendarSource) {
        self.calendarSource = source;
        self.tableView.reloadData();
    }
    
    func failedToAccessCalendar(_ error: NSError?) {
        print(error)
    }

}
