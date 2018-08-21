//
//  BottomSheetPresentationController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/21/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class BottomSheetPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private var height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting, height: height)
    }
    
}

class CustomHeightPresentationController: UIPresentationController {
    
    private var height: CGFloat
    private var dimmView: UIView
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.height = height
        dimmView = UIView()
        dimmView.translatesAutoresizingMaskIntoConstraints = false
        dimmView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmView.alpha = 0.0
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTab(recognizer:)))
        dimmView.addGestureRecognizer(gesture)
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let size = containerView?.bounds else {
            fatalError()
        }
        return CGRect(x: 0.0, y: size.height - height, width: size.width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmView]|",
                                           options: [], metrics: nil, views: ["dimmView": dimmView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmView]|",
                                           options: [], metrics: nil, views: ["dimmView": dimmView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmView.alpha = 0.0
        })
    }
    
    @objc private func handleTab(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
}
