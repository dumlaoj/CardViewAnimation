//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Jordan Dumlao on 1/24/19.
//  Copyright © 2019 Jordan Dumlao. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

	var handleView = UIView()
	var handleBar = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 10))
	var handleViewHeight: CGFloat = 65
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .orange
		renderViews()
		
		
    }
	
	private func renderViews() {
		view.addSubview(handleView)
		handleView.constrain(toLeading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: nil, withPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
		handleView.backgroundColor = .white
		handleView.constrain(withHeight: handleViewHeight)
		
		
		handleView.addSubview(handleBar)
		handleBar.backgroundColor = .darkGray
		handleBar.constrain(withSize: CGSize(width: 60, height: 7))
		handleBar.centerInSuperView()
		
	}
	
}
