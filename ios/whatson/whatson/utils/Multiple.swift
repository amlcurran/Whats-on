//
//  Multiples.swift
//  whatson
//
//  Created by Alex Curran on 22/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import Foundation

enum Multiple<T> {
    case none
    case single(T)
    case multiple([T])
}

extension Array {
    
    var asMultiple: Multiple<Element> {
        if count == 0 {
            return .none
        }
        if count == 1 {
            return .single(first!)
        }
        return .multiple(self)
    }
    
}
