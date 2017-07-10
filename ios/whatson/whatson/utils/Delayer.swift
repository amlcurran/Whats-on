//
//  Delayer.swift
//  whatson
//
//  Created by Alex Curran on 02/07/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

class Delayer {

    private let queue: DispatchQueue
    private var expiryTime: DispatchTime = .now()

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func delayUpcomingEvents(by delay: DispatchTimeInterval) {
        expiryTime = .now() + delay
    }

    func runAfterExpiryTime(_ handler: @escaping () -> Void) {
        if expiryTime > .now() {
            queue.asyncAfter(deadline: expiryTime, execute: handler)
        } else {
            queue.async(execute: handler)
        }
        expiryTime = .now()
    }

}
