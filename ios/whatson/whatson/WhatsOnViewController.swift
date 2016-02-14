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

class WhatsOnViewController: UITableViewController, EKEventEditViewDelegate, UIViewControllerPreviewingDelegate {
    
    var dateFormatter : NSDateFormatter!;
    var eventStore : EKEventStore!;
    var dayColor : UIColor!;
    var calendarSource : SCCalendarSource?;
    var eventService : SCEventsService!;
    let timeCalculator = NSDateCalculator();

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: self.tableView);
            }
        } else {
            // Fallback on earlier versions
        }
        dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "EEE";
        eventStore = EKEventStore();
        dayColor = UIColor.blackColor().colorWithAlphaComponent(0.54);
        let timeRepo = SCITimeRepository();
        let eventRepo = SCIEventStoreRepository();
        eventService = SCEventsService(SCTimeRepository: timeRepo, withSCEventsRepository: eventRepo);
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.561, blue: 0.486, alpha: 1);
        navigationController?.navigationBar.tintColor = UIColor(white: 1, alpha: 0.8);
        
        title = "What's On";
        
        let newCellNib = UINib.init(nibName: "CalendarCell", bundle: NSBundle.mainBundle());
        self.tableView.registerNib(newCellNib, forCellReuseIdentifier: "day");
        self.tableView.rowHeight = 56;
        self.tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
//        self.tableView.estimatedRowHeight = 56;
    }
    
    func eventsChanged() {
        self.fetchEvents { (source) -> Void in
            self.calendarSource = source;
            self.tableView.reloadData();
        }
    }
    
    func fetchEvents(completion: (SCCalendarSource -> Void)) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue) {
            let now = NSDateCalculator().now();
            let source = self.eventService.getCalendarSourceWithInt(14, withSCTime:now);
            dispatch_async(dispatch_get_main_queue()) {
                completion(source);
            };
        };
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"eventsChanged", name: EKEventStoreChangedNotification, object: eventStore);
        eventStore.requestAccessToEntityType(.Event) { (success, error) -> Void in
            self.fetchEvents({ (source) -> Void in
                self.calendarSource = source;
                self.tableView.reloadData();
            })
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("day", forIndexPath: indexPath) as! CalendarSourceViewCell;
        let item = self.calendarSource!.itemAtWithInt(jint(indexPath.row));
        let slot = self.calendarSource!.slotAtWithInt(jint(indexPath.row));
        cell.bind(item, slot: slot);
        return cell;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = calendarSource?.count() {
            return Int(count);
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.calendarSource?.itemAtWithInt(jint(indexPath.row));
        if item!.isEmpty() {
            let addController = addEventController(item!);
            self.navigationController?.presentViewController(addController, animated: true, completion: nil);
        } else {
            let editController = editEventController(item as! SCEventCalendarItem);
            if (editController != nil) {
                self.navigationController?.pushViewController(editController!, animated: true);
            }
        }
    }
    
    func addEventController(calendarItem: SCCalendarItem) -> UIViewController {
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
    
    func editEventController(calendarItem: SCEventCalendarItem) -> UIViewController? {
        let itemId = calendarItem.id__();
        guard let event = eventStore.eventWithIdentifier(itemId) else {
            return nil
        }
        let showController = EKEventViewController();
        showController.event = event;
        return showController;
    }
    
    // MARK: - edit view delegate
    
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - peek and pop
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else {
                return nil
        }
        
        let item = self.calendarSource?.itemAtWithInt(jint(indexPath.row));
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        } else {
            return nil;
        };
        
        if item!.isEmpty() {
            return nil;
        } else {
            return editEventController(item as! SCEventCalendarItem);
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    
*/

}
