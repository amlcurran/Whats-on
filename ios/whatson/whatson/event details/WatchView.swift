//
//  WatchView.swift
//  whatson
//
//  Created by Alex Curran on 23/06/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//
import SwiftUI

let colors = [
    Color.brown,
    Color.black,
    Color.purple,
    Color.blue,
    Color.cyan,
    Color.teal,
    Color.yellow,
    Color.pink,
    Color.orange,
    Color.red
]

struct WatchView: View {
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<10) { int in
                Rectangle()
                    .foregroundColor(colors[int])
                    .frame(width: 8)
            }
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView()
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
