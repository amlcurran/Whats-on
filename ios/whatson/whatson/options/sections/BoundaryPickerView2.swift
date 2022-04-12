//
//  BoundaryPickerView2.swift
//  whatson
//
//  Created by Alex Curran on 13/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI

struct BoundaryPickerView2: View {

    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            Text("Show events between")
            HStack {
                DatePicker("",
                           selection: $startDate,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                Text("and")
                DatePicker("",
                           selection: $endDate,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
        }
    }
}

struct BoundaryPickerView2_Previews: PreviewProvider {
    static var previews: some View {
        BoundaryPickerView2(
            startDate: .constant(Date()),
            endDate: .constant(Date().addingTimeInterval(-68000))
        )
    }
}
