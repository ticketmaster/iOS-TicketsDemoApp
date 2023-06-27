//
//  MainMenuViewController.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import UIKit

class MainMenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"

        configureBothSDKs()

        configureNavBarBranding()
    }
}



private extension MainMenuViewController {
    
    func configureNavBarBranding() {
        // make the demo integration app header color match the branding color
        // iOS 13+ navigationBar color
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = Configuration.shared.backgroundColor
        switch Configuration.shared.textTheme {
        case .light:
            barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        case .dark:
            barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        navigationController?.navigationBar.tintColor = .white
    }
}
