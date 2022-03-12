//
//  CuteView.swift
//  whatson
//
//  Created by Alex Curran on 12/03/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

struct CuteView: View {
    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            ZStack {
                Path { path in
                    path.addRelativeArc(center: CGPoint(x: proxy.size.width / 2, y: 200), radius: (proxy.size.width / 2) - 50, startAngle: .degrees(180), delta: .degrees(180))
                }.stroke()
                    .stroke(lineWidth: 8)
                    .foregroundColor(Color("secondary"))
                let offset = UIScreen.main.bounds.maxY - proxy.frame(in: .global).maxY
                let maxOffset: CGFloat = 150
                let _ = print(offset)
                Circle()
                    .size(width: 50, height: 50)
                    .offset(x: offset / maxOffset * proxy.size.width, y: 200 - 200 * sin(offset / maxOffset * .pi))
            }
            .frame(minHeight: 200)
        }
    }
}

struct CuteView_Previews: PreviewProvider {
    static var previews: some View {
        
        CuteView()
        
    }
}
