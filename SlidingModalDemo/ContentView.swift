//
//  ContentView.swift
//  SlidingModalDemo
//
//  Created by Brian Masse on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        SlidingModal { peekState in
            FrontContent()
        } backContentBuilder: { peekState in
            BackContent(peekState: peekState)
        }
    }
}

#Preview {
    ContentView()
}
