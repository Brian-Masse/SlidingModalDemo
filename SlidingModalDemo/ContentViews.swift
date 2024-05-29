//
//  ContentViews.swift
//  SlidingModalDemo
//
//  Created by Brian Masse on 5/29/24.
//

import Foundation
import SwiftUI

//MARK: Front Content
struct FrontContent: View {
    @ViewBuilder
    private func makeHeader() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Brasil Santos")
                    .font(Font.custom("BNShadeRegular", size: 25))
                Spacer()
                
                Text("$17.00")
                    .font(Font.custom("monoid", size: 14))
                    .opacity(0.6)
            }
            
            Text("250 gm")
                .font(Font.custom("monoid", size: 14))
                .opacity(0.6)
        }
    }
    
    @ViewBuilder
    private func makeInfo( icon: String, label: String) -> some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 35)
                .foregroundStyle(LocalConstants.accentColor)
            
            Text(label)
                .font(Font.custom("monoid", size: 12))
                .lineLimit(1)
                .opacity(0.6)
        }.padding(.horizontal)
    }
    
//    MARK: Body
    var body: some View {
        VStack(alignment: .center) {
            
            ZStack(alignment: .topTrailing) {
                HStack {
                    Spacer()
                    Image("map")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(30)
                        .frame(height: LocalConstants.minCoverHeight + 50)
                        .padding(.bottom, -30)
                    Spacer()
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    makeHeader()
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        
                        makeInfo(icon: "circle.dotted.and.circle", label: "Vanilla")
                        
                        makeInfo(icon: "waterbottle", label: "paprkia")
                        
                        makeInfo(icon: "sun.min", label: "Anise")
                        
                        makeInfo(icon: "scribble", label: "Cinnamon")
                        
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    Text("Brasil Santos")
                        .font(Font.custom("BNShadeRegular", size: 25))
                    
                    Text(smallFillerText)
                        .font(Font.custom("times", size: 20))
                    
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(height: 50)
                }
            }
            Spacer()
        }
        .padding(35)
    }
}

//MARK: BackContent
struct BackContent: View {
    
    @Binding var peekState: PeekState
    
    private let titleId = "titleID"
    @Namespace var backContentNS
    
    @ViewBuilder
    private func makeDismissButton() -> some View {
        Button(action: { withAnimation { peekState = .mid } }, label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
                .padding()
                .background {
                    Rectangle()
                        .foregroundStyle(LocalConstants.accentColor)
                        .cornerRadius(LocalConstants.cornerRadius)
                }
        })
    }
    
//    MARK: Header
    @ViewBuilder
    private func makeHeader() -> some View {
  
        switch peekState {
        case .minimized:
            HStack {
                Spacer()
                Text("Slide up to read more")
                    .font(Font.custom("BNShadeRegular", size: 25))
                Spacer()
            }.matchedGeometryEffect(id: titleId, in: backContentNS)
            
        default:
            VStack(alignment: .leading) {
                HStack {
                    Text("Brasil Santos")
                        .font(Font.custom("BNShadeRegular", size: 35))
                        .matchedGeometryEffect(id: titleId, in: backContentNS)
                    
                    if peekState == .full {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(LocalConstants.lightColor)
                    }
                    
                    Spacer()
                }
                Text("The best coffee bean in Latin America")
                    .font(Font.custom("times", size: 22))
            }
        }
    }
    
//    MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            makeHeader()
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                if peekState != .minimized {
                    Text(fillerText)
                        .font(Font.custom("times", size: 15))
                        .padding(.bottom, 50)
                }
            }
            .ignoresSafeArea()
        }
        .padding(.horizontal, 8)
        .padding(.top)
        .padding()
    }
}

#Preview(body: {
    SlidingModal { peekState in
        FrontContent()
    } backContentBuilder: { peekState in
        BackContent(peekState: peekState)
    }
})



let smallFillerText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nunc id cursus metus aliquam. Quam lacus suspendisse faucibus interdum. Aenean sed adipiscing diam donec adipiscing tristique. Ut consequat semper viverra nam libero justo laoreet sit amet."

