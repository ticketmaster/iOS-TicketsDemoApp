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
    
    var addLogoutButton: Bool = false
    
    var addCloseButton: Bool = false
    
    var useSafeBottom: Bool = false
    
    private var logoutButton: UIBarButtonItem?
    private var closeButton: UIBarButtonItem?
    
    private var ticketsView: TMTicketsView?
    
    private var didAttachTicketsView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Events"
        
        // build TMTicketsView
        buildTicketsView()
        
        // build logout button (if navBar present)
        buildButtons()
        
        // update logout button based on current login state
        updateLogoutButton()
        
        // update logout button when login state changes
        registerForLoginStateNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // attach to parent via constraints
        attachTicketsView()
    }
    
    func buildTicketsView() {
        // do not allow multiple instances of ticketsView
        if ticketsView == nil {
            // build a new TMTicketsView
            ticketsView = TMTicketsView(frame: .zero)
            if let tView = ticketsView {
                // tell Tickets SDK to use the provided TMTicketsView
                //  - you do not need to call this method when using TMTicketsViewController
                //  - see MainMenuVC+TableViewDelegate.swift
                //
                // IMPORTANT: Make sure to call this method AFTER or INSIDE TMTickets.shared.configure { ... }
                TMTickets.shared.start(ticketsView: tView)
            }
        }
    }
    
    func attachTicketsView() {
        if let tView = ticketsView {
            if didAttachTicketsView == false {
                didAttachTicketsView = true
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
                let bottomConstraint: NSLayoutConstraint
                if useSafeBottom {
                    // do NOT extend under bottom tab swipe (ie. use safeAreaLayoutGuide)
                    bottomConstraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal,
                                                          toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                } else {
                    // extend under bottom tab swipe (ie. do NOT use safeAreaLayoutGuide)
                    bottomConstraint = NSLayoutConstraint(item: tView, attribute: .bottom, relatedBy: .equal,
                                                          toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                }
                
                // add TMTicketsView contraints to EmbeddedViewController.view
                view.addConstraints([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
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
    
    func buildButtons() {
        if addLogoutButton, logoutButton == nil {
            logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
            navigationItem.rightBarButtonItem = logoutButton
        }
        if addCloseButton, closeButton == nil {
            closeButton =  UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeButtonPressed))
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    @objc func updateLogoutButton() {
        // we can define "logged in" as having an OAuth token
        logoutButton?.isEnabled = TMAuthentication.shared.hasToken()
    }
    
    @objc func logoutButtonPressed(_ sender: Any) {
        TMAuthentication.shared.logout { _ in
            // list of all backends that were logged out
        }
    }
    
    @objc func closeButtonPressed(_ sender: Any) {
        dismissSelf(animated: true) {
            // all done
        }
    }
}
