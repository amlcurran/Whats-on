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

class WhatsOnViewController: UITableViewController, EKEventEditViewDelegate {
    
    var dateFormatter : NSDateFormatter!;
    var eventStore : EKEventStore!;
    var dayColor : UIColor!;
    var calendarSource : SCCalendarSource?;
    var eventService : SCEventsService!;

    override func viewDidLoad() {
        super.viewDidLoad()
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
        eventStore.requestAccessToEntityType(.Event) { (success, error) -> Void in
            self.fetchEvents({ (source) -> Void in
                self.calendarSource = source;
                self.tableView.reloadData();
            })
        }
    }
    
    func fetchEvents(completion: (SCCalendarSource -> Void)) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue) {
            let now = NSDate();
            let source = self.eventService.getCalendarSourceWithInt(14, withSCTime:SCNSDateBasedTime(NSDate: now));
            dispatch_async(dispatch_get_main_queue()) {
                completion(source);
            };
        };
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("day", forIndexPath: indexPath);
        let item = self.calendarSource!.itemAtWithInt(jint(indexPath.row));
        let startTime = NSDate(timeIntervalSince1970: NSTimeInterval(item.startTime().getMillis() / 1000));
        let formatted = String(format: "%@ - %@", dateFormatter .stringFromDate(startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: self.dayColor, range: NSMakeRange(0, colouredString.length));
        } else {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: self.dayColor, range: NSMakeRange(0, 3));
        }
        cell.textLabel?.attributedText = colouredString;
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
            let newEvent = EKEvent(eventStore: eventStore);
            let editController = EKEventEditViewController();
            editController.eventStore = eventStore;
            editController.event = newEvent;
            editController.editViewDelegate = self;
            self.navigationController?.presentViewController(editController, animated: true, completion: nil);
        } else {
            let itemId = (item as! SCEventCalendarItem).id__();
            let event = eventStore.eventWithIdentifier(itemId);
            let showController = EKEventViewController();
            showController.event = event!;
            self.navigationController?.pushViewController(showController, animated: true);
        }
    }
    
    // MARK - edit view delegate
    
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil);
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
