//
//  EmptySlot.swift
//  whatson
//
//  Created by Alex Curran on 03/03/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    
    @State var isTapped = false
    
    var body: some View {
        Text("Nothing on")
            .labelStyle(.lower)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background  {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 8, dash: [8, 8], dashPhase: 0))
                        .foregroundColor(Color("emptyOutline"))
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("emptyOutline"))
                        .opacity(isTapped ? 0.3 : 0.0)
                        .scaleEffect(x: isTapped ? 1.0 : 0.9, y: 1.0, anchor: .center)
                        .animation(.easeInOut.speed(3), value: isTapped)
                    
                }
            }
    }
    
}
