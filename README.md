# iOS Tickets SDK Application Integration Demo

This is an example integration of the Ticketmaster Ignite SDK, Tickets framework.

* Overview: https://business.ticketmaster.com/ignite/
* Release Notes: 
  * Authentication: https://ignite.ticketmaster.com/docs/ios-authentication-change-log
  * Tickets: https://ignite.ticketmaster.com/docs/ios-tickets-change-log
* General Documentation: https://ignite.ticketmaster.com/docs/tickets-sdk-overview
* API Documentation: https://code.ticketmaster.com/iOS-TicketmasterSDK/docs
* Frameworks: https://github.com/ticketmaster/iOS-TicketmasterSDK
* Android Source (Tickets SDK): https://github.com/ticketmaster/Android-TicketsDemoApp
* iOS Source (Tickets SDK): https://github.com/ticketmaster/iOS-TicketsDemoApp

### Change Log

* Tickets SDK: https://ignite.ticketmaster.com/docs/ios-tickets-change-log
* Authentication SDK: https://ignite.ticketmaster.com/docs/ios-authentication-change-log

## Demo App Screenshots

<img src="Screenshots/MainMenu.jpg" alt="Main Menu" /> <img src="Screenshots/Login.jpg" alt="Login" /> <img src="Screenshots/Events.jpg" alt="Events Listing Page" /> <img src="Screenshots/Tickets.jpg" alt="Tickets Listing Page" />


## What's New

**SwiftUI Integration** - Complete SwiftUI support with 4 working examples:
- `TicketsView.swift` - UIViewControllerRepresentable wrapper
- `TicketsViewExamples.swift` - Modal, full screen, push, and tab view examples
- `SwiftUIIntegrationGuide.md` - Comprehensive integration documentation

**Code Quality Improvements** - Refactored for better clarity and maintainability:
- Extracted duplicate code into reusable helper methods
- Replaced magic strings with typed constants
- Improved code organization and readability

## Getting Started

1. Open **TicketsSDKDemoIntegration.xcodeproj** using Swift 5.9+ or Swift 6.0.3+ (Xcode 16.2+ or Xcode 26+) for development and iOS 17.0+ as your release target
   1. This will also download the required .xcframeworks using Swift Package Manager
2. In **Configuration.swift**, replace the `apiKey` value with your own API key from [https://developer.ticketmaster.com/explore/](https://developer.ticketmaster.com/explore/)
3. Update **TicketsSDKDemoIntegration** target's _Signing & Capabilities_ with your own Apple Developer certificate from [https://developer.apple.com/](https://developer.apple.com/)
4. Build and Run **TicketsSDKDemoIntegration** target


# Example Code

## Configuration

1. Update your API key and branding colors in _Configuration.Swift_

2. Authentication SDK is configured using settings from _Configuration.Swift_

3. Tickets SDK inherits it's configuration from Authentication SDK

A basic example of this is provided in _MainMenuVC+Config.swift_


## Presentation

### UIKit Integration

There are 3 different ways to present the Tickets SDK in UIKit apps:
* **Push** on Navigation stack (requires a UINavigationController in your app) - **Recommended**
* **Modal** presentation on top of your own UIViewController (easiest to integrate) - **Recommended**
* **Embedded** presentation within your own UIViewController (advanced use cases)

Basic examples of all 3 UIKit methods are provided in _MainMenuVC+TableViewDelegate.swift_

### SwiftUI Integration

There are 4 complete SwiftUI integration examples:
* **SwiftUI Basic (Push)** - Push TicketsView onto NavigationView stack
* **SwiftUI Modal** - Present with `.sheet` modifier
* **SwiftUI Full Screen** - Present with `.fullScreenCover` modifier
* **SwiftUI Tab View** - Embed in TabView with multiple tabs

All SwiftUI examples demonstrate proper bridging from UIKit using `UIHostingController` and include Close buttons with dismiss functionality.

Examples are provided in:
- _TicketsView.swift_ - UIViewControllerRepresentable wrapper
- _TicketsViewExamples.swift_ - Four complete integration examples
- _SwiftUIIntegrationGuide.md_ - Full documentation with code examples
- _MainMenuVC+TableViewDelegate.swift_ - UIKit menu showing how to present SwiftUI views

### Recommendation

**UIKit apps**: Use `TMTicketsViewController` with push or modal presentation

**SwiftUI apps**: Use `TicketsView` wrapper with any of the 4 presentation patterns

**Hybrid apps**: Use `UIHostingController` to bridge between UIKit and SwiftUI (see examples in _MainMenuVC+TableViewDelegate.swift_)


## Authentication

While not required, your application may want to control login-related processes directly.

* **Login**
* **Member Info**
* **Logout**

Tickets SDK handles Login/Logout on it's own, so there is no need for you to manually call any of these methods.

However, basic examples of calling Login, MemberInfo, or Logout have been provided in  _MainMenuVC+TableViewDelegate_.


## Information

While not required, your application may want to be informed of operations and use behavior with Authentication and Tickets SDKs.

This information is provided via delegate protocols, basic examples are provided.

* **TMTicketsOrderDelegate**: optional delegate to be informed of non-analytics User-actions
    - see: _MainMenuVC+OrderDelegate.swift_
* **TMTicketsAnalyticsDelegate**: optional delegate to be informed of User behavior
    - see: _MainMenuVC+AnalyticsDelegate.swift_
* **TMAuthenticationDelegate**: optional delegate to recieve login state change information
    - see: _MainMenuVC+AuthDelegate.swift_


## Custom Modules

<img src="Screenshots/Modules.jpg" alt="Custom Modules" style="zoom:50%;" />

While not required, your application may want to use Prebuilt Modules or even create your Custom Modules to display underneath the Tickets on the Tickets Listing page.

* **TMTicketsModuleDelegate**: optional delegate to implement prebuilt and custom _TMTicketsModule_ to be rendered on the Tickets listing page
    - see: _MainMenuVC+ModuleDelegate.swift_


## Additional Documentation

**CLAUDE.md** - Project documentation for AI coding assistants
- Architecture overview and key implementation details
- SDK configuration flow and presentation patterns
- SwiftUI integration summary and bridging patterns

**SwiftUIIntegrationGuide.md** - Complete SwiftUI integration guide
- Basic to advanced usage patterns
- UIKit to SwiftUI bridging with UIHostingController
- Prerequisites and SDK configuration for SwiftUI apps
- Four working examples with code snippets
