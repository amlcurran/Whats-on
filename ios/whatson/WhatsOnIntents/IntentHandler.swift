//
//  IntentHandler.swift
//  WhatsOnIntents
//
//  Created by Alex Curran on 23/09/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import Intents
import Core

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        print(intent)
        if intent is CheckCalendarIntent {
            print("Returning intent")
            return CheckCalendarHandler()
        }
        return self
    }
    
}