let fillerText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nunc id cursus metus aliquam. Quam lacus suspendisse faucibus interdum. Aenean sed adipiscing diam donec adipiscing tristique. Ut consequat semper viverra nam libero justo laoreet sit amet. Augue lacus viverra vitae congue eu consequat. Ut enim blandit volutpat maecenas volutpat blandit aliquam etiam. Cras adipiscing enim eu turpis egestas pretium. Sed cras ornare arcu dui vivamus arcu felis. Pharetra vel turpis nunc eget lorem dolor sed. Euismod elementum nisi quis eleifend quam. Libero justo laoreet sit amet cursus. Amet tellus cras adipiscing enim eu turpis egestas pretium. Ipsum faucibus vitae aliquet nec ullamcorper sit amet. Hac habitasse platea dictumst vestibulum rhoncus. Tempor id eu nisl nunc mi ipsum faucibus vitae aliquet.\n\nMassa eget egestas purus viverra accumsan in. Elit sed vulputate mi sit amet mauris commodo. Cursus eget nunc scelerisque viverra mauris in. Pulvinar pellentesque habitant morbi tristique senectus et netus. Commodo nulla facilisi nullam vehicula ipsum. Tincidunt ornare massa eget egestas purus viverra accumsan. Tortor pretium viverra suspendisse potenti. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices gravida. In pellentesque massa placerat duis. Enim ut tellus elementum sagittis vitae et leo duis. Nunc sed blandit libero volutpat sed cras. Venenatis a condimentum vitae sapien pellentesque habitant morbi tristique senectus. Nibh mauris cursus mattis molestie a iaculis at erat. Vehicula ipsum a arcu cursus vitae congue mauris rhoncus.\n\nViverra tellus in hac habitasse platea dictumst vestibulum. Pretium aenean pharetra magna ac placerat vestibulum. Etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus. Aliquet lectus proin nibh nisl condimentum id venenatis a. Eget nullam non nisi est sit. Sit amet nisl purus in mollis nunc sed id semper. Sem nulla pharetra diam sit amet nisl suscipit adipiscing. Ipsum suspendisse ultrices gravida dictum fusce ut placerat. A condimentum vitae sapien pellentesque habitant morbi tristique senectus. Purus gravida quis blandit turpis cursus in. Mattis rhoncus urna neque viverra justo nec ultrices. Diam in arcu cursus euismod quis viverra nibh cras pulvinar. Tincidunt tortor aliquam nulla facilisi cras fermentum. Tellus at urna condimentum mattis pellentesque id nibh tortor id. Praesent semper feugiat nibh sed pulvinar. At urna condimentum mattis pellentesque. Amet justo donec enim diam.\n\nTellus pellentesque eu tincidunt tortor. Amet risus nullam eget felis eget. Ut porttitor leo a diam sollicitudin. Facilisis mauris sit amet massa vitae tortor condimentum. In fermentum et sollicitudin ac orci phasellus egestas tellus rutrum. Pellentesque elit eget gravida cum sociis. Semper feugiat nibh sed pulvinar proin gravida hendrerit. Cursus eget nunc scelerisque viverra mauris in aliquam sem fringilla. Pellentesque habitant morbi tristique senectus. Nam at lectus urna duis convallis convallis tellus id interdum. Tristique nulla aliquet enim tortor. Facilisis mauris sit amet massa vitae tortor condimentum. Tempor nec feugiat nisl pretium fusce id velit ut. Tortor vitae purus faucibus ornare suspendisse sed nisi lacus sed. Feugiat nibh sed pulvinar proin gravida hendrerit lectus a. Dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim.\n\nMi in nulla posuere sollicitudin aliquam ultrices sagittis. Vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Orci phasellus egestas tellus rutrum tellus pellentesque. Eu facilisis sed odio morbi quis. Sed blandit libero volutpat sed cras ornare arcu dui. Tellus cras adipiscing enim eu turpis egestas pretium. Bibendum enim facilisis gravida neque convallis a. Urna nec tincidunt praesent semper feugiat nibh sed. Consectetur adipiscing elit duis tristique sollicitudin nibh. Erat imperdiet sed euismod nisi porta lorem. Pharetra pharetra massa massa ultricies mi quis hendrerit. Luctus accumsan tortor posuere ac ut. Orci a scelerisque purus semper. Amet luctus venenatis lectus magna fringilla urna porttitor. Amet tellus cras adipiscing enim eu turpis egestas. Et ultrices neque ornare aenean euismod elementum nisi quis. Vulputate eu scelerisque felis imperdiet proin fermentum leo vel orci. Enim eu turpis egestas pretium aenean pharetra."
