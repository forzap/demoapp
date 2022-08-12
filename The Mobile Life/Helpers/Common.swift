//
//  Common.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import Foundation
import UIKit

// Dimensions
let kTopInset: CGFloat = UIApplication.shared.mainKeyWindow?.safeAreaInsets.top ?? (UIApplication.shared.mainKeyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)

extension UIApplication {
    
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
    }
}
