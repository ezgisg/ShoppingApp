# Shopping App
Shopping App is an e-commerce iOS application that provides a complete shopping experience up to the payment stage.
It is built with the **MVVM-C architecture** and uses data from [Fake Store API](https://fakestoreapi.com/).
The app is **modular**, created with **Swift Package Manager (SPM)**, and has a own network layer.

![ShoppingApp_Flow_optimized](https://github.com/user-attachments/assets/dba55119-b2dd-422d-983a-0f77982e2f68)

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
* **Combine**: Reactive programming is leveraged using the Combine framework, allowing for seamless data binding, real-time updates, and efficient handling of asynchronous events throughout the app.
* **UserDefaults**: Persistent local storage for user data.
* **Network Connectivity:** Checks for internet connectivity app-wide; restricts usage without internet.
<img width="400" alt="noConnection" src="https://github.com/user-attachments/assets/45b3bdfd-a6ba-4a12-9ccd-77a41fc041fb">

* **Loading View:** Displays a loading view until data is fetched for a smooth user experience.
  
https://github.com/user-attachments/assets/bd843137-b0f1-413a-9570-8fc26b44e919

* **Auto-dismiss Keyboard Feature:** The app includes a convenient auto-dismiss keyboard feature. When the keyboard is active, tapping anywhere outside it will hide the keyboard. Additionally, the view automatically shifts up if the active text field is covered by the keyboard, ensuring smooth user interactions.
  
https://github.com/user-attachments/assets/e9b8acfc-d40e-4672-9bb7-5203b51789e4

* **Lottie Animations**: Incorporates Lottie animations for a dynamic user experience.

## UI Architecture and Design
* **XIB Files:** The majority of the UI is designed using XIB files for ease of layout management and visual clarity.
* **Programmatic Views:** For common views like empty states, a programmatic approach is used to maintain flexibility and reusability across different parts of the application.

## Libraries Used

* **Firebase**: For authentication and analytics.
* **Google SignIn**: For Google account integration.
* **Alamofire**: For networking.
* **KingFisher**: For image downloading and caching.
* **Lottie**: For animations

## Main Views
* **Splash Screen:** This is the welcome screen displayed every time the application is opened. It features animations created using Lottie.
* **Onboarding:** Includes application introduction, created using Page ViewController. Features:
    * The introduction screen is shown only once; it is skipped on subsequent application starts (controlled via UserDefaults).
    * Users can proceed directly to the next screen if they choose to skip the onboarding process.
* **Sign In:** Sign-In screen. Features:
    * Users can log in using their previously registered email and password or via Google Sign-In. Firebase and GoogleSignIn libraries are utilized for this purpose.
    * A verification email is sent to newly registered users.
     <img width="400" alt="Doğrulama Maili" src="https://github.com/user-attachments/assets/bedc6d1a-296c-4a90-9f93-1613f1b86821">

* **Register:** This is the user registration screen. Features:
    * It includes validations such as ensuring the password does not contain the user's name, has no sequential numbers, and includes at least one character and one number.
    * If the registration is successful, the user is directed to the Home screen.
* **Home:** The home screen is the first tab in the tab bar, showcasing campaigns, advertisement banners, and category information.
    * Users can navigate to campaign details and the category screen from here.
    * The layout is created using Compositional Layout.
* **Categories:** This screen which is second tab in the tabbar, displays product categories. Users can search within categories using a search bar which is placed in the navigation bar. Upon opening a category, the user is directed to the product list screen containing products belonging to that category. 
    * It uses Compositional Layout and Diffable DataSource.
* **Product List:** This screen lists the products, allowing users to sort or filter the listed items.
    * It offers two different layouts and lets users navigate to the product detail page.
    * Users can also add items to the cart via a quick review or add/remove items from favorites using the heart icon on the product.
    * Diffable DataSource and Compositional Layout, custom rating view are utilized.
* **Product Detail:** This page displays the details of a product. Additionally, related products are suggested to the user. Users can arrive here from any product listing page. 
    * The page allows users to add the product to the cart and manage its favorite status.
* **Campaigns:** This is the third tab in the tab bar, listing available campaigns. Users can view the details of each campaign by tapping on them. The data is loaded from a local JSON file due to the lack of service data.
    * Compositional Layout is used to create this screen.
* **Cart:** This is the fourth tab in the tab bar, displaying the items added to the cart. The number of items is shown on a badge in the tab bar.
    * The screen suggests different products to the user, which can be directly added to the cart.
    * The number of items in the cart can be adjusted, and the selection status of items can be toggled in here.
    * A discount can also be applied by entering a campaign code.
    * The Cart Manager handles updates, and any additions made to the cart from anywhere in the app will be reflected in this tab.
    * Diffable DataSource and Compositional Layout are utilized.
    * It is monitored using the Combine framework, ensuring real-time updates to the cart items and quantities across the app.
* **Favorites:** This screen displays products added to favorites. It is the fifth tab in the tab bar.
    * Since there is no backend, favorite products are stored using UserDefaults.  
    * Compositional Layout is used.

## Samples

   * ### **Splash & Onboarding**
   https://github.com/user-attachments/assets/bec76479-df06-4c3c-881d-4993f00b9ce7
   * ### **Sign In**
   ######  **Sign In with E-mail-Password**
   https://github.com/user-attachments/assets/28a8cb2d-2340-4592-a30f-1d97ff67f64c
   ######  **Sign In with Google Sign-In**
   https://github.com/user-attachments/assets/83f44b29-34b7-48ac-82e5-7b0f5bf0ca4a
   * ### **Register**
   https://github.com/user-attachments/assets/e9569b13-d220-4af5-bf26-7db9e1a1c9f4
   * ### **Home**
   https://github.com/user-attachments/assets/7d0cd8d9-3d9e-4f66-bd1c-8a2f2278a1d7
   * ### **Categories**
   https://github.com/user-attachments/assets/dd503856-6593-42ac-a5e5-e35e0c0cf898
   * ### **Product List**
   https://github.com/user-attachments/assets/cf64f03d-c2b3-4232-84dc-a0e9635d62df
   * ### **Product Detail**
   https://github.com/user-attachments/assets/ca011cfd-5edb-4cfa-8d84-bb2b97387025
   * ### **Campaigns**
   https://github.com/user-attachments/assets/f0e27900-2cc1-4ad5-b061-f6f9adb05e66
   * ### **Cart**
   https://github.com/user-attachments/assets/1cc7b255-7b2a-4ae3-ac6e-b7d40c9047d5
   * ### **Favorites**
   https://github.com/user-attachments/assets/381fda4f-b6e1-4b5d-bb19-4504c251133f

## Files
<img width="200" alt="dosyayapısı" src="https://github.com/user-attachments/assets/95ac24aa-65c8-402f-96cd-295f512beb2c">
