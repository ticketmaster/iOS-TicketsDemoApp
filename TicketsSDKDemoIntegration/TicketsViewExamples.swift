//
//  TicketsViewExamples.swift
//  TicketsSDKDemoIntegration
//
//  SwiftUI integration examples for TMTicketsViewController
//

import SwiftUI
import TicketmasterTickets

// MARK: - Basic Example

/// Simplest way to show tickets in SwiftUI
struct BasicTicketsExample: View {
    var body: some View {
        TicketsView()
            .navigationTitle("My Tickets")
    }
}

// MARK: - Modal Presentation Example

/// Example showing modal presentation of tickets
struct ModalTicketsExample: View {
    @State private var showTickets = false
    var onDismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            Button("Show My Tickets") {
                showTickets = true
            }
            .navigationTitle("Tickets Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        onDismiss?()
                    }
                }
            }
        }
        .sheet(isPresented: $showTickets) {
            NavigationView {
                TicketsView()
                    .navigationTitle("My Tickets")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                showTickets = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Tab View Example

/// Example showing tickets in a tab view
struct TabViewTicketsExample: View {
    var onDismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            TabView {
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                NavigationView {
                    TicketsView()
                        .navigationTitle("My Tickets")
                }
                .tabItem {
                    Label("Tickets", systemImage: "ticket")
                }

                Text("Profile")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .navigationTitle("Tickets Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        onDismiss?()
                    }
                }
            }
        }
    }
}

// MARK: - Full Screen Cover Example

/// Example showing tickets as full screen cover
struct FullScreenTicketsExample: View {
    @State private var showTickets = false
    var onDismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            Button("Show My Tickets") {
                showTickets = true
            }
            .navigationTitle("Tickets Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        onDismiss?()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showTickets) {
            NavigationView {
                TicketsView()
                    .navigationTitle("My Tickets")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Done") {
                                showTickets = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - NavigationStack Example (iOS 16+)

/// Example using NavigationStack for iOS 16+
@available(iOS 16.0, *)
struct NavigationStackTicketsExample: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TicketsView()
                        .navigationTitle("My Tickets")
                } label: {
                    Label("View My Tickets", systemImage: "ticket")
                }

                NavigationLink {
                    Text("Account Settings")
                        .navigationTitle("Settings")
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("Menu")
        }
    }
}

// MARK: - Previews

#Preview("Basic") {
    NavigationView {
        BasicTicketsExample()
    }
}

#Preview("Modal") {
    ModalTicketsExample()
}

#Preview("Tab View") {
    TabViewTicketsExample()
}

#Preview("Full Screen") {
    FullScreenTicketsExample()
}

#Preview("Navigation Stack") {
    if #available(iOS 16.0, *) {
        NavigationStackTicketsExample()
    }
}
