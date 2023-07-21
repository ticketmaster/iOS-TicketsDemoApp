//
//  MainMenuVC+Config.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import TicketmasterAuthentication // for TMAuthentication.shared
import TicketmasterTickets // for TMTickets.shared

extension MainMenuViewController {
    
    func configureBothSDKs() {
        // 1. configure Authentication first
        configureAuthenticationSDK { success in
            if success {
                // 2. then configure Tickets
                self.configureTicketsSDK { success in
                    // 3. present Tickets, Login, etc.
                    // we will now wait for the user to press something in the UI
                }
            }
        }
    }
    
    func configureAuthenticationSDK(completion: @escaping (_ success: Bool) -> Void) {
        guard Configuration.shared.apiKey != "<your apiKey>" else {
            fatalError("Set your apiKey in Configuration.swift")
        }
        
        // set delegates (optional)
        TMAuthentication.shared.delegate = self // be informed about Login state via delegate callbacks:
        
        // note that you can also register for a block to be called on Login state change
        //
        //        TMAuthentication.shared.registerStateChanged { backend, state, error in
        //            if let error = error {
        //                print("\(backend.description): \(state.rawValue): \(error.localizedDescription)")
        //            } else {
        //                print("\(backend.description): \(state.rawValue)")
        //            }
        //        }
        
        // note that you can also listen for notifications on Login state change:
        //
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(loginCompleted),
        //                                               name: TMAuthentication.AuthNotification.loginCompleted,
        //                                               object: nil)
        
        // build a combination of Settings and Branding
        let tmxServiceSettings = TMAuthentication.TMXSettings(apiKey: Configuration.shared.apiKey,
                                                              region: Configuration.shared.region)
        
        let branding = TMAuthentication.Branding(displayName: Configuration.shared.displayName,
                                                 backgroundColor: Configuration.shared.backgroundColor,
                                                 theme: Configuration.shared.textTheme)
        
        let brandedServiceSettings = TMAuthentication.BrandedServiceSettings(tmxSettings: tmxServiceSettings,
                                                                             branding: branding)
        
        // configure TMAuthentication with Settings and Branding
        print("Authentication SDK Configuring...")
        TMAuthentication.shared.configure(brandedServiceSettings: brandedServiceSettings) { backendsConfigured in
            // your API key may contain configurations for multiple backend services
            // the details are not needed for most common use-cases
            print(" - Authentication SDK Configured: \(backendsConfigured.count)")
            completion(true)
            
        } failure: { error in
            // something went wrong, probably the wrong apiKey+region combination
            print(" - Authentication SDK Configuration Error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func configureTicketsSDK(completion: @escaping (_ success: Bool) -> Void) {
        
        // set navBar button (optional)
        TMTickets.shared.navBarButtonTitle = "Help"
        
        // set delegates (optional)
        TMTickets.shared.orderDelegate = self // be informed about Tickets state
        TMTickets.shared.analyticsDelegate = self // be informed about User behavior
        TMTickets.shared.moduleDelegate = self // add prebuilt and customized modules to Tickets screen
        
        // set additional branding?
        // by default, Tickets SDK inherits basic branding from TMAuthentication
        // however Tickets SDK has additional advanced branding that you may optionally use:
        //
        //        let branding = TMTickets.BrandingColors(navBarColor: .red,
        //                                                buttonColor: .orange,
        //                                                textColor: .yellow,
        //                                                ticketColor: .blue,
        //                                                theme: .light)
        //        TMTickets.shared.configure {
        //            // override branding AFTER configure completes (inside configure completion block)
        //            TMTickets.shared.brandingColorsOverride = branding
        //        }
        //
        // You may also override the override. Which is to say:
        //
        //        // do NOT brand nav bar at all
        //        TMTickets.shared.brandingColorNavBarOverride = true
        //
        //        // use default TM branding for TM buttons (Transfer, Sell),
        //        // use the branding you provided for non-TM buttons
        //        TMTickets.shared.brandingColorButtonOverride = true
        
        let brandingOverride: TMTickets.BrandingColors? = nil
//        let brandingOverride = TMTickets.BrandingColors(navBarColor: .red,
//                                                        buttonColor: .orange,
//                                                        textColor: .yellow,
//                                                        ticketColor: .blue,
//                                                        theme: .light)
        // note that there are various backend rules that may override the provided ticketColor for Archtics season tickets
        
        // optional team logo (on Account selection header)
        TMTickets.shared.brandingTeamLogoImage = Configuration.shared.teamLogo
        
        // TMTickets inherits it's configuration from TMAuthentication
        print("Tickets SDK Configuring...")
        TMTickets.shared.configure {
            // Tickets is configured, now we are ready to present TMTicketsViewController or TMTicketsView
            print(" - Tickets SDK Configured")
            // override default branding (if any), nil = use default TMAuthentication branding
            TMTickets.shared.brandingColorsOverride = brandingOverride
            completion(true)
            
        } failure: { error in
            // something went wrong, probably TMAuthentication was not configured correctly
            print(" - Tickets SDK Configuration Error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
