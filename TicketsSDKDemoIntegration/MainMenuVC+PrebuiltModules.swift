//
//  MainMenuVC+PrebuiltModules.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 2/25/25.
//

import Foundation
import TicketmasterTickets // for TMPurchasedEvent, TMTicketsPrebuiltModule and TMTicketsModule

// MARK: - Add PreBuilt Modules

extension MainMenuViewController {
    
    func buildPreBuiltModules(event: TMPurchasedEvent, completion: @escaping (_ prebuiltModules: [TMTicketsModule]) -> Void) {
        print(" - Adding Prebuilt Modules")
        var output: [TMTicketsModule] = []
        
        // show an Account Manager More Ticket Actions module
        // note that this module will only render if Event is an Account Manager Event, otherwise it will not be displayed
        // this is a standard "prebuilt" module that we provide to all our partners
        if let module = TMTicketsPrebuiltModule.accountManagerMoreTicketActions(event: event) {
            output.append(module)
        }
        
        // show a street-map around the Venue with a Directions button that opens Apple Maps
        // this is a standard "prebuilt" module that we provide to all our partners
        if let module = TMTicketsPrebuiltModule.venueDirections(event: event) {
            output.append(module)
        }
        
        // show an Account Manager Seat Upgrades module
        // note that this module will only render if Event is an Account Manager Event, otherwise it will not be displayed
        // this is a standard "prebuilt" module that we provide to all our partners
        #if CUSTOMIZE_PREBUILT_MODULES
        // you can optionally replace the image and text of prebuilt modules using TMTicketsPrebuiltModule.HeaderOverride
        // note that some modules do not have a header (only a button), and do not accept an override value
        let headerOverride1 = TMTicketsPrebuiltModule.HeaderOverride(
            topLabelText: "Get Great Seats!", topLabelTextAlignment: .left,
            gradientAlpha: 1.0, // darken edges of image to make text easier to read
            backgroundImage: .daytonaSeats)
        if let module = TMTicketsPrebuiltModule.accountManagerSeatUpgrades(event: event, headerOverride: headerOverride1) {
            output.append(module)
        }
        #else
        if let module = TMTicketsPrebuiltModule.accountManagerSeatUpgrades(event: event) {
            output.append(module)
        }
        #endif
        
        // show a Venue Concessions module
        // this is a standard "prebuilt" module that we provide to all our partners
        #if CUSTOMIZE_PREBUILT_MODULES
        // you can optionally replace the image and text of prebuilt modules using TMTicketsPrebuiltModule.HeaderOverride
        // note that some modules do not have a header (only a button), and do not accept an override value
        let headerOverride2 = TMTicketsPrebuiltModule.HeaderOverride(
            bottomLabelText: "Bring the Lobby to you!", // note that top text is unchanged
            gradientAlpha: 1.0, // darken edges of image to make text easier to read
            backgroundImage: .lobby)
        if let module = TMTicketsPrebuiltModule.venueConcessions(event: event, headerOverride: headerOverride2, showWalletButton: true) {
            output.append(module)
        }
        #else
        if let module = TMTicketsPrebuiltModule.venueConcessions(event: event, showWalletButton: true) {
            output.append(module)
        }
        #endif

        // use an async completion in case any of these prebuilt modules need to make a network request
        completion(output)
    }
}
