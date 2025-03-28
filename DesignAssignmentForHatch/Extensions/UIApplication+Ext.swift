//
//  UIApplication+Ext.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import Foundation
import SwiftUI

extension UIApplication {
    var statusBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
