//
//  MoreView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI

import SwiftUI

struct MoreView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Login / Register Card
                Button(action: {
                    // handle login/register tap
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "person")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Login / Register")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("for personalised experience")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Links Section
                VStack(spacing: 16) {
                    MoreRow(icon: "message", title: "WhatsApp", action: {
                        openWhatsApp()
                    })
                    MoreRow(icon: "info.circle", title: "Mall Information")
                    MoreRow(icon: "doc.text", title: "Terms & Conditions")
                    MoreRow(icon: "lock.shield", title: "Privacy Policy")
                }
                .padding(.horizontal)

                // App Version
                Text("Version 1.3.0")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 32)
            }
            .padding(.top)
        }
        .navigationTitle("More")
        .background(Color(red: 0.949, green: 0.949, blue: 0.969).ignoresSafeArea())
    }
    
    func openWhatsApp() {
        let phoneNumber = "38976227744" // Removed '+' as URL encoding handles it better
        let urlString = "https://wa.me/\(phoneNumber)"
        
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback to web version if WhatsApp app isn't installed
            let webURL = URL(string: "https://web.whatsapp.com/send?phone=+\(phoneNumber)")!
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}

struct MoreRow: View {
    var icon: String
    var title: String
    var action: (() -> Void)?
    
    init(icon: String, title: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 24)

                Text(title)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        }
    }
}
