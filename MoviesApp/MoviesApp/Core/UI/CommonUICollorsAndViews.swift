//
//  CommonUICollors:Views.swift
//  MoviesApp
//
//  Created by Саша Василенко on 30.10.2022.
//

import UIKit

struct CommonUICollorsAndViews {
    static func getbasicBlurEffect() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return blurView
    }
}
