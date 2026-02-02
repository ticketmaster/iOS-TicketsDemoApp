//
//  TicketsView.swift
//  TicketsSDKDemoIntegration
//
//  SwiftUI wrapper for TMTicketsViewController
//

import SwiftUI
import TicketmasterTickets

/// SwiftUI wrapper for TMTicketsViewController
///
/// Usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         TicketsView()
///     }
/// }
/// ```
///
/// Or with navigation:
/// ```swift
/// NavigationView {
///     TicketsView()
/// }
/// ```
struct TicketsView: UIViewControllerRepresentable {

    /// Called once to create the UIViewController
    func makeUIViewController(context: Context) -> TMTicketsViewController {
        let ticketsVC = TMTicketsViewController()
        return ticketsVC
    }

    /// Called when SwiftUI state changes
    func updateUIViewController(_ uiViewController: TMTicketsViewController, context: Context) {
        // TMTicketsViewController manages its own state
        // No updates needed from SwiftUI side
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        TicketsView()
    }
}
