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

    private enum MenuItem {
        case ticketsPush
        case ticketsModal
        case ticketsEmbeddedPush
        case ticketsEmbeddedModal
        case login
        case memberInfo
        case logout

        init?(indexPath: IndexPath) {
            switch (indexPath.section, indexPath.row) {
            case (0, 0): self = .ticketsPush
            case (0, 1): self = .ticketsModal
            case (0, 2): self = .ticketsEmbeddedPush
            case (0, 3): self = .ticketsEmbeddedModal
            case (1, 0): self = .login
            case (1, 1): self = .memberInfo
            case (1, 2): self = .logout
            default: return nil
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let menuItem = MenuItem(indexPath: indexPath) else { return }

        switch menuItem {
        // Present Tickets (push)
        case .ticketsPush:
            let ticketsVC = TMTicketsViewController()
            navigationController?.pushViewController(ticketsVC, animated: true)

        // Present Tickets (modal)
        case .ticketsModal:
            let ticketsVC = TMTicketsViewController()
            present(ticketsVC, animated: true)

        // Push Tickets (embedded)
        case .ticketsEmbeddedPush:
            let embeddedVC = EmbeddedViewController()
            embeddedVC.configuration.addLogoutButton = true
            navigationController?.pushViewController(embeddedVC, animated: true)

        // Present Tickets (embedded)
        case .ticketsEmbeddedModal:
            let embeddedVC = EmbeddedViewController()
            present(embeddedVC, animated: true)

        // Login
        case .login:
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
        case .memberInfo:
            // Tickets SDK handles login for you, so this call is optional
            TMAuthentication.shared.memberInfo { memberInfo in
                print("MemberInfo Completed")
                print(" - UserID: \(memberInfo.localID ?? "<nil>")")
                print(" - Email: \(memberInfo.email ?? "<nil>")")
            } failure: { oldMemberInfo, error, backend in
                print("MemberInfo Error: \(error.localizedDescription)")
            }

        // Logout
        case .logout:
            // TMTicketsViewController has it's own logout button, so this call is optional
            // unless you add your own logout button somewhere
            TMAuthentication.shared.logout { backends in
                print("Logout Completed")
                print(" - Backends Count: \(backends?.count ?? 0)")
            }
        }
    }
}
