//
//  CommonUICollors:Views.swift
//  MoviesApp
//
//  Created by Саша Василенко on 30.10.2022.
//

import UIKit
import Lottie

struct CommonUICollorsAndViews {
    static func getbasicBlurEffect() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return blurView
    }
    
    static func getLottieBackground() -> LottieAnimationView {
        let animationView: LottieAnimationView = .init(name: "434-gradient-animated-background")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
        return animationView
    }
}
