//
//  ScrollReader.swift
//  SlidingModalDemo
//
//  Created by Brian Masse on 5/28/24.
//

import Foundation
import SwiftUI

struct StyledScrollView<C: View>: View {
    
    let coordinateSpaceName = "scroll"
    
    @State var scrollPosition: CGPoint = .zero
    
    let content: C
    
    init( contentBuilder: () -> C ) {
        self.content = contentBuilder()
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .top) {
                        content
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named(coordinateSpaceName)).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                    }
                }
                .coordinateSpace(name: coordinateSpaceName)
            }
        }
    }
}

//MARK: PreferenceKey
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
