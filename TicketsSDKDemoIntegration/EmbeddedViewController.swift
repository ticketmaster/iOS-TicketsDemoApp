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

    @IBOutlet weak var ticketsView: TMTicketsView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Events"
                
        // update logout button based on current login state
        updateLogoutButton()
        
        // update logout button when login state changes
        registerForLoginStateNotifications()

        // start the Tickets SDK with the provided view
        TMTickets.shared.start(ticketsView: ticketsView)
    }
    
    func registerForLoginStateNotifications() {
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
        logoutButton.isEnabled = TMAuthentication.shared.hasToken()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        TMAuthentication.shared.logout { _ in
            // list of all backends that were logged out
        }
    }
}
