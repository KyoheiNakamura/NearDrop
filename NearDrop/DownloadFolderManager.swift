//
//  FileManagerUtils.swift
//  NearDrop
//
//  Created by Kyohei Nakamura on 2023/07/15.
//

import AppKit

class DownloadsFolderManager {
    static let shared = DownloadsFolderManager()
    private let defaults = UserDefaults.standard
    
    private let downloadsFolderPermissionKey = "DownloadsFolderPermission"
    
    private init() {}
    
    func openDownloadsFolderPanel() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first

        openPanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let url = openPanel.url {
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
            }
        }
    }
    
    func requestDownloadsFolderAccess() {
        let alert = NSAlert()
        alert.messageText = "アプリケーションにダウンロードフォルダへのアクセスを許可しますか？"
        alert.informativeText = "アプリケーションがダウンロードフォルダにアクセスするためには、許可が必要です。"
        alert.addButton(withTitle: "許可する")
        alert.addButton(withTitle: "キャンセル")
        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            // ユーザーが許可ボタンを選択した場合の処理
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security")!)
        } else {
            // ユーザーがキャンセルボタンを選択した場合の処理
            NSApplication.shared.terminate(nil)
        }
    }
    
    func checkDownloadFolderPermission() {
        let hasPermission = defaults.bool(forKey: downloadsFolderPermissionKey)

        if hasPermission {
            openDownloadsFolder()
        } else {
            requestDownloadsFolderPermission()
//            DispatchQueue.main.async {
//                self.requestDownloadsFolderAccess()
//            }
        }
    }
    
    private func requestDownloadsFolderPermission() {
        if let downloadsURL = (try? FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true))?.resolvingSymlinksInPath() {
            print(downloadsURL)

            if let bookmarks = try? downloadsURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) {
                defaults.set(bookmarks, forKey: downloadsFolderPermissionKey)
                defaults.synchronize()

                if downloadsURL.startAccessingSecurityScopedResource() {
                    openDownloadsFolder()
                }
            }
        }
    }
    
    private func openDownloadsFolder() {
        if let downloadsURL = (try? FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true))?.resolvingSymlinksInPath() {
            NSWorkspace.shared.open(downloadsURL)
        }
    }
}
