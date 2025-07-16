//
//  MainMenuVC+CustomModules.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 2/25/25.
//

import Foundation
import MapKit // for MKCoordinateRegion and CLLocationCoordinate2D
import TicketmasterTickets // for TMPurchasedEvent, TMTicketsModuleHeaderView and TMTicketsModule

// MARK: - Build Some Example Custom Modules

extension MainMenuViewController {
        
    func buildCustomModules(event: TMPurchasedEvent, completion: @escaping (_ customModules: [TMTicketsModule]) -> Void) {
        print(" - Adding Custom Modules")
        var output: [TMTicketsModule] = []
        
        // build a generic module
        // Tickets SDK does not know how to handle a "generic" action,
        //  so handleModuleActionButton() will be called
        if let module = genericModule(event: event) {
            output.append(module)
        }
        
        // build a custom rideshare module
        // Ticket SDK is not sure exactly how you want to handle a "rideshare",
        //  so Tickets will call back into handleModuleActionButton()
        if let module = parkingModule(event: event) {
            output.append(module)
        }
        
        // build a custom venue parking module
        // Ticket SDK is not sure exactly how you want to handle a "rideshare",
        //  so Tickets will call back into handleModuleActionButton()
        if let module = rideshareModule(event: event) {
            output.append(module)
        }
        
        // build a custom rideshare module
        // Tickets SDK knows how to handle opening a webpage,
        //  so handleModuleActionButton() will not be called
        if let module = seatingChartModule(event: event) {
            output.append(module)
        }
        
        // build a custom seating chart module
        // Tickets SDK knows how to handle opening a webpage,
        //  so handleModuleActionButton() will not be called
        if let module = venueInfoModule(event: event) {
            output.append(module)
        }
        
        // build a custom venue merch voucher module
        // Tickets SDK knows how to handle opening a webpage,
        //  so handleModuleActionButton() will not be called
        if let module = venueVoucherModule(event: event) {
            output.append(module)
        }
        
        // build a custom merch shop module
        // Tickets SDK knows how to handle opening a webpage,
        //  so handleModuleActionButton() will not be called
        if let module = merchShopModule(event: event) {
            output.append(module)
        }

        // use an async completion in case any of these custom modules need to make a network request
        completion(output)
    }
    
