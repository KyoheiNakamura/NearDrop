//
//  Preferences.swift
//  NearDrop
//
//  Created by Kyohei Nakamura on 2023/07/15.
//

enum Preferences {
    @UserDefault(key: "openFiles", defaultValue: true)
    static var openFilesInFinder: Bool

    @UserDefault(key: "openLinks", defaultValue: true)
    static var openLinksInBrowser: Bool
    
    @UserDefault(key: "copyWithoutConsent", defaultValue: true)
    static var copyToClipboardWithoutConsent: Bool
}
