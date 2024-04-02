//
//  MainMenuVC+AuthDelegate.swift
//  TicketsSDKDemoIntegration
//
//  Created by Jonathan Backer on 6/15/23.
//

import Foundation
import TicketmasterAuthentication // for TMAuthenticationDelegate

/// optional delegate to recieve login state change information
extension MainMenuViewController: TMAuthenticationDelegate {
    
    /// login state changed
    ///
    /// - Parameters:
    ///   - backend: ``TMAuthentication/BackendService`` that has changed state, `nil` = non-service specific change
    ///   - state: new ``TMAuthentication/ServiceState``
    ///   - error: error (if any)
    func onStateChanged(backend: TMAuthentication.BackendService?, state: TMAuthentication.ServiceState, error: (Error)?) {
        if let backend = backend {
            if let error = error {
                print("Authentication State: .\(state.rawValue) forBackend: \(backend.description) Error: \(error.localizedDescription)")
            } else {
                print("Authentication State: .\(state.rawValue) forBackend: \(backend.description)")
            }
        } else {
            if let error = error {
                print("Authentication State: .\(state.rawValue) Error: \(error.localizedDescription)")
            } else {
                print("Authentication State: .\(state.rawValue)")
            }
        }
        
        switch state {
        case .serviceConfigurationStarted:
            /// configuration process has started, ``serviceConfigured`` state may be called multiple times
            break
        case .serviceConfigured:
            /// given ``TMAuthentication/BackendService`` has been configured, however configuration is still processing
            break
        case .serviceConfigurationCompleted:
            /// configuration process has completed
            break
            
        case .loginStarted:
            /// login process has started, ``loggedIn`` state may be called multiple times
            break
        case .loginExchanging:
            /// login process is attempting to exchange external token for OAuth token
            break
        case .loginPresented:
            /// user has been presented a login page for the given ``TMAuthentication/BackendService``, so login is still processing
            break
        case .loggedIn:
            /// user has logged in to given ``TMAuthentication/BackendService``, however login is still processing
            break
        case .loginAborted:
            /// user has manually aborted a login, however login is still processing
            break
        case .loginFailed:
            /// login has failed with an error, however login is still processing
            break
        case .loginLinkAccountPresented:
            /// user has been presented link account, so login is still processing
            break
        case .loginCompleted:
            /// login process has completed, including link account process
            break
            
        case .tokenRefreshed:
            /// user's ``TMAuthToken`` has been refreshed, may be called multiple times during lifetime of application
            break
            
        case .logoutStarted:
            /// logout process has started, ``loggedOut`` state may be called multiple times
            break
        case .loggedOut:
            /// user has logged out of given ``TMAuthentication/BackendService``, however logout is still processing
            break
        case .logoutCompleted:
            /// logout process has completed
            break
            
        @unknown default:
            /// additional states may be added in the future
            break
        }
    }
}
