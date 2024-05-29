//
//  SlidingModal.swift
//  SlidingModalDemo
//
//  Created by Brian Masse on 5/28/24.
//

import Foundation
import SwiftUI


struct LocalConstants {
        
    static let minCoverHeight: CGFloat = 300
    static let startingPeekHeight: CGFloat = 75
    static let slidingHandleHeight: CGFloat = 30
    
    static let slidingVisibleHandleHeight: CGFloat = 40
    static let slidingVisibleHandleWidth: CGFloat = 80
    
    static let minimizePeekThreshold: CGFloat = 10
    static let showFullCoverThreshold: CGFloat = 75
    
    static let lightColor = Color(red: 1, green: 248/255, blue: 223/255)
    static let accentColor = Color(red: 190 / 255, green: 72 / 255, blue: 22 / 255)
    
    static let cornerRadius: CGFloat = 40
}

//MARK: SlidingModal
enum PeekState {
    case full
    case minimized
    case mid
}

struct SlidingModal<C1:View, C2:View>: View {
    
    private let coordinateSpaceName = "SlidingModalCoordinateSpaceName"
    
    @State var height: CGFloat = LocalConstants.startingPeekHeight
    
    @State var peekState: PeekState = .minimized
    @State var inDismissGesture = false
    
    @ViewBuilder var frontContentBuilder:   (Binding<PeekState>) -> C1
    @ViewBuilder var backContentBuilder:    (Binding<PeekState>) -> C2
    
    init( frontContentBuilder: @escaping (Binding<PeekState>) -> C1,
          backContentBuilder: @escaping (Binding<PeekState>) -> C2 ) {
        self.frontContentBuilder = frontContentBuilder
        self.backContentBuilder = backContentBuilder
    }
    
//    MARK: ShapeMask
    struct PeekMask: Shape {
        func path(in rect: CGRect) -> Path {
            
            let r = LocalConstants.cornerRadius
            
            return Path { path in
//                left curve
                path.addArc(center: .init(x: r, y: rect.maxY - r),
                            radius: r,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 90),
                            clockwise: true)
                
                path.addLine(to: .init(x: r, y: rect.maxY))
                path.addLine(to: .init(x: 0, y: rect.maxY))
                
//                right curve
                path.move(to: .init( x: rect.maxX - r, y:  rect.maxY - r))
                path.addArc(center: .init(x: rect.maxX - r, y: rect.maxY - r),
                            radius: r,
                            startAngle: Angle(degrees: 90),
                            endAngle: Angle(degrees: 0),
                            clockwise: true)
                
                path.addLine(to: .init(x: rect.maxX,        y: rect.maxY))
                path.addLine(to: .init(x: rect.maxX - r,    y: rect.maxY))
            }
        }
    }
    
//    MARK: PeekToggleMask
    struct PeekToggleMask: Shape {
        func path(in rect: CGRect) -> Path {
            let height = LocalConstants.slidingVisibleHandleHeight
            let width = LocalConstants.slidingVisibleHandleWidth
            
            let r = height / 2
            
            return Path { path in
                
//                topLeft
                var center: CGPoint = .init(x: rect.midX - r - width / 2, y: rect.minY + r)
                path.move(to: center)
                path.addArc(center: center,
                            radius: r,
                            startAngle: Angle(degrees: -90),
                            endAngle:  Angle(degrees: 0),
                            clockwise: false)
                
                path.addLine(to: .init( x: rect.midX - width / 2 + r, y: rect.minY + r ))
                path.addLine(to: .init( x: rect.midX - width / 2 + r, y: rect.minY))
                path.addLine(to: .init( x: rect.midX - r - width / 2, y: rect.minY ))
                
//                bottomLeft
                path.move(to: .init(x: rect.midX + r - width / 2, y: rect.minY + r))
                path.addArc(center: .init(x: rect.midX + r - width / 2, y: rect.minY + r),
                            radius: r,
                            startAngle: Angle(degrees: 180),
                            endAngle:  Angle(degrees: 90),
                            clockwise: true)
                
//                topRight
                center = .init(x: rect.midX + r + width / 2, y: rect.minY + r)
                path.move(to: center)
                path.addArc(center: center,
                            radius: r,
                            startAngle: Angle(degrees: -90),
                            endAngle:  Angle(degrees: -180),
                            clockwise: true)
                
                path.addLine(to: .init( x: rect.midX + width / 2 - r, y: rect.minY + r ))
                path.addLine(to: .init( x: rect.midX + width / 2 - r, y: rect.minY))
                path.addLine(to: .init( x: rect.midX + r + width / 2, y: rect.minY ))
                
//                bottomLeft
                path.move(to: .init(x: rect.midX - r + width / 2, y: rect.minY + r))
                path.addArc(center: .init(x: rect.midX - r + width / 2, y: rect.minY + r),
                            radius: r,
                            startAngle: Angle(degrees: 0),
                            endAngle:  Angle(degrees: 90),
                            clockwise: false)
                
//                rectn
                path.move(to: .init(x: rect.midX + r - width / 2, y: rect.minY))
                path.addLine(to: .init(x: rect.midX - r + width / 2, y: rect.minY))
                path.addLine(to: .init(x: rect.midX - r + width / 2, y: rect.minY + height))
                path.addLine(to: .init(x: rect.midX + r - width / 2, y: rect.minY + height))
                
            }
        }
    }
    
