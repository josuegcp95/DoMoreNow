//
//  MusicSubscriptionView.swift
//  DoMore
//
//  Created by Josue Cruz on 7/15/24.
//

import SwiftUI

struct MusicSubscriptionView: View {
    @State var isShowingOffer = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                showSubscriptionOffer()
            }
            label: {
                Text("Join Apple Music")
                     .bold()
                     .frame(width: 220, height: 44)
                     .background(Color.blue)
                     .foregroundColor(.white)
                     .cornerRadius(8)
            }
            
            Button {
                dismiss()
            }
            label: {
                Text("Dismiss")
                     .bold()
                     .frame(width: 220, height: 44)
                     .background(Color.pink)
                     .foregroundColor(.white)
                     .cornerRadius(8)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(colors: [.white, .gray, .blue], startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .musicSubscriptionOffer(isPresented: $isShowingOffer)
        .onAppear { showSubscriptionOffer() }
    }
        
    private func showSubscriptionOffer() {
        isShowingOffer = true
    }
}

#Preview {
    MusicSubscriptionView()
}
