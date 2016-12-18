//
//  DataTabBarControllerViewController.swift
//  sownata
//
//  Created by Gary Joy on 24/04/2016.
//
//

import UIKit

class DataTabBarViewController: UITabBarController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape (Data)")
            performSegue(withIdentifier: "ViewDashboard", sender: nil)
        }
        else if UIDevice.current.orientation.isPortrait {
            print("Portrait (Data)")
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
}
