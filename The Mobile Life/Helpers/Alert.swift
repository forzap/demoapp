//
//  Alert.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//
import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
