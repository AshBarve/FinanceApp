# FinanceApp - Server-Driven UI Account Creation

A hybrid UIKit/SwiftUI iOS application demonstrating server-driven UI architecture with local SPM packages.

## Architecture Overview

### Project Structure

```
FinanceApp/
├── FinanceApp/ (Main UIKit App)
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   └── Info.plist
│   ├── Welcome/
│   │   ├── WelcomeViewController.swift (UIKit)
│   │   └── WelcomeViewModel.swift
│   └── Resources/
│       ├── account_creation_flow.json
│       └── Assets.xcassets
│
├── AccountCreationKit/ (Local SPM - SwiftUI)
│   └── Sources/AccountCreationKit/
│       ├── Public/
│       │   └── AccountCreationFlow.swift (Entry point)
│       ├── Models/
│       │   ├── FlowConfiguration.swift
│       │   ├── ScreenModel.swift
│       │   └── FieldModel.swift
│       ├── Parser/
│       │   └── FlowConfigParser.swift
│       ├── Screens/
│       │   ├── CreateAccount/
│       │   │   ├── CreateAccountView.swift
│       │   │   └── CreateAccountViewModel.swift
│       │   ├── PersonalDetails/
│       │   │   ├── PersonalDetailsView.swift
│       │   │   └── PersonalDetailsViewModel.swift
│       │   └── Base/
│       │       ├── DynamicFormRenderer.swift
│       │       └── BaseFormViewModel.swift
│       ├── Validation/
│       │   └── ValidationEngine.swift
│       └── Services/
│           └── AccountCreationService.swift
│
└── UIComponentsKit/ (Local SPM - Shared Design System)
    └── Sources/UIComponentsKit/
        ├── Components/
        │   ├── Buttons/ (PrimaryButton, SecondaryButton)
        │   ├── TextFields/ (CustomTextField, PhoneField)
        │   ├── Pickers/ (CustomPicker, DatePickerField)
        │   └── RadioButtons/ (RadioButtonGroup)
        └── Theme/
            ├── Colors.swift
            ├── Fonts.swift
            └── DesignTokens.swift
```

## Key Features

### 1. **Hybrid Architecture**
- Main app uses **UIKit** (WelcomeViewController)
- Account creation flow uses **SwiftUI**
- Seamless integration via UIHostingController

### 2. **Server-Driven UI**
- UI layout defined in `account_creation_flow.json`
- Dynamic form rendering based on JSON configuration
- No app update needed to change UI structure

### 3. **MVVM Pattern**
- Each screen has its own ViewModel
- ViewModels extend BaseFormViewModel for common functionality
- Screen-specific business logic and API calls

### 4. **Local SPM Architecture**
- **UIComponentsKit**: Reusable UI components for both UIKit & SwiftUI
- **AccountCreationKit**: Complete account creation flow module
- Clean dependency graph: `Main App → AccountCreationKit → UIComponentsKit`

## JSON Configuration

The `account_creation_flow.json` defines:
- Screen structure and order
- Field types and validations
- Actions and navigation
- Labels and placeholders

### Supported Field Types:
- `text_field`
- `phone_field`
- `date_picker`
- `dropdown`
- `radio_group`

### Supported Validations:
- `required`
- `email`
- `phone`
- `min_length`
- `numeric`
- `min_age`

## How to Open in Xcode

Since this is a Swift Package-based structure without an .xcodeproj file, you need to:

1. Open Xcode
2. Create a new iOS App project
3. Name it "FinanceApp"
4. Replace the generated files with the structure above
5. Add local package dependencies:
   - File → Add Package Dependencies → Add Local...
   - Add `UIComponentsKit`
   - Add `AccountCreationKit`

## Navigation Flow

```
AppDelegate
    ↓
WelcomeViewController (UIKit)
    ↓ (tap "Create Account")
UIHostingController wraps AccountCreationFlow (SwiftUI)
    ↓
CreateAccountView → PersonalDetailsView (Page 1) → PersonalDetailsView (Page 2)
    ↓
Completion callback back to UIKit
```

## API Integration Points

Each ViewModel has hardcoded endpoint constants:

**CreateAccountViewModel:**
- `/api/v1/country-codes` - Fetch country codes
- `/api/v1/validate-account` - Validate account number

**PersonalDetailsViewModel:**
- `/api/v1/marital-status` - Fetch marital status options
- `/api/v1/education-levels` - Fetch education levels

**AccountCreationService:**
- `/api/v1/account/create` - Submit account creation

## Design System (UIComponentsKit)

### Colors
- Primary: `#4285F4`
- Background: `#FFFFFF`
- Surface: `#F5F5F5`
- Text Primary: `#000000`
- Text Secondary: `#666666`

### Design Tokens
- Button Height: 56pt
- Corner Radius: 25pt (buttons), 20pt (inputs)
- Spacing: 8pt (small), 16pt (medium), 24pt (large)

## Key Components

### DynamicFormRenderer
Reusable SwiftUI view that renders any screen based on JSON configuration. Supports all field types and handles validation.

### BaseFormViewModel
Base class for all screen ViewModels with:
- Form state management
- Field validation
- Value binding helpers

### ValidationEngine
Validates form fields based on JSON rules without hardcoding validation logic.

## Benefits of This Architecture

1. ✅ **Modularity** - Each SPM can be developed/tested independently
2. ✅ **Reusability** - UIComponentsKit used across features
3. ✅ **Flexibility** - Server-driven UI allows backend control
4. ✅ **Scalability** - Easy to add new screens via JSON
5. ✅ **Testability** - ViewModels can be tested in isolation
6. ✅ **Future-proof** - Gradual UIKit to SwiftUI migration

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+
