//
//  ViewController.swift
//  CardViewAnimation
//
//  Created by Jordan Dumlao on 1/24/19.
//  Copyright © 2019 Jordan Dumlao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var cardViewController = CardViewController()
	
	enum CardState {
		case expanded
		case collapsed
	}
	
	var visualEffectView = UIVisualEffectView(effect: nil)
	
	var cardVisible = false
	var nextState: CardState {
		return cardVisible ? .collapsed : .expanded
	}
	
	var runningAnimations = [UIViewPropertyAnimator]()
	var animationProgressWhenInterrupted: CGFloat = 0
	let cardViewHeight: CGFloat = 600
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(visualEffectView)
		visualEffectView.fillSuperview()
		view.backgroundColor = .lightGray
		configureCardView()
		
	}
	
	
	private func configureCardView() {
		cardViewController = CardViewController()
		cardViewController.view.frame = CGRect(x: 0, y: (view.frame.height - cardViewController.handleViewHeight) - 50, width: view.frame.width, height: cardViewHeight)
		addChild(cardViewController)
		view.addSubview(cardViewController.view)
		cardViewController.didMove(toParent: self)
		cardViewController.view.clipsToBounds = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		cardViewController.handleView.addGestureRecognizer(tap)
		cardViewController.handleView.addGestureRecognizer(pan)
	}
	
	@objc func handleTap(_ recognizer: UITapGestureRecognizer) {
		
	}
	
	@objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			startInteractiveTransition(state: nextState, duration: 0.0)
		case .changed:
			let translation = recognizer.translation(in: cardViewController.handleView)
			var fractionComplete = translation.y / cardViewHeight
			fractionComplete = cardVisible ? fractionComplete : -fractionComplete
			updateInteractiveTransition(fractionCompleted: fractionComplete)
		case .ended:
			continueInteractiveTransition()
		default: break
		}
	}
	
	private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
				switch state {
				case .expanded:
					self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardViewHeight
				case .collapsed:
					self.cardViewController.view.frame.origin.y = (self.view.frame.height - self.cardViewController.handleViewHeight) - 50
				}
			})
			frameAnimator.addCompletion { _ in
				self.cardVisible.toggle()
				self.runningAnimations.removeAll()
			}
			frameAnimator.startAnimation()
			runningAnimations.append(frameAnimator)
			
			let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear, animations: {
				self.cardViewController.view.layer.cornerRadius = self.nextState == .expanded ? 10.0 : 0
				
			})
			cornerRadiusAnimator.startAnimation()
			runningAnimations.append(cornerRadiusAnimator)
			
			let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0, animations: {
				switch self.nextState {
				case .expanded:
					self.visualEffectView.effect = UIBlurEffect(style: .dark)
				case .collapsed:
					self.visualEffectView.effect = nil
				}
			})
			
			blurAnimator.startAnimation()
			runningAnimations.append(blurAnimator)
			
			
			
		}
	}
	
	private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			//RUN ANIMATIONS
			animateTransitionIfNeeded(state: state, duration: duration)
		}
		
		for animator in runningAnimations {
			animator.pauseAnimation()
			animationProgressWhenInterrupted = animator.fractionComplete
		}
	}
	
	private func updateInteractiveTransition(fractionCompleted: CGFloat) {
		runningAnimations.forEach { $0.fractionComplete = fractionCompleted + animationProgressWhenInterrupted }
	}
	
	private func continueInteractiveTransition() {
		runningAnimations.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)}
	}


}

