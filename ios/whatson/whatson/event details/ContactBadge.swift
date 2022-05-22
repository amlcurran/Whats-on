//
//  ContactBadge.swift
//  whatson
//
//  Created by Alex Curran on 11/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

private let gray: CGFloat = 0.8

struct ContactBadge: View {
    
    let attendee: Attendee
    
    var body: some View {
        Text(attendee.initials)
            .font(.caption.bold())
            .foregroundColor(.white)
            .frame(width: 32,
                   height: 32,
                   alignment: .center)
            .background(LinearGradient(colors: [Color(white: 0.7), Color(white: 0.6)], startPoint: .top, endPoint: .bottom))
            .mask(Circle())
    }
}

extension Color {
    
    init(white: CGFloat) {
        self.init(.sRGB, red: white, green: white, blue: white, opacity: 1.0)
    }
    
}

struct ContactBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContactBadge(attendee: .init(identifier: "abc", givenName: "Foo", familyName: "Bar"))
                .padding()
                .background { Color.white }
                .preferredColorScheme(.light)
            ContactBadge(attendee: .init(identifier: "abc", givenName: "Foo", familyName: "Bar"))
                .padding()
                .background { Color.black }
                .preferredColorScheme(.dark)
        }
    }
}
