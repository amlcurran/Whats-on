//
//  SwiftUIView.swift
//  whatson
//
//  Created by Alex Curran on 09/06/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

let bobHeight: CGFloat = 80
let poolHeight: CGFloat = 400

@available(iOS 16.0, *)
struct FishingView: View {
    
    @State var velocity: CGFloat = 0
    @State var height: CGFloat = 0
    
    private let ticker = Timer.publish(every: 0.1,
                                       on: .main,
                                       in: .default)
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.gray.gradient)
                    .frame(width: 66, height: poolHeight)
                RoundedRectangle(cornerRadius: 20)
                    .fill(.green.gradient)
                    .frame(width: 66, height: bobHeight)
                    .offset(y: ((poolHeight - bobHeight) / 2) - height)
                    .animation(.default.speed(3), value: height)
            }
            .onTapGesture {
                velocity += 1
            }
            .onReceive(ticker) { _ in
                let clamped = (height + velocity * 40).clamping(between: 0, and: poolHeight - bobHeight)
                height = clamped.value
                switch clamped.isAtLimit {
                case .atLower:
                    velocity = 0
                case .unclamped:
                    velocity -= 0.15
                case .atUpper:
                    velocity -= 0.3
                }
            }
            .onAppear {
                ticker.connect()
            }
            Text("\(velocity)")
        }
    }
}

enum Clamping {
    case atLower
    case unclamped
    case atUpper
}

struct Clamped {
    let value: CGFloat
    let isAtLimit: Clamping
}

extension CGFloat {
    
    func clamping(between lower: CGFloat,
                  and upper: CGFloat) -> Clamped {
        let value = Swift.min(Swift.max(self, lower), upper)
        let clamping: Clamping
        switch value {
        case upper:
            clamping = .atUpper
        case lower:
            clamping = .atLower
        default:
            clamping = .unclamped
        }
        return Clamped(value: value, isAtLimit: clamping)
    }
    
}

@available(iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FishingView()
    }
}
