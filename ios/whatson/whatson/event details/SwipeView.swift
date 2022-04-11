//
//  SwipeView.swift
//  whatson
//
//  Created by Alex Curran on 11/04/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

struct SwipeView<Content: View>: View {
    @State var offset: CGFloat = 0
    let onDeleteTapped: () -> Void
    @ViewBuilder var content: () -> Content
    
    private let maxGestureLength: CGFloat = -60
    
    var body: some View {
        content()
            .offset(x: max(offset, maxGestureLength))
            .background {
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("error"))
                    Image(systemName: "trash.fill")
                        .font(.system(size: 24))
                        .scaleEffect(min(1.0, offset / (maxGestureLength / 1.5)))
                        .opacity(min(1.0, offset / (maxGestureLength / 1.5)))
                        .padding()
                        .foregroundColor(.white)
                }
                .onTapGesture(perform: onDeleteTapped)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let _ = print(gesture.translation.width)
                        withAnimation(.easeInOut.speed(2)) {
                        offset = min(gesture.translation.width, 0)
                        }
                    }
                    .onEnded { _ in
                        if offset > maxGestureLength / 1.5 {
                            withAnimation(.easeInOut.speed(2)) {
                                offset = 0
                            }
                        } else {
                            withAnimation(.easeInOut.speed(3)) {
                                offset = maxGestureLength
                            }
                        }
                    }
            )
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView {
            
        } content: {
            Text("Hello")
        }
    }
}
