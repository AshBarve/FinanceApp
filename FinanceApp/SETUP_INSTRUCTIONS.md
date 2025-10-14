# FinanceApp - Xcode Project Setup Instructions

Since we cannot programmatically create `.xcodeproj` files easily, follow these steps to set up the project in Xcode:

## Step 1: Create New Xcode Project

1. Open Xcode
2. Click **File → New → Project**
3. Choose **iOS → App**
4. Click **Next**

### Project Configuration:
- **Product Name**: `FinanceApp`
- **Team**: (Your team)
- **Organization Identifier**: `com.yourcompany` (or similar)
- **Bundle Identifier**: `com.yourcompany.FinanceApp`
- **Interface**: **Storyboard** (We'll use UIKit programmatically)
- **Language**: **Swift**
- **Storage**: None
- **Include Tests**: (Optional)

5. Click **Next**
6. Choose `/Users/ashish/Developer/Claude/FinanceApp` as the save location
7. ⚠️ **IMPORTANT**: Choose "Create Git repository" = **NO** (we have files already)
8. Click **Create**

## Step 2: Delete Auto-Generated Files

Xcode will create some files we don't need. Delete these:
1. `ContentView.swift` (if created)
2. `SceneDelegate.swift` (if created - we're using AppDelegate only)
3. `Main.storyboard` (if created)
4. `ViewController.swift` (if created)

## Step 3: Configure Project Settings

1. Select the **FinanceApp** project in Project Navigator
2. Select **FinanceApp** target
3. Go to **Info** tab
4. Remove **Main storyboard file base name** (delete this row)
5. Under **Application Scene Manifest**:
   - Delete the entire **Scene Configuration** section (since we're not using SceneDelegate)

## Step 4: Update Info.plist

Replace the auto-generated `Info.plist` with our custom one:

1. Right-click `Info.plist` → **Delete** → Move to Trash
2. In Finder, copy `/Users/ashish/Developer/Claude/FinanceApp/FinanceApp/App/Info.plist`
3. Drag it into the Xcode project under `FinanceApp/App/`

## Step 5: Add Existing Source Files

1. Delete the auto-generated `FinanceApp` group in Xcode
2. In Finder, drag the **entire** `FinanceApp` folder into Xcode
   - ✅ Check "Copy items if needed" = **NO** (files are already there)
   - ✅ Check "Create groups"
   - ✅ Check "Add to targets: FinanceApp"

You should now see:
```
FinanceApp/
├── App/
│   ├── AppDelegate.swift
│   └── Info.plist
├── Welcome/
│   ├── WelcomeViewController.swift
│   └── WelcomeViewModel.swift
└── Resources/
    └── account_creation_flow.json
```

## Step 6: Add Local SPM Packages

### Add UIComponentsKit:
1. Click **File → Add Package Dependencies...**
2. Click **Add Local...**
3. Navigate to `/Users/ashish/Developer/Claude/FinanceApp/UIComponentsKit`
4. Click **Add Package**
5. Ensure **FinanceApp** target is selected
6. Click **Add Package**

### Add AccountCreationKit:
1. Click **File → Add Package Dependencies...** again
2. Click **Add Local...**
3. Navigate to `/Users/ashish/Developer/Claude/FinanceApp/AccountCreationKit`
4. Click **Add Package**
5. Ensure **FinanceApp** target is selected
6. Click **Add Package**

## Step 7: Verify Package Dependencies

1. Select **FinanceApp** project
2. Go to **Package Dependencies** tab
3. You should see:
   - ✅ UIComponentsKit (Local)
   - ✅ AccountCreationKit (Local)

## Step 8: Configure Build Settings

1. Select **FinanceApp** target
2. Go to **Build Settings**
3. Search for "Info.plist File"
4. Set value to: `FinanceApp/App/Info.plist`

## Step 9: Build & Run

1. Select an iOS Simulator (iPhone 15 Pro or similar)
2. Press **⌘ + B** to build
3. Press **⌘ + R** to run

## Expected Behavior

✅ App launches showing Welcome screen with blue logo
✅ "Create Account" button navigates to SwiftUI flow
✅ Form fields render dynamically from JSON
✅ Validation works on all fields
✅ Can navigate through all 3 screens

## Troubleshooting

### If build fails with "cannot find 'AccountCreationKit' in scope":

1. Go to **File → Packages → Reset Package Caches**
2. Clean Build Folder (**⌘ + Shift + K**)
3. Rebuild (**⌘ + B**)

### If JSON file not found:

1. Select `account_creation_flow.json` in Project Navigator
2. In **File Inspector** (right panel), check **Target Membership**
3. Ensure **FinanceApp** is checked

### If UIColor.appPrimary errors:

Make sure both SPM packages are properly added and their modules are imported in the files.

## Alternative: Quick Command-Line Setup

If you prefer command line, you can also:

```bash
cd /Users/ashish/Developer/Claude/FinanceApp
open -a Xcode .
```

Then follow steps 6-9 to add packages and build.

---

**Note**: The source code is complete. Once the Xcode project is set up, it should build and run immediately!
