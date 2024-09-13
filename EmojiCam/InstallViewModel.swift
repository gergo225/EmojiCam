//
//  InstallViewModel.swift
//  EmojiCam
//
//  Created by Fazekas, Gergo on 07.09.2024.
//

import Foundation

enum InstallAction {
    case install
    case uninstall
}

final class InstallViewModel: ObservableObject {
    @Published var logText: String = "Log Text"

    func onAction(_ action: InstallAction) {
        switch action {
        case .install:
            installExtension()
        case .uninstall:
            uninstallExtension()
        }
    }
}

private extension InstallViewModel {
    func installExtension() {
        print("TODO: Implement")
    }

    func uninstallExtension() {
        print("TODO: Implement")
    }
}