    func genericModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // build any UIView here:
        let headerView = UIView()
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 200)) // set height
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = . red
        
        // build header display
        // any UIView will work here for headerView
        let headerDisplay = TMTicketsModule.HeaderDisplay(view: headerView)

        // build generic action button
        let genericButton = TMTicketsModule.ActionButton(title: "Time for Action!",
                                                         callbackValue: "genericAction")
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.genericModule", // a name unique to your app
                               headerDisplay: headerDisplay,
                               actionButtons: [genericButton]) // you can show 0-3 buttons
    }
    
    func parkingModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // unfortunately the event object doesn't have info about particular parking lots
        // so we'll have to code the values manually
        
        // define map region and zoom (span)
        let mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.0734, longitude: -118.2402),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

        // define map point of interest
        let mapAnnotation = TMTicketsModuleHeaderView.MapAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 34.0735, longitude: -118.2456),
            title: "Lot 1")

        // build a UIView with a text, gradient, and image
        let headerView = TMTicketsModuleHeaderView.build()
        headerView.configure(topLabelText: "Parking: Lot 1",
                             mapCoordinateRegion: mapRegion,
                             mapAnnotation: mapAnnotation)

        // build header with HeaderView (a UIView)
        let header = TMTicketsModule.HeaderDisplay(view: headerView)

        // build buttons
        let button1 = TMTicketsModule.ActionButton(title: "Parking Directions")

        // build module with header and buttons
        return TMTicketsModule(identifier: "com.myDemoApp.parking",
                                     headerDisplay: header,
                                     actionButtons: [button1])
    }
 
    func rideshareModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // only allow rideshare to specific venues?
        //guard event.info.venue?.identifier == "123456" else { return nil }
        
        // build action button that call back into this class
        let rideshareActionButton = TMTicketsModule.ActionButton(
            title: "Rideshare", // what user will see, you should localize this text
            callbackValue: "rideShare") // what code will return in handleModuleActionButton(), unlocalized
        
        // Tickets SDK has no idea which "rideshare" you could mean, so handleModuleActionButton() will be called
        
        // build action button that opens a webpage
        let parkingWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Parking",
            urlRequest: URLRequest(url: URL(string: "https://www.ballarena.com/plan-your-visit/parking-directions/")!))
        let parkingActionButton = TMTicketsModule.ActionButton(
            title: "Parking",
            webpageSettings: parkingWebpageSettings)
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.rideshare", // a name unique to your app
                               headerDisplay: nil, // this module has buttons only (no header)
                               actionButtons: [rideshareActionButton, parkingActionButton]) // you can show 0 to 3 buttons
    }
    
    func seatingChartModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // build action button that opens a webpage
        let seatingChartWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Seating Chart",
            urlRequest: URLRequest(url: URL(string: "https://www.ballarena.com/media/1109/hockey_pc-master-map-c_2018_r1.png")!))
        let seatingChartActionButton = TMTicketsModule.ActionButton(
            title: "Seating Chart", // what user will see, you should localize this text
            webpageSettings: seatingChartWebpageSettings)
        
        // Tickets SDK knows how to open a webpage, so handleModuleActionButton() will not be called
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.seatingChart", // a name unique to your app
                               headerDisplay: nil, // this module has buttons only (no header)
                               actionButtons: [seatingChartActionButton]) // you can show 0 to 3 buttons
    }
    
    func venueInfoModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // backgroundImage can be any size, but it will be aspectFilled to 24x15 (recommended: 480x300)
        let backgroundImage = UIImage(imageLiteralResourceName: "VenueInfo")
        
        // build any UIView here:
        //  actually, we have a handy method to build module UI easily, this includes:
        //   * text
        //   * images
        //   * maps
        //   * QR codes
        //   * 2D barcodes
        //   * videos
        let headerView = TMTicketsModuleHeaderView.build()
        headerView.configure(backgroundImage: backgroundImage)
        
        // build header display
        // any UIView will work here for headerView
        let headerDisplay = TMTicketsModule.HeaderDisplay(view: headerView as UIView)
        
        // build action buttons that open a webpage
        let venueInfoWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Venue Info",
            urlRequest: URLRequest(url: URL(string: "https://www.ballarena.com/arena-policies-faq")!))
        let venueInfoActionButton = TMTicketsModule.ActionButton(
            title: "Venue Info", // what user will see, you should localize this text
            callbackValue: "venueInfo", // non-localized value, for your own code/analytics
            webpageSettings: venueInfoWebpageSettings)
        
        let venue360WebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "360 View",
            urlRequest: URLRequest(url: URL(string: "https://avalanche.io-media.com/web/index.html")!))
        let venue360ActionButton = TMTicketsModule.ActionButton(
            title: "360 View", // what user will see, you should localize this text
            webpageSettings: venue360WebpageSettings)
        
        // Tickets SDK knows how to open a webpage, so handleModuleActionButton() will not be called
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.venueInfo", // a name unique to your app
                               headerDisplay: headerDisplay,
                               actionButtons: [venueInfoActionButton, venue360ActionButton]) // you can show 0 to 3 buttons
    }
    
    func venueVoucherModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // let's build a Venue Voucher module
        
        // show a QR code for $22.00 of merch at the venue
        let voucherCode = "12345MyCoolCode67890"
        let voucherAmount = "$22.00"
        
        // backgroundImage can be any size, but it will be aspectFilled to 24x15 (recommended: 480x300)
        let backgroundImage = UIImage(imageLiteralResourceName: "Breckenridge")
        
        // build any UIView here:
        //  actually, we have a handy method to build module UI easily, this includes:
        //   * text
        //   * images
        //   * maps
        //   * QR codes
        //   * 2D barcodes
        //   * videos
        let headerView = TMTicketsModuleHeaderView.build()
        headerView.configure(topLabelText: "Breckenridge Brewery Voucher",
                             topLabelTextAlignment: .center,
                             bottomLabelText: "Balance: \(voucherAmount)",
                             bottomLabelTextAlignment: .center,
                             gradientAlpha: 1.0,
                             backgroundImage: backgroundImage,
                             qrCodeValue: voucherCode)
        
        // build header display
        // any UIView will work here for headerView
        let headerDisplay = TMTicketsModule.HeaderDisplay(view: headerView as UIView)
        
        // show a button under the QR code
        let concessionsInfoWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Concessions Info",
            urlRequest: URLRequest(url: URL(string: "https://www.ballarena.com/food-drink/concessions/")!))
        let concessionsInfoActionButton = TMTicketsModule.ActionButton(
            title: "How to Use Vouchers", // what user will see, you should localize this text
            webpageSettings: concessionsInfoWebpageSettings)
        
        // Tickets SDK knows how to open a webpage, so handleModuleActionButton() will not be called
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.venueVoucher", // a name unique to your app
                               headerDisplay: headerDisplay,
                               actionButtons: [concessionsInfoActionButton]) // you can show 0 to 3 buttons
    }
    
    func merchShopModule(event: TMPurchasedEvent) -> TMTicketsModule? {
        // backgroundImage can be any size, but it will be aspectFilled to 24x15 (recommended: 480x300)
        let backgroundImage = UIImage(imageLiteralResourceName: "Merch")
        
        // build any UIView here:
        //  actually, we have a handy method to build module UI easily, this includes:
        //   * text
        //   * images
        //   * maps
        //   * QR codes
        //   * 2D barcodes
        //   * videos
        let headerView = TMTicketsModuleHeaderView.build()
        headerView.configure(backgroundImage: backgroundImage)
        
        // build header display
        // any UIView will work here for headerView
        let headerDisplay = TMTicketsModule.HeaderDisplay(view: headerView as UIView)
        
        // build action button that opens a webpage
        let fanCollectionWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Fan Collection",
            urlRequest: URLRequest(url: URL(string: "https://www.prochamp.jostens.com/catalogBrowse/3173533/Colorado-Avalanche-Fan/20220914162001593142")!))
        let fanCollectionActionButton = TMTicketsModule.ActionButton(
            title: "Fan Collection", // what user will see, you should localize this text
            webpageSettings: fanCollectionWebpageSettings)
        
        // you can have Tickets SDK automatically write a cookie into the webpage
        // this is most commonly used for transferring the user's login state to the webpage
        let cookieSettings = TMTicketsModule.OAuthCookieSettings(name: "cookieName",
                                                                 value: "merchOAuthToken",
                                                                 webDomains: [".fanatics.com"])
        // most other state info is typically transferred via URL parameters below
        
        // build action button that opens a webpage
        let merchShopWebpageSettings = TMTicketsModule.WebpageSettings(
            pageTitle: "Shopping",
            urlRequest: URLRequest(url: URL(string: "https://www.fanatics.com/nhl/colorado-avalanche/o-2428+t-47710691+z-91289-1682938200")!),
            oauthCookieSettings: cookieSettings)
        let merchShopActionButton = TMTicketsModule.ActionButton(
            title: "Shopping", // what user will see, you should localize this text
            webpageSettings: merchShopWebpageSettings)
        
        // modules can have:
        // 1. header only (no buttons)
        // 2. buttons only (no header)
        // 3. both header and buttons
        
        // build module
        return TMTicketsModule(identifier: "com.myDemoApp.merchShop", // a name unique to your app
                               headerDisplay: headerDisplay,
                               actionButtons: [fanCollectionActionButton, merchShopActionButton]) // you can show 0
    }
}
