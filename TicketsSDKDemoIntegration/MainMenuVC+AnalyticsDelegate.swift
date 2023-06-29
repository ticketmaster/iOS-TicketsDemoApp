//
//  MainMenuVC+AnalyticsDelegate.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import TicketmasterTickets // for TMTicketsAnalyticsDelegate

/// optional delegate to be informed of User behavior
extension MainMenuViewController: TMTicketsAnalyticsDelegate {
    
    /// user did view a page
    ///
    /// - Parameters:
    ///  - page: ``TMTickets/Analytics/Page`` (UI screen) being viewed by User
    ///  - metadata: any Event or Ticket ``TMTickets/Analytics/MetadataType`` associated with page
    func userDidView(page: TMTickets.Analytics.Page, metadata: TMTickets.Analytics.MetadataType) {
        print("userDidViewPage: \(page.rawValue)")

        // different Pages return different types of metadata
        switch metadata {
        case .events(let events):
            print(" - events: \(events.count)")
        case .event(let event):
            print(" - event: \(event.info.identifier)")
        case .eventTickets(let event, let tickets):
            print(" - event: \(event.info.identifier) tickets: \(tickets.count)")
        case .eventTicket(event: let event, let ticket):
            let ticketSummary = "\(ticket.sectionName ?? "_") \(ticket.rowName ?? "_") \(ticket.seatName ?? "_")"
            print(" - event: \(event.info.identifier) ticket: \(ticketSummary)")
        case .module(let event, let identifier):
            print(" - module: \(identifier) event: \(event.info.identifier)")
        case .moduleButton(let event, let module, let button):
            print(" - module: \(module.identifier) button: \(button.title)(\(button.callbackValue) event: \(event.info.identifier)")
        case .empty:
            print(" - empty")
        @unknown default:
            print(" - empty")
        }
    }
    
    /// user did perform an action
    ///
    /// - Parameters:
    ///  - action: ``TMTickets/Analytics/Action`` (button press) performed by User
    ///  - metadata: any Event or Ticket ``TMTickets/Analytics/MetadataType`` associated with action
    func userDidPerform(action: TMTickets.Analytics.Action, metadata: TMTickets.Analytics.MetadataType) {
        print("userDidPerformAction: \(action.rawValue)")
        
        // different Actions return different types of metadata
        switch metadata {
        case .events(let events):
            print(" - events: \(events.count)")
        case .event(let event):
            print(" - event: \(event.info.identifier)")
        case .eventTickets(let event, let tickets):
            print(" - event: \(event.info.identifier) tickets: \(tickets.count)")
        case .eventTicket(event: let event, let ticket):
            let ticketSummary = "\(ticket.sectionName ?? "_") \(ticket.rowName ?? "_") \(ticket.seatName ?? "_")"
            print(" - event: \(event.info.identifier) ticket: \(ticketSummary)")
        case .module(let event, let identifier):
            print(" - module: \(identifier) event: \(event.info.identifier)")
        case .moduleButton(let event, let module, let button):
            print(" - module: \(module.identifier) button: \(button.title)(\(button.callbackValue) event: \(event.info.identifier)")
        case .empty:
            print(" - empty")
        @unknown default:
            print(" - empty")
        }
    }
}
