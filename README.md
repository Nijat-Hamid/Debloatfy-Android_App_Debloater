<a id="readme-top"></a>
<h1 align="center">
  <a href="https://github.com/Nijat-Hamid/Debloatfy-Android_App_Debloater/releases"><img src="https://github.com/Nijat-Hamid/Debloatfy-Android_App_Debloater/blob/main/Demo/image/logo.png" alt="Debloatfy" width="200"></a>
  <br>
  Debloatfy
  <br>
</h1>

<h4 align="center">A minimalist macOS app built with SwiftUI for file transfers and app management between macOS and Android devices via ADB.</h4>

<p align="center">
  <a href="#introduction">Introduction</a> •
  <a href="#purpose">Purpose</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#support-and-roadmap">Support & Roadmap</a>
</p>

![screenshot](https://github.com/Nijat-Hamid/Debloatfy-Android_App_Debloater/blob/main/Demo/gif/demo.gif)

## Introduction

`Debloatfy` streamlines the management of your Android devices directly from your macOS system with an intuitive SwiftUI interface.

With Debloatfy, you can effortlessly transfer files between your macOS and Android devices, manage applications, and create backups—all through a single, elegant interface leveraging ADB connectivity.

Powered by optimized ADB commands, Debloatfy provides comprehensive device information and allows you to quickly remove unwanted bloatware, backup valuable applications, and restore them when needed, giving you complete control over your Android phone.

Experience lightning-fast file transfers for high-volume data between your computer and Android device, while the custom logging system keeps you informed of every operation in real-time, ensuring transparency and confidence in your device management workflow.

## Purpose

I've always been an Android user, appreciating the freedom and flexibility the operating system provides. However, Android has one persistent issue: manufacturers preload devices with numerous bloatware applications that can't be removed through normal means.

Previously, I relied on terminal commands and ADB to remove these unwanted apps and quickly transfer files to my computer before resetting my device. After doing this process manually countless times, I asked myself: why not create a user-friendly GUI to simplify these tasks?

That's how `Debloatfy` was born—a tool designed to bridge the gap between macOS and Android, making device management accessible without requiring terminal expertise.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Key Features

* Remove bloatware
  - Quickly remove unwanted pre-installed apps from your Android device
  - Select and remove multiple apps at once
* Backup & Restore
  - Backup important apps before removing or resetting your device
  - Easily restore apps from your backups when needed
* View detailed device information 
* File Transfer
  - High-speed file transfers between macOS and Android
  - Transfer large files efficiently
  - Cancel any task during transfer process
* Dark/Light mode
* Detailed Logging
  - Custom logging system for all actions
  - Clear visibility of processes and outcomes
* macOS Integration
  - Native macOS application
  - Optimized for macOS performance
* Offline App - No Network Connection
  - Works completely offline with no data sharing
* ADB management handled automatically
  - Latest Android Debug Bridge SDK
* Cancel any action during processing

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## How To Use

To use the "Debloatfy", you need to follow the steps below.:

```bash
# Step 1 - Access Developer Mode
  Navigate to Settings > About Phone. Locate the Build Number and tap it 7 times. You'll see a message confirming "Developer options enabled".

# Step 2 - Enable USB Debugging
  Go back to Settings and find the new Developer options menu. Toggle on "USB debugging". Accept the security prompt when it appears.

# Step 3 - Connect Your Device
  Use a USB cable to connect your Android device to your MacOS device. Ensure your device is unlocked.

# Step 4 - Grant Permissions
  When prompted on your Android device, check "Always allow from this computer".

# Step 5 - Ready to Use
  Debloatfy will detect your device and you can begin managing it.
```

> **Note:**
> Enabling Developer options is completely safe for your device. The setting can be disabled at any time after using Debloatfy with no impact on your device's normal operation or security.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Download

You can [download](https://github.com/Nijat-Hamid/Debloatfy-Android_App_Debloater/releases) the latest installable version of `Debloatfy` for macOS

## Tech Stack

* Target and Language:
  - Minimum OS: macOS 15.2 
  - Latest Swift 6.1 with "Strict Concurrency"
* Design Pattern and UI:
  - Model-View-ViewModel (MVVM) 
  - SwiftUI
* Database:
  - GRDB - Fully compatible with Swift Concurrency
* Testing:
  - Swift Testing Library
* Frameworks and etc:
  - Apple's OSLog framework for custom logging feature
  - Mockable protocol: Creating mock data for use in SwiftUI Previews
  - Singleton pattern for necessary services which must have only one instance
  - Nunito custom variable font integration
  - Nunito custom variable font integration
  - Snappy transition for navigation
  - Animated Dark/Light mode change
  - Animated Loading UI
  - ContentUnavailableView for different states
  - "Source of Truth" and "Separation of Concerns" design principles applied
  - Cancelable tasks for unstructuted concurrency
  - AppKit's Visual Effects applied for UI Design
  - Performance optimizations, popover & sheets and etc...

<details>
<summary>
  Architecture
</summary> <br />
<pre>
```
.Debloatfy
├─ App                        # Main App 
├─ Core                       
│  ├─ Componets               # Reusable global components. Sheets, lists and etc
│  ├─ Constans                # Global constans
│  ├─ Extensions              # Extensions
│  ├─ Helpers                 # Helper functions and nonisolated methods
│  ├─ Models                  # Global data models
│  ├─ Modifiers               # All View's modifiers
│  ├─ Package                 # ADB SDK folder
│  ├─ Protocols               # Global protocols
│  ├─ Routing                 # Routing system
│  ├─ Services                # Core services. Logger, Auth and etc
│  └─ Styles                  # Native components' styles. ToggleStyles, ButtonStyles and etc
├─ Resources                  
│  ├─ Assets.xcassets         # Assets
│  ├─ Fonts                   # Custom Fonts
│  └─ Preview Content         # Preview Content
└─ Scenes
   ├─ About                   # About Screen
   ├─ Debloat                 # Debloat Screen
   ├─ Debugging               # Debugging Screen
   ├─ Layout                  # Layout 
   ├─ Logs                    # Logs Screen 
   ├─ Overview                # Overview Screen
   ├─ Restore                 # Restore Screen
   └─ Transfer                # Transfer Screen
```
</pre>
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Support and Roadmap

If you like this project, its underlying philosophy, or appreciate my code as a developer, you can support me by giving it a star. This motivation will help me continue working on the project and deliver even better features in the future.

Debloatfy is currently under active development. Roadmap for upcoming releases:
* Finder-like Transfer page:
  - I'm thinking of turning the Transfer feature into something like the macOS file manager Finder, so you can do more things on your Android device's internal memory from macOS. 
* More cancelable tasks:
  - Currently, the user can only stop the transfer process. In future versions, there will be the ability to cancel tasks such as deleting apps, backing up, and more.
* More detailed information about Android device:
  - You are currently seeing limited information about your Android device in the app. More information will be shown in future versions.
* More ADB features:
  - More Android Debug Bridge features will be added in the next versions.
* More Performance optimizations:
  - The next version will bring more performance updates for background processes. It will also add features like pagination for app list.
* Support for more MacOS versions:
  - The app currently supports macOS 15.2 and later. Support for older macOS versions will be added in future versions.
  
<p align="right">(<a href="#readme-top">back to top</a>)</p>
  
## License

MIT License

Copyright 2025 Nijat Hamid <nicatorium@gmail.com>



