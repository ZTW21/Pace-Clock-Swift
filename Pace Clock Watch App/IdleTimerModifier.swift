//
//  IdleTimerModifier.swift
//  Pace Clock Watch App
//
//  Created by Zack Wilson on 1/12/24.
//

import SwiftUI
import UIKit

struct IdleTimerModifier: ViewModifier {
    var disable: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = disable
            }
    }
}

extension View {
    func idleTimerDisabled(_ disable: Bool) -> some View {
        self.modifier(IdleTimerModifier(disable: disable))
    }
}
