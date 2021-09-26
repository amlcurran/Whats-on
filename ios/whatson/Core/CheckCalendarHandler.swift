//
//  CheckCalendarHandler.swift
//  Core
//
//  Created by Alex Curran on 23/09/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import Intents

public class CheckCalendarHandler: NSObject, CheckCalendarIntentHandling {
    
    public func handle(intent: CheckCalendarIntent, completion: @escaping (CheckCalendarIntentResponse) -> Void) {
        print("Handling")
        completion(CheckCalendarIntentResponse(code: .failure, userActivity: nil))
    }

    public func resolveDay(for intent: CheckCalendarIntent, with completion: @escaping (PickDayResolutionResult) -> Void) {
        completion(.success(with: intent.day))
    }


}
