//
//  ViewController.swift
//  WebViewExample
//
//  Created by ElectronicArmory on 10/7/17.
//  Copyright © 2017 Electronic Armory. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var noConnectionVew: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        urlTextField.delegate = self
        webView.navigationDelegate = self
        noConnectionVew.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do {
                try self.reachability.startNotifier()
                        print("Notifier Started")
                } catch {
                    print("Unable to start notifier")
                }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        let urlString:String = "https://www.ElectronicArmory.com"
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        urlTextField.text = urlString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        <#code#>
//    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        urlTextField.text = webView.url?.absoluteString
    }
    
    @objc func reachabilityChanged(note: Notification) {

          let reachability = note.object as! Reachability

          switch reachability.connection {
          case .wifi:
              print("Reachable via WiFi Connection")
                noConnectionVew.isHidden = true
          case .cellular:
              print("Reachable via Cellular Connection")
          case .unavailable:
            print("Network not reachable")
            noConnectionVew.isHidden = false
          }
        }
    
    deinit{
            reachability.stopNotifier()
        }
    
    

}

