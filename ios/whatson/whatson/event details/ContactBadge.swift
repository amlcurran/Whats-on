//
//  ContactBadge.swift
//  whatson
//
//  Created by Alex Curran on 11/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct ContactBadge: View {
    
    let attendee: Attendee
    
    var body: some View {
        Text(attendee.initials)
            .font(.caption.bold())
            .foregroundColor(.white)
            .frame(width: 32,
                   height: 32,
                   alignment: .center)
            .background(Circle().fill(.gray))
            .shadow(radius: 1)
    }
}

struct ContactBadge_Previews: PreviewProvider {
    static var previews: some View {
        ContactBadge(attendee: .init(identifier: "abc", givenName: "Foo", familyName: "Bar"))
    }
}
