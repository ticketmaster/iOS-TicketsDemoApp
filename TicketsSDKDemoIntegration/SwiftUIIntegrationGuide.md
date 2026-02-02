# SwiftUI Integration Guide

This guide shows how to integrate the Ticketmaster Tickets SDK into a SwiftUI application.

## Overview

The Tickets SDK is built with UIKit, but can be easily integrated into SwiftUI apps using `UIViewControllerRepresentable`. This repository includes a ready-to-use `TicketsView` wrapper and multiple integration examples.

## Files

- **TicketsView.swift** - SwiftUI wrapper for `TMTicketsViewController`
- **TicketsViewExamples.swift** - Four complete integration examples
- **MainMenuVC+TableViewDelegate.swift** - UIKit menu showing how to present SwiftUI views

## Quick Start

The demo app includes 4 working examples in the "SwiftUI Integration" section of the main menu:
1. **SwiftUI Basic (Push)** - Push TicketsView onto navigation stack
2. **SwiftUI Modal** - Present with sheet/modal
3. **SwiftUI Full Screen** - Present as full screen cover
4. **SwiftUI Tab View** - Embed in a tab view

## Basic Usage

### 1. Simple Integration

The simplest way to show tickets in SwiftUI:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TicketsView()
                .navigationTitle("My Tickets")
        }
    }
}
```

### 2. Modal Presentation

Present tickets modally with a close button:

```swift
struct MyView: View {
    @State private var showTickets = false

    var body: some View {
        Button("Show My Tickets") {
            showTickets = true
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
```

### 3. Tab View Integration

Add tickets to a tab view:

```swift
struct MainTabView: View {
    var body: some View {
        TabView {
            // Other tabs...

            NavigationView {
                TicketsView()
                    .navigationTitle("My Tickets")
            }
            .tabItem {
                Label("Tickets", systemImage: "ticket")
            }
        }
    }
}
```

### 4. Navigation Link

Navigate to tickets from a list:

```swift
struct MenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    TicketsView()
                        .navigationTitle("My Tickets")
                } label: {
                    Label("View My Tickets", systemImage: "ticket")
                }
            }
            .navigationTitle("Menu")
        }
    }
}
```

## Bridging from UIKit to SwiftUI

If you have an existing UIKit app and want to present SwiftUI views, use `UIHostingController`:

```swift
// In your UIViewController
let swiftUIView = TicketsView()
let hostingVC = UIHostingController(rootView: swiftUIView)

// Push onto navigation stack
navigationController?.pushViewController(hostingVC, animated: true)

// Or present modally
present(hostingVC, animated: true)
```

### Adding Dismiss Functionality

For modal presentations from UIKit, pass a dismiss closure to your SwiftUI view:

```swift
// 1. SwiftUI view with dismiss closure
struct ModalTicketsExample: View {
    var onDismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            TicketsView()
                .navigationTitle("My Tickets")
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

// 2. Present from UIKit with dismiss handler
let hostingVC = UIHostingController(rootView: ModalTicketsExample(onDismiss: { [weak self] in
    self?.dismiss(animated: true)
}))
present(hostingVC, animated: true)
```

This pattern allows SwiftUI views to dismiss their UIKit hosting controller. See `TicketsViewExamples.swift` for complete implementations.

## Prerequisites

Before using `TicketsView`, ensure the SDK is configured:

### SwiftUI App Configuration

Configure in your App struct:

```swift
@main
struct MyApp: App {
    init() {
        // Configure SDKs before any UI appears
        configureTicketmasterSDKs()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureTicketmasterSDKs() {
        // See MainMenuVC+Config.swift for full configuration example
        let settings = TMAuthentication.TMXSettings(
            apiKey: "YOUR_API_KEY",
            region: .US
        )
        let branding = TMAuthentication.Branding(
            displayName: "Your Team",
            backgroundColor: UIColor.blue,
            theme: .light
        )
        let brandedSettings = TMAuthentication.BrandedServiceSettings(
            tmxSettings: settings,
            branding: branding
        )

        TMAuthentication.shared.configure(brandedServiceSettings: brandedSettings) { _ in
            TMTickets.shared.configure {
                print("Tickets SDK configured")
            } failure: { error in
                print("Configuration error: \(error)")
            }
        } failure: { error in
            print("Configuration error: \(error)")
        }
    }
}
```

### UIKit App Configuration

Configure in your AppDelegate or SceneDelegate before presenting any views. See `MainMenuVC+Config.swift` for the complete example.

## Advanced Usage

### Full Screen Presentation

Use `fullScreenCover` for a full-screen experience:

```swift
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
```

### iOS 16+ NavigationStack

For iOS 16 and later, use `NavigationStack`:

```swift
@available(iOS 16.0, *)
struct ModernNavigationView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("My Tickets") {
                    TicketsView()
                }
            }
            .navigationTitle("Menu")
        }
    }
}
```

## How It Works

`TicketsView` is a `UIViewControllerRepresentable` that bridges UIKit and SwiftUI:

```swift
struct TicketsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TMTicketsViewController {
        return TMTicketsViewController()
    }

    func updateUIViewController(_ uiViewController: TMTicketsViewController, context: Context) {
        // No updates needed - TMTicketsViewController manages its own state
    }
}
```

The wrapper:
- Creates `TMTicketsViewController` once when the view appears
- Lets the Tickets SDK manage its own navigation and state
- Works seamlessly with SwiftUI navigation and presentation
- Handles all SDK callbacks and updates internally

## Demo App Examples

The demo app (MainMenuViewController) includes 4 interactive examples:

1. **BasicTicketsExample** - Simple push navigation
2. **ModalTicketsExample** - Sheet presentation with button
3. **FullScreenTicketsExample** - Full screen cover with button
4. **TabViewTicketsExample** - Complete tab view with tickets tab

Each example demonstrates:
- Proper NavigationView setup
- Close button with dismiss functionality
- Integration with UIKit via UIHostingController
- SwiftUI previews for development

## See Also

- **TicketsViewExamples.swift** - Complete working examples with previews
- **MainMenuVC+Config.swift** - SDK configuration details
- **MainMenuVC+TableViewDelegate.swift** - UIKit to SwiftUI bridging examples
- **EmbeddedViewController.swift** - UIKit integration example (alternative approach)
