//
//  InstallView.swift
//  EmojiCam
//
//  Created by Fazekas, Gergo on 07.09.2024.
//

import SwiftUI

struct InstallView: View {
    @StateObject var viewModel = InstallViewModel()

    var body: some View {
        InstallViewContent(logText: viewModel.logText, onAction: viewModel.onAction)
    }
}

struct InstallViewContent: View {
    let logText: String
    let onAction: (InstallAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                installButton
                Spacer()
                    .frame(maxWidth: 50)
                uninstallButton
            }
            .frame(maxWidth: .infinity)

            logTextView
        }
        .padding()
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .topLeading)
    }

    private var installButton: some View {
        Button {
            onAction(.install)
        } label: {
            Text("Install")
        }
    }

    private var uninstallButton: some View {
        Button {
            onAction(.uninstall)
        } label: {
            Text("Uninstall")
        }
    }

    private var logTextView: some View {
        Text(logText)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
}
