//
//  EmbeddedViewController.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import UIKit
import TicketmasterAuthentication // for TMAuthentication.AuthNotification
import TicketmasterTickets // for TMTickets.shared and TMTicketsView

/// it is recommended to use a `TMTicketsViewController` instead of `TMTicketsView`
///
/// this example is provided as an alternative way to embed Tickets SDK in your application's UI
class EmbeddedViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    var ticketsView: TMTicketsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Events"
        
        // build TMTicketsView, attach to parent via constraints
        buildAndAttachTicketsView()
        
        // update logout button based on current login state
        updateLogoutButton()
        
        // update logout button when login state changes
        registerForLoginStateNotifications()
    }
    
    func buildAndAttachTicketsView() {
        // do not allow multiple instances of ticketsView
        if ticketsView == nil {
            // build a new TMTicketsView
            ticketsView = TMTicketsView(frame: .zero)
            if let tView = ticketsView {
                // always set this when using constraints
                tView.translatesAutoresizingMaskIntoConstraints = false
                
                // add TMTicketsView to EmbeddedViewController.view
                view.addSubview(tView)

                // do NOT extend under nav bar (ie. use safeAreaLayoutGuide)
                let topConstraint = NSLayoutConstraint(item: tView, attribute: .top, relatedBy: .equal,
                                                       toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
                let leftConstraint = NSLayoutConstraint(item: tView, attribute: .left, relatedBy: .equal,
                                                        toItem: view.safeAreaLayoutGuide, attribute: .left, multiplier: 1.0, constant: 0.0)
                let rightConstraint = NSLayoutConstraint(item: tView, attribute: .right, relatedBy: .equal,
                                                         toItem: view.safeAreaLayoutGuide, attribute: .right, multiplier: 1.0, constant: 0.0)
                // extend under bottom tab swipe (ie. do NOT use safeAreaLayoutGuide)
                let bottomConstraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal,
                                                          toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                
                // add TMTicketsView contraints to EmbeddedViewController.view
                view.addConstraints([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
                
                // tell Tickets SDK to use the provided TMTicketsView
                //  - you do not need to call this method when using TMTicketsViewController
                //  - see MainMenuVC+TableViewDleegate.swift
                TMTickets.shared.start(ticketsView: tView)
            }
        }
    }
    
    func registerForLoginStateNotifications() {
        // we want to update the logout button when login or logout is completed
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLogoutButton),
                                               name: TMAuthentication.AuthNotification.loginCompleted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLogoutButton),
                                               name: TMAuthentication.AuthNotification.logoutCompleted,
                                               object: nil)
    }
    
    @objc func updateLogoutButton() {
        // we can define "logged in" as having an OAuth token
        logoutButton.isEnabled = TMAuthentication.shared.hasToken()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        TMAuthentication.shared.logout { _ in
            // list of all backends that were logged out
        }
    }
}
