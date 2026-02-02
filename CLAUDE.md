# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS demo application that integrates the Ticketmaster Ignite SDK (Authentication and Tickets frameworks). The app demonstrates multiple integration patterns for displaying ticket information and handling authentication flows.

**Key Resources:**
- API Documentation: https://code.ticketmaster.com/iOS-TicketmasterSDK/docs
- Tickets SDK Change Log: https://ignite.ticketmaster.com/docs/ios-tickets-change-log
- Authentication SDK Change Log: https://ignite.ticketmaster.com/docs/ios-authentication-change-log

## Build and Run

### Requirements
- Xcode 16.2+ (Swift 5.9+) or Xcode 26+ (Swift 6.0.3+)
- iOS 17.0+ deployment target

### Setup
1. Open `TicketsSDKDemoIntegration.xcodeproj`
2. In `TicketsSDKDemoIntegration/Configuration.swift`, replace the `apiKey` value with your own API key from https://developer.ticketmaster.com/explore/
3. Configure signing with your Apple Developer certificate in target settings
4. Build and run the `TicketsSDKDemoIntegration` target

### Build Commands
```bash
# Build the project
xcodebuild -project TicketsSDKDemoIntegration.xcodeproj -scheme TicketsSDKDemoIntegration -configuration Debug build

# Build for release
xcodebuild -project TicketsSDKDemoIntegration.xcodeproj -scheme TicketsSDKDemoIntegration -configuration Release build
```

## Architecture

### Configuration Flow
The SDK configuration follows a strict two-step initialization sequence in `MainMenuVC+Config.swift`:

1. **Authentication SDK** must be configured first with `TMAuthentication.shared.configure()`
2. **Tickets SDK** inherits configuration from Authentication SDK via `TMTickets.shared.configure()`

This order is critical and enforced in the `configureBothSDKs()` method.

### Core Components

**MainMenuViewController** - Entry point demonstrating all integration patterns, split across extensions:
- `MainMenuVC+Config.swift`: SDK configuration and initialization
- `MainMenuVC+TableViewDelegate.swift`: User interaction handlers for different presentation modes
- `MainMenuVC+AuthDelegate.swift`: `TMAuthenticationDelegate` implementation for login state changes
- `MainMenuVC+AnalyticsDelegate.swift`: `TMTicketsAnalyticsDelegate` implementation for user behavior tracking
- `MainMenuVC+OrderDelegate.swift`: `TMTicketsOrderDelegate` implementation for ticket-related actions
- `MainMenuVC+ModuleDelegate.swift`: `TMTicketsModuleDelegate` implementation for custom content modules
- `MainMenuVC+PrebuiltModules.swift`: Prebuilt module configurations (venue, parking, etc.)
- `MainMenuVC+CustomModules.swift`: Custom module implementations

**Configuration.swift** - Central configuration containing:
- API key (must be updated with your key)
- Region setting (`.US` or `.UK`)
- Branding (colors, theme, display name, team logo)

**EmbeddedViewController** - Demonstrates embedding `TMTicketsView` within a custom view hierarchy using Auto Layout constraints. Note: Using `TMTicketsViewController` is recommended; this embedded pattern is provided as an alternative for advanced use cases.

### Presentation Patterns

The app demonstrates three SDK presentation methods:

1. **Push Navigation**: Push `TMTicketsViewController` onto navigation stack (recommended)
2. **Modal Presentation**: Present `TMTicketsViewController` modally (recommended)
3. **Embedded View**: Embed `TMTicketsView` in custom view controller with constraints (advanced)

**Recommendation**: Use `TMTicketsViewController` (push or modal) for most use cases. The embedded `TMTicketsView` pattern is provided for advanced scenarios requiring custom view hierarchies.

### Custom Modules System

The Tickets SDK supports rendering custom content modules below tickets on the listing page. The module system has two types:

**Prebuilt Modules** (`MainMenuVC+PrebuiltModules.swift`):
- Venue concessions, parking, merchandise, etc.
- Configured via `TMTicketsPrebuiltModule` types
- Require implementation of action handlers in `handleModuleActionButton()`

**Custom Modules** (`MainMenuVC+CustomModules.swift`):
- Fully custom content with your own UI components
- Define via `TMTicketsModule` with header, body, buttons
- Support images, text, action buttons with callbacks

Modules are assembled in `addCustomModules(event:completion:)` delegate method and returned in display order.

### Delegate Pattern

All SDK interaction uses delegation:
- `TMAuthenticationDelegate`: Login/logout state changes
- `TMTicketsOrderDelegate`: Non-analytics user actions (transfers, seat upgrades, etc.)
- `TMTicketsAnalyticsDelegate`: User behavior tracking
- `TMTicketsModuleDelegate`: Custom module lifecycle and actions

Delegates are optional but recommended for production integrations.

## Key Implementation Details

### SDK Initialization Order
Always configure Authentication SDK before Tickets SDK. Tickets SDK inherits its configuration and will fail if Authentication is not configured first.

### Branding Override
Basic branding is set during Authentication SDK configuration. Advanced Tickets-specific branding can be applied after `TMTickets.shared.configure()` completes using `brandingColorsOverride` property.

### Login Handling
Tickets SDK automatically handles login flows. Manual login calls via `TMAuthentication.shared.login()` are optional and only needed if you want to control the login trigger separately.

### Embedded View Constraints
When using `TMTicketsView` directly (embedded pattern), you must:
1. Call `TMTickets.shared.start(ticketsView:)` after SDK configuration completes
2. Set `translatesAutoresizingMaskIntoConstraints = false`
3. Add constraints relative to `safeAreaLayoutGuide` to avoid overlap with navigation bars

## Dependencies

This project uses Swift Package Manager. The Ticketmaster SDK is also available via CocoaPods (https://cocoapods.org/pods/TM-Ignite).

**TicketmasterSDK** (https://github.com/ticketmaster/iOS-TicketmasterSDK.git)
- TicketmasterFoundation
- TicketmasterAuthentication
- TicketmasterTickets
- TicketmasterSecureEntry
- TicketmasterSwiftProtobuf

Currently using Ticketmaster SDK version 1.18.0 (Tickets 3.15.0).
