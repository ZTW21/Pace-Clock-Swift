//
//  IdleTimerDisabledView.swift
//  Pace Clock Watch App
//
//  Created by Zack Wilson on 1/12/24.
//

import SwiftUI
import UIKit

struct IdleTimerDisabledView: UIViewControllerRepresentable {
    var disableIdleTimer: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        UIApplication.shared.isIdleTimerDisabled = disableIdleTimer
    }
}

