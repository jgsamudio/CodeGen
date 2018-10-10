//
//  WorkoutContainerViewController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Container for `WorkoutViewController` and `WorkoutLoaderViewController`
/// Both of these view controllers are in this view hierarchy. Whenever workout API results informs this view controller
/// that the results have loaded, this view controller will animate loader view controller away.
final class WorkoutContainerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private weak var loaderVC = WorkoutLoaderBuilder().build()
    
    // MARK: - Public Properties
    
    lazy var workoutNavVC: UINavigationController = {
        let vc = WorkoutsBuilder().build()
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }()

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        addViewController(workoutNavVC)
        displayLoaderVC()
    }

    /// Displays the loader VC when required
    func displayLoaderVC() {
        let loader = WorkoutLoaderBuilder().build()
        loaderVC = loader
        addViewController(loader)
        setLoaderHeaderHeight()
    }

    /// Calculates the height of the headers (navigation bar + shrinkableTopView)
    /// on the Workouts screen and sets it on the Workouts Loader screen to allow
    /// content to appear pushed down from the top of the view controller.
    private func setLoaderHeaderHeight() {
        let headerHeight = WorkoutLoaderViewController.shrinkableTopViewHeight +
            workoutNavVC.navigationBar.bounds.height
        if let workoutsLoaderViewController = loaderVC as? WorkoutLoaderViewController {
            workoutsLoaderViewController.headerHeight = headerHeight
        }
    }
    
    /// Displays workouts view controller and removes loader view controller
    func displayWorkouts() {
        if loaderVC?.view.alpha != 0 {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in

                self?.loaderVC?.view.alpha = 0
                }, completion: { [weak self] _ in
                    self?.loaderVC?.view.removeFromSuperview()
                    self?.loaderVC?.removeFromParentViewController()
                    self?.loaderVC?.didMove(toParentViewController: nil)
            })
        }
    }
    
    private func addViewController(_ toVC: UIViewController) {
        addChildViewController(toVC)
        toVC.view.frame = view.bounds
        view.addSubview(toVC.view)
        toVC.view.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)
        toVC.didMove(toParentViewController: self)
    }

}

// MARK: - TabBarTappable
extension WorkoutContainerViewController: TabBarTappable {

    func handleTabBarTap() {
        (workoutNavVC.visibleViewController as? TabBarTappable)?.handleTabBarTap()
    }

}
