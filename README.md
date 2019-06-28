## ￼￼Start integrating Google Sign-In into your iOS app

#Set up your CocoaPods dependencies

Google Sign-In uses CocoaPods to install and manage dependencies. Open a terminal window and navigate to the location of the Xcode project for your application. If you have not already created a Podfile for your application, create one now:

pod init

Open the Podfile created for your application and add the following: pod 'GoogleSignIn'

Save the file and run:
pod install

This creates an .xcworkspace file for your application. Use this file for all future development on your application.

# Get an OAuth client ID

If you haven't already created an OAuth client ID, create it first.
After you create the OAuth client ID, take note of the client ID string, which you will need to configure Google Sign-in in your app. You can optionally download the configuration file, which contains your client ID and other configuration data, for future reference.

Add a URL scheme to your project 
Google Sign-in requires a custom URL Scheme to be added to your project. To add the custom scheme:

1. Open your project configuration: double-click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types section. 
2. Click the + button, and add your reversed client ID as a URL scheme. The reversed client ID is your client ID with the order of the dot-delimited fields reversed. For example: 
        com.googleusercontent.apps.1234567890-abcdefg

Now that you've downloaded the project dependencies and configured your Xcode project, you can add Google-Sign-In to your iOS app.

# Enable sign-in

To enable sign in, you must configure the GIDSignIn shared instance. You can do this in many places in your app. Often the easiest place to configure this instance is in your app delegate's application:didFinishLaunchingWithOptions:method.

1. In your app delegate (AppDelegate.swift), declare that this class implements the GIDSignInDelegateprotocol.

        import GoogleSignIn

       ...

       class AppDelegate: UIResponder,                                                  UIApplicationDelegate, GIDSignInDelegate {


2. In your app delegate's application:didFinishLaunchingWithOptions: method, configure the GIDSignInshared instance and set the sign-in delegate.
        
        func application(_ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Initialize sign-in
    GIDSignIn.sharedInstance().clientID = "YOUR_CLIENT_ID"
    GIDSignIn.sharedInstance().delegate = self

    return true
}

3. Implement the application:openURL:options: method of your app delegate. The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url as URL?,
                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])
}

4. In the app delegate, implement the GIDSignInDelegate protocol to handle the sign-in process by defining the following methods:

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
  withError error: Error!) {
    if let error = error {
      print("\(error.localizedDescription)")
    } else {
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
      // ...
    }
}

# Add the sign-in button

Next, you will add the Google Sign-In button so that the user can initiate the sign-in process. Make the following changes to the view controller that manages your app's sign-in screen:

1. In the view controller, declare that this class implements the GIDSignInUIDelegate protocol and GIDSignInDelegate.

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {


2. Add a GIDSignInButton to your storyboard, XIB file, or instantiate it programmatically. To add the button to your storyboard or XIB file, add a View and set its custom class to GIDSignInButton.

3. In the GIDSignInButton action, set the UI delegate of the GIDSignIn object and also use signIn method to sign in. You can use the signOut method of the GIDSignIn object to sign out your user on the current device

    @objc func signinUserWithGoogle(_ sender: UIButton) {
        
        if btnGoogleSignIn.title(for: .normal) == "Sign Out" {
            GIDSignIn.sharedInstance()?.signOut()
            lblTitle.text = ""
            btnGoogleSignIn.setTitle("Sign In Using Google", for: .normal)
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }

4. Next Implement the signIn:didSignInFor: method of GIDSignInDelegate protocol. For Example:

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("We have error sign in user = \(error)")
        }
        else {
            if let gmailUser = user {
                lblTitle.text = "You are sign using id \(gmailUser.profile.email!)"
                btnGoogleSignIn.setTitle("Sign Out", for: .normal)
            }
        }
    }