//    MARK: Gestures
    func dragGesture(geo: GeometryProxy) -> some Gesture {
        DragGesture(coordinateSpace: .named(coordinateSpaceName))
            .onChanged { value in
                if peekState == .full {
                    inDismissGesture = true
                }
                
                if inDismissGesture {
                    if value.translation.height > 40 {
                        withAnimation {
                            self.peekState = .mid
                            self.makeHeight(in: geo, dragPosition: value.location.y)
                        }
                    }
                } else {
                    withAnimation {
                        makeHeight(in: geo, dragPosition: value.location.y)
                    }
                }
            }
            .onEnded { vaue in
                inDismissGesture = false
            }
    }

//    MARK: Struct Methods
    private func makeHeight(in geo: GeometryProxy, dragPosition: CGFloat) {
        if peekState == .full { return }
        
        let minimum = LocalConstants.startingPeekHeight
        let maximum = geo.size.height - LocalConstants.minCoverHeight
        
        let proposedHeight = geo.size.height - abs(dragPosition)
        let newHeight = min(max( proposedHeight, minimum), maximum)
        
        if proposedHeight - newHeight > LocalConstants.showFullCoverThreshold {
            self.peekState = .full
            self.height = geo.size.height
            return
        }
        
        if proposedHeight <= LocalConstants.startingPeekHeight + LocalConstants.minimizePeekThreshold {
            self.peekState = .minimized
            self.height = LocalConstants.startingPeekHeight
            return
        }
        
        self.peekState = .mid
        self.height = newHeight
    }
    
//    MARK: ViewBuilder
    @ViewBuilder
    private func makeBackground(in geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundStyle(.black)
                .frame(height: LocalConstants.cornerRadius)
                .clipShape(PeekMask())
                .offset(y: 0.8)
            
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .contentShape(Rectangle())
                        .foregroundStyle(.clear)
                        .gesture(dragGesture(geo: geo))
                    
                    backContentBuilder($peekState)
                        .padding(.top, peekState != .full ? LocalConstants.slidingVisibleHandleHeight : 0)
                }
                
                Spacer()
            }
            .ignoresSafeArea()
            .frame(width: geo.size.width, height: self.height)
            .foregroundStyle( LocalConstants.lightColor )
            .background(.black)
            .overlay(makeToggle(in: geo), alignment: .top)
        }
    }
    
    @ViewBuilder
    private func makeForeground(in geo: GeometryProxy) -> some View {
        VStack {
            Spacer()
            
            if peekState != .full {
                frontContentBuilder($peekState)
            }
            
            Spacer()
        }
        .frame(width: geo.size.width)
        .foregroundStyle( .black )
        .background( LocalConstants.lightColor )
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func makeToggle(in geo: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(LocalConstants.lightColor)
            
            if peekState != .full {
                Image(systemName: "chevron.up")
                    .foregroundStyle(.black)
            }
        }
        .clipShape(PeekToggleMask())
        .frame(width: LocalConstants.slidingVisibleHandleWidth + LocalConstants.slidingHandleHeight,
               height: LocalConstants.slidingVisibleHandleHeight)
        .gesture(dragGesture(geo: geo))
        .offset(y: -1)
        .offset(y: peekState == .full ? -LocalConstants.slidingHandleHeight * 2 : 0)
    }
    
//    MARK: Body
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .ignoresSafeArea()
                    
                    makeForeground(in: geo)
                        .frame(height: geo.size.height - LocalConstants.startingPeekHeight)
                }
                
                makeBackground(in: geo)
            }
            .onAppear { self.height = LocalConstants.startingPeekHeight }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

#Preview(body: {
    SlidingModal { peekState in
        FrontContent()
    } backContentBuilder: { peekState in
        BackContent(peekState: peekState)
    }
})
