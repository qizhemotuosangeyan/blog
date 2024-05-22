//
//  TestHStackPriorityApp.swift
//  TestHStackPriority
//
//  Created by 千千 on 5/13/24.
//

import SwiftUI

@main
struct TestHStackPriorityApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            // 设置窗口的推荐尺寸（例如800x600）
            let windowWidth: CGFloat = 400
            let windowHeight: CGFloat = 300
            
            // 获取主屏幕的尺寸
            if let screen = NSScreen.main {
                let screenRect = screen.visibleFrame
                
                // 计算窗口的位置，使其居中显示
                let windowRect = NSRect(
                    x: (screenRect.width - windowWidth) / 2,
                    y: (screenRect.height - windowHeight) / 2,
                    width: windowWidth,
                    height: windowHeight
                )
                
                // 设置窗口的尺寸和位置
                window.setFrame(windowRect, display: true)
            }
        }
    }
}
