# Shopping App
Shopping App is an e-commerce iOS application that provides a complete shopping experience up to the payment stage.
It is built with the **MVVM-C architecture** and uses data from [Fake Store API](https://fakestoreapi.com/).
The app is **modular**, created with **Swift Package Manager (SPM)**, and has a own network layer.

![ShoppingApp_Flow_optimized](https://github.com/user-attachments/assets/04b78b35-6fa6-42fa-b878-8e28e1a13e2b)

## General Features

* **MVVM-C Architecture**: Ensures a clean, maintainable codebase.
* **UIKit**: The entire UI is built using UIKit.
* **UI Design:** Utilizes ***Autolayout*** for responsive UI design.
* **Localization:** Supports English and Turkish languages.
* **Theme Support**: Dark and light mode support.
<img width="400" alt="autolayout-language-theme" src="https://github.com/user-attachments/assets/102291c3-3815-4695-ac0e-65d1590f30e2">
<img width="400" alt="autolayout-language-theme0" src="https://github.com/user-attachments/assets/f7945bed-602a-43d0-bbef-9e755cb7dacf">

* **Layout and Data Management:** Implements ***compositional layout*** and ***diffable datasource*** on some pages for efficient data rendering.
* **Firebase Integration:** Allows users to register and log in with their credentials using Firebase authentication.
* **Google Sign-In:** Offers Google Sign-In as an alternative login method, enhancing user convenience and accessibility.
* **Notification Center**: Ensuring up-to-date information across the app.
* **UserDefaults**: Persistent local storage for user data.
* **Network Connectivity:** Checks for internet connectivity app-wide; restricts usage without internet.
<img width="400" alt="noConnection" src="https://github.com/user-attachments/assets/45b3bdfd-a6ba-4a12-9ccd-77a41fc041fb">

* **Loading View:** Displays a loading view until data is fetched for a smooth user experience.
<img height="400" alt="Simulator Screenshot - iPhone 15 Pro Max - 2024-08-27 at 12 30 26" src="https://github.com/user-attachments/assets/e991fcfa-f139-4c70-9332-a55e2f52a76b">

* **Auto-dismiss Keyboard Feature:** Includes a convenient feature where the keyboard automatically dismisses when tapping anywhere outside of it, except on the keyboard itself.
* **Lottie Animations**: Incorporates Lottie animations for a dynamic user experience.

