//
//  MainMenuVC+TableViewDelegate.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import UIKit
import TicketmasterAuthentication // for TMAuthentication.shared
import TicketmasterTickets // for TMTicketsViewController()

extension MainMenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Present Tickets (push)
        if indexPath == IndexPath(row: 0, section: 0) {
            let ticketsVC = TMTicketsViewController()
            navigationController?.pushViewController(ticketsVC, animated: true)
            
        // Present Tickets (modal)
        } else if indexPath == IndexPath(row: 1, section: 0) {
            let ticketsVC = TMTicketsViewController()
            present(ticketsVC, animated: true)
        
        // Push Tickets (embedded)
        } else if indexPath == IndexPath(row: 2, section: 0) {
            let embeddedVC = EmbeddedViewController()
            embeddedVC.addLogoutButton = true
            navigationController?.pushViewController(embeddedVC, animated: true)
            
        // Present Tickets (embedded)
        } else if indexPath == IndexPath(row: 3, section: 0) {
            let embeddedVC = EmbeddedViewController()
            present(embeddedVC, animated: true)
            
        // Login
        } else if indexPath == IndexPath(row: 0, section: 1) {
            // Tickets SDK handles login for you, so this call is optional
            TMAuthentication.shared.login { authToken in
                print("Login Completed")
                print(" - AuthToken: \(authToken.accessToken.prefix(20))...")
            } aborted: { oldAuthToken, backend in
                print("Login Aborted by User")
            } failure: { oldAuthToken, error, backend in
                print("Login Error: \(error.localizedDescription)")
            }
            
        // Member Info
        } else if indexPath == IndexPath(row: 1, section: 1) {
            // Tickets SDK handles login for you, so this call is optional
            TMAuthentication.shared.memberInfo { memberInfo in
                print("MemberInfo Completed")
                print(" - UserID: \(memberInfo.localID ?? "<nil>")")
                print(" - Email: \(memberInfo.email ?? "<nil>")")
            } failure: { oldMemberInfo, error, backend in
                print("MemberInfo Error: \(error.localizedDescription)")
            }

        // Logout
        } else if indexPath == IndexPath(row: 2, section: 1) {
            // TMTicketsViewController has it's own logout button, so this call is optional
            // unless you add your own logout button somewhere
            TMAuthentication.shared.logout { backends in
                print("Logout Completed")
                print(" - Backends Count: \(backends?.count ?? 0)")
            }
        }
    }
}
