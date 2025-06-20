//
//  WhatsAppButton.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct WhatsAppButton: View {
    var body: some View {
        Button(action: {
            openWhatsApp()
        }) {
            Image("whatsapp")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 100)
    }

    private func openWhatsApp() {
        let phoneNumber = "+38976227744".replacingOccurrences(of: "+", with: "")
        if let url = URL(string: "https://wa.me/\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
