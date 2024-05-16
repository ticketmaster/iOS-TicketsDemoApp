//
//  MainMenuViewController.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import UIKit
import TicketmasterFoundation
import TicketmasterAuthentication
import TicketmasterSecureEntry
import TicketmasterTickets

class MainMenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"

        printVersions()

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
    
    func printVersions() {
        print("==========================================")
        print("TMFoundation      : v\(TMFoundation.shared.version)")
        print("TMAuthentication  : v\(TMAuthentication.shared.version)")
        //print("TMDiscoveryAPI    : v\(TMDiscoveryAPI.shared.version)")
        //print("TMPrePurchase     : v\(TMPrePurchase.shared.version)")
        //print("TMPurchase        : v\(TMPurchase.shared.version)")
        print("TMTickets         : v\(TMTickets.shared.version)")
        print(" - SecureEntryView: v\(SecureEntryView.version)")
        print("==========================================")
    }
}
