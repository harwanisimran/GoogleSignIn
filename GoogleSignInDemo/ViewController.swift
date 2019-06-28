//
//  ViewController.swift
//  GoogleSignInDemo
//
//  Created by webwerks on 21/06/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
  
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGoogleSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        btnGoogleSignIn.addTarget(self, action: #selector(signinUserWithGoogle(_:)), for: .touchUpInside)
    }

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
}

