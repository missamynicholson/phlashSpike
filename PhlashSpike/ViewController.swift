//
//  ViewController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 12/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var overlayView:UIView = UIView()
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraAspectRatio:CGFloat = 4.0/3.0
    var defaults = NSUserDefaults.standardUserDefaults()
    var phlashesArray:[PFObject] = []
    let whiteColor = UIColor.whiteColor()
    let backgroundGreen: UIColor = UIColor( red: CGFloat(62/255.0), green: CGFloat(200/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(1.0) )
    
    var greenView:UIView = UIView()
    let usernameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let submitButton = UIButton()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let logoutButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildGreenView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadCameraView()
        if (PFUser.currentUser() != nil) {
            print("Hello" + PFUser.currentUser()!.username!)
        } else {
            showLoginOrSignupScreen()
        }
    }
    
    func buildGreenView() {
        greenView.frame = CGRect(x: 0, y: screenBounds.height, width: screenBounds.width, height: screenBounds.height)
        greenView.backgroundColor = backgroundGreen
        usernameField.frame = CGRect(x: 0, y: screenBounds.height/8, width: screenBounds.width, height: screenBounds.height/15)
        usernameField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        usernameField.placeholder = "Username"
        usernameField.textAlignment = .Center
        
        emailField.frame = CGRect(x: 0, y: screenBounds.height/4, width: screenBounds.width, height: screenBounds.height/15)
        emailField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        emailField.placeholder = "Email"
        emailField.textAlignment = .Center
        emailField.keyboardType = UIKeyboardType.EmailAddress
        
        passwordField.frame = CGRect(x: 0, y: screenBounds.height * 3/8, width: screenBounds.width, height: screenBounds.height/15)
        passwordField.backgroundColor = UIColor.whiteColor()
        passwordField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .Center
        passwordField.secureTextEntry = true
        
        submitButton.frame = CGRect(x: screenBounds.width/4, y: screenBounds.height/2, width: screenBounds.width/2, height: 30)
        submitButton.setTitleColor(.whiteColor(), forState: .Normal)
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        loginButton.frame = CGRect(x: screenBounds.width*2/5, y: screenBounds.height/2 - 50, width: screenBounds.width/5, height: 30)
        loginButton.setTitleColor(.whiteColor(), forState: .Normal)
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        signupButton.frame = CGRect(x: screenBounds.width*2/5, y: screenBounds.height/2, width: screenBounds.width/5, height: 30)
        signupButton.setTitleColor(.whiteColor(), forState: .Normal)
        signupButton.setTitle("Signup", forState: .Normal)
        signupButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        
        greenView.addSubview(usernameField)
        greenView.addSubview(emailField)
        greenView.addSubview(passwordField)
        greenView.addSubview(submitButton)
        greenView.addSubview(loginButton)
        greenView.addSubview(signupButton)
        self.overlayView.addSubview(greenView)
    }
    
    func loadCameraView() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.showsCameraControls = false
            picker.delegate = self
            picker.modalPresentationStyle = .FullScreen
            
            picker = makePickerFullScreen(picker)
            
            initialiseOverlayView(picker)
            
            presentViewController(picker, animated: true, completion: {
                self.picker.cameraOverlayView = self.overlayView
                self.addLogoutButton()
                }
            )
        }
    }
    
    func addLogoutButton() {
        logoutButton.frame = CGRect(x: screenBounds.width*4/5, y: 20, width: screenBounds.width/5, height: 30)
        logoutButton.setTitleColor(.whiteColor(), forState: .Normal)
        logoutButton.setTitle("Logout", forState: .Normal)
        logoutButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        self.overlayView.addSubview(logoutButton)
    }
    
    
    func buttonAction(sender: UIButton!) {
        if sender == submitButton && emailField.hidden {
            login()
        } else if sender == submitButton {
            signUp()
        } else if sender == loginButton {
            showLoginView()
        } else if sender == signupButton {
            showSignupView()
        } else if sender == logoutButton {
            logout()
        }
    }
    
    func showLoginOrSignupScreen() {
        usernameField.hidden = true
        passwordField.hidden = true
        submitButton.hidden = true
        emailField.hidden = true
        loginButton.hidden = false
        signupButton.hidden = false
        showGreenView()
    }
    
    func showLoginView() {
        usernameField.hidden = false
        passwordField.hidden = false
        submitButton.hidden = false
        submitButton.setTitle("Log me in", forState: .Normal)
        emailField.hidden = true
        loginButton.hidden = true
        signupButton.hidden = true
        showGreenView()
        usernameField.becomeFirstResponder()
    }
    
    func showSignupView() {
        usernameField.hidden = false
        passwordField.hidden = false
        submitButton.hidden = false
        submitButton.setTitle("Sign me up", forState: .Normal)
        
        emailField.hidden = false
        loginButton.hidden = true
        signupButton.hidden = true
        showGreenView()
        usernameField.becomeFirstResponder()
    }
    
    func initialiseOverlayView(picker: UIImagePickerController) {
        self.overlayView.frame = picker.view.frame
        self.overlayView.backgroundColor = UIColor.clearColor()
        addRightSwipe()
        addLeftSwipe()
    }
    
    func addRightSwipe() {
        let aSelector : Selector = #selector(ViewController.respondToSwipeGesture(_:))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: aSelector)
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.overlayView.addGestureRecognizer(swipeRight)
    }
    
    func addLeftSwipe() {
        let aSelector : Selector = #selector(ViewController.respondToSwipeGesture(_:))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: aSelector)
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.overlayView.addGestureRecognizer(swipeLeft)
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                self.picker.takePicture()
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                showFirstPhlash()
            default:
                break
            }
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        sendPhoto(chosenImage)
        let imageView = getNewImageView(chosenImage)
        self.overlayView.addSubview(imageView)
        self.swipeTakenPicViewOut(imageView)
        
        delay(3.0) {
            imageView.removeFromSuperview()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getNewImageView(image: UIImage) -> UIImageView {
        let imageView:UIImageView = UIImageView()
        
        let newWidth = getNewWidth(image)
        let xValue:CGFloat = (newWidth-screenBounds.width)/2
        
        imageView.frame = CGRect(x: -xValue, y: 0, width: newWidth, height: screenBounds.height)
        imageView.image = resizeImage(image, newWidth: newWidth)
        
        return imageView
    }
    
    
    func getNewShowImageView(image: UIImage) -> UIImageView {
        let imageView:UIImageView = UIImageView()
        
        let newWidth = getNewWidth(image)
        
        imageView.frame = CGRect(x: screenBounds.width * 2, y: 0, width: newWidth, height: screenBounds.height)
        imageView.image = resizeImage(image, newWidth: newWidth)
        
        return imageView
    }
    
    func getNewWidth(image: UIImage) -> CGFloat {
        let newWidth:CGFloat = image.size.width/(image.size.height/screenBounds.height)
        return newWidth
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let newSize: CGSize = CGSizeMake(newWidth, screenBounds.height)
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func makePickerFullScreen(picker: UIImagePickerController) -> UIImagePickerController {
        let camViewHeight: CGFloat = screenBounds.width * cameraAspectRatio
        let scale: CGFloat = screenBounds.height / camViewHeight
        picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
        return picker
        
    }
    
    func sendPhoto(image: UIImage) {
        let currentUser = PFUser.currentUser()
        let currentUsername = currentUser!.username!
        
        let newWidth:CGFloat = getNewWidth(image)
        let newImage = resizeImage(image, newWidth: newWidth)
        let imageData = UIImagePNGRepresentation(newImage)
        guard let checkedImage = imageData else {
            print ("Checked Image  is nil")
            return
        }
        
        let imageFile = PFFile(name:"image.png", data:checkedImage)
        let phlash = PFObject(className: "Phlash")
        phlash["file"] = imageFile
        phlash["username"] = currentUsername
        phlash.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
                let push = PFPush()
                push.setChannel(currentUsername)
                push.setMessage("\(currentUsername) has just phlashed!")
                push.sendPushInBackground()
            } else {
                print("Error: \(error)")
            }
        }
    }
    
    
    func queryDatabaseForPhotos() {
        //let lastSeenDate = defaults.objectForKey("lastSeen")
        
        let currentUser = PFUser.currentUser()
        let currentUsername = currentUser!.username!
        
        let phollowing = PFQuery(className:"Phollow")
        phollowing.whereKey("fromUsername", equalTo:currentUsername)
        
        let phlashes = PFQuery(className: "Phlash")
        phlashes.whereKey("username", matchesKey: "toUsername", inQuery: phollowing)
        //phlashes.whereKey("createdAt", greaterThan: lastSeenDate!)
        phlashes.orderByAscending("createdAt")
        
        
        phlashes.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = results {
                    self.phlashesArray = objects
                    self.showFirstPhlash()
                    print("there are \(objects.count) phlashes")
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func showFirstPhlash() {
        if self.phlashesArray.count < 1 {
            queryDatabaseForPhotos()
        } else {
            let phlash = phlashesArray.first
            let userImageFile = phlash!["file"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        let imageView = self.getNewShowImageView(image!)
                        self.overlayView.addSubview(imageView)
                        self.swipeImageViewIn(imageView)
                    }
                }
            }
        }
    }
    
    
    func phollow(toUsername: String) {
        let currentUser = PFUser.currentUser()
        guard let checkedUser = currentUser else {
            print ("Checked User  is nil")
            return
        }
        
        let phollow = PFObject(className:"Phollow")
        phollow["fromUsername"] = checkedUser.username
        phollow["toUsername"] = toUsername
        phollow.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(toUsername, forKey: "channels")
                currentInstallation.saveInBackground()
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    
    
    func signUp() {
        let username = self.usernameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        let twentyFourHoursSince = NSDate(timeIntervalSinceReferenceDate: -86400.0)
        
        let user = PFUser()
        user.username = username!
        user.password = password!
        user.email = email!
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                print("Error with singup")
                _ = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                self.hideGreenView()
                self.defaults.setValue(twentyFourHoursSince, forKey: "lastSeen")
            }
        }
        
    }
    
    func login() {
        let username = self.usernameField.text
        let password = self.passwordField.text
        PFUser.logInWithUsernameInBackground(username!, password:password!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("successful login")
                self.hideGreenView()
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
        showLoginOrSignupScreen()
    }
    
    func getResetLink() {
        PFUser.requestPasswordResetForEmailInBackground("email@example.com")
    }
    
    func showGreenView() {
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            self.greenView.frame = CGRect(x: 0, y: 0, width: self.screenBounds.width, height: self.screenBounds.height)
            }, completion: { finished in
                print("green screen appears")
                self.logoutButton.hidden = true
                
        })
    }
    
    func hideGreenView() {
        self.usernameField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.logoutButton.hidden = false
        UIView.animateWithDuration(1.5, delay: 1.0, options: .CurveEaseOut, animations: {
            self.greenView.frame = CGRect(x: 0, y: self.screenBounds.height, width: self.screenBounds.width, height: self.screenBounds.height)
            }, completion: { finished in
                print("green screen disappears")
        })
    }
    
    func swipeImageViewOut(imageView: UIImageView) {
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            imageView.frame = CGRect(x: -self.screenBounds.width * 2, y: 0, width: self.screenBounds.width, height: self.screenBounds.height)
            }, completion: { finished in
                print("green screen disappears")
                imageView.removeFromSuperview()
                
        })
    }
    
    func swipeImageViewIn(imageView: UIImageView) {
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            imageView.frame = CGRect(x: -62.5, y: 0, width: self.screenBounds.width + 125, height: self.screenBounds.height)
            }, completion: { finished in
                print("green screen disappears")
                self.delay(2.0) {
                    self.swipeImageViewOut(imageView)
                    //self.defaults.setValue(phlash!["createdAt"], forKey: "lastSeen")
                    self.phlashesArray.removeAtIndex(0)
                }
        })
    }
    
    func swipeTakenPicViewOut(imageView: UIImageView) {
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            imageView.frame = CGRect(x: self.screenBounds.width + 62.5, y: 0, width: self.screenBounds.width, height: self.screenBounds.height)
            }, completion: { finished in
                print("green screen disappears")
                imageView.removeFromSuperview()
                
        })
    }
    
}
