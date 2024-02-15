//
//  Configuration.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import UIKit
import TicketmasterAuthentication

class Configuration: NSObject {
    
    static let shared = Configuration()
    
    /// get your own API key from developer.ticketmaster.com
    let apiKey: String = "<your apiKey>"
    
    /// UK, IE, Microflex and Sport XR should use .UK, all others should use .US
    let region: TMAuthentication.TMXDeploymentRegion = .US
    
    /// name of your App/Team/Artist/Venue
    let displayName: String = "Your Team"
    
    /// main branding color (optional)
    let backgroundColor: UIColor = UIColor(red: 35/255.0, green: 97/255.0, blue: 146/255.0, alpha: 1.0)
    
    /// other text should be light (white) or dark (black)
    let textTheme: TMAuthentication.ColorTheme = .light
    
    let teamLogo: UIImage? = UIImage(imageLiteralResourceName: "TeamLogo")
    
}
