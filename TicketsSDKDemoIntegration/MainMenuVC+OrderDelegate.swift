//
//  MainMenuVC+OrderDelegate.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import TicketmasterAuthentication // for TMAuthentication.BackendService
import TicketmasterTickets // for TMTicketsOrderDelegate

/// optional delegate to be informed of non-analytics User-actions
extension MainMenuViewController: TMTicketsOrderDelegate {
    
    /// Method is invoked if the client app needs to display some specific page
    /// - parameter deeplink: Identifier of the client app native page to be launched.
    func presentClientAppPage(deeplink: String) {
        // TODO: open deeplink (if supported), otherwise ignore
        print("presentClientAppPage deeplink: \(deeplink)")
    }
    
    /// Method is invoked if the client app needs to handle the navBar button
    ///
    /// - Parameters:
    ///   - page: PSDK page where button was pressed
    ///   - screenTitleName: title of screen where button was pressed
    ///   - event: current Event and purchased Orders being viewed (if any)
    func handleNavBarButtonAction(page: TicketmasterTickets.TMTickets.Analytics.Page, screenTitleName: String?, event: TicketmasterTickets.TMPurchasedEvent?) {
        if let event = event {
            if let name = screenTitleName {
                print("User Pressed NavBar Button on Page: \(page.rawValue) Named: \(name) Event: \(event.info.identifier)")
            } else {
                print("User Pressed NavBar Button on Page: \(page.rawValue) Event: \(event.info.identifier)")
            }
        } else if let name = screenTitleName {
            print("User Pressed NavBar Button on Page: \(page.rawValue) Named: \(name)")
        } else {
            print("User Pressed NavBar Button on Page: \(page.rawValue)")
        }
    }
    
    /// Method is invoked when the list of event change for a particular event ID
    /// - parameter events: array of current Events being viewed, will NOT contain Order or Ticket data
    /// - parameter fromCache: true = local cached data, false = fresh data from network
    func didUpdateEvents(events: [TicketmasterTickets.TMPurchasedEvent], fromCache: Bool) {
        // list of user's purchased Events were updated
        print("Events Updated: \(events.count) Cached: \(fromCache ? "true" : "false")")
    }
    
    /// Method is invoked when the list of tickets change for a particular event ID
    /// - parameter event: current Event and purchased Orders being viewed, contains Order and Ticket data
    /// - parameter fromCache: true = local cached data, false = fresh data from network
    func didUpdateTickets(event: TicketmasterTickets.TMPurchasedEvent, fromCache: Bool) {
        // Tickets for a specific Event were updated
        print("Event Updated with Tickets: \(event.info.identifier) Cached: \(fromCache ? "true" : "false")")
    }
    
    /// Method is invoked when the list of events and tickets are cleared, usually due to user logout
    /// - parameter backend: backend service cleared
    func didClearEventsTicketsCache(backend: TMAuthentication.BackendService) {
        print("Events Removed for Backend: \(backend.description)")
    }
}
