//
//  ViewController.swift
//  WebViewNativeCommIos
//
//  Created by Hari on 01/02/20.
//  Copyright © 2020 Hari. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController , WKScriptMessageHandler{
    
    @IBOutlet weak var mWebKitView: WKWebView!
    
    @IBOutlet weak var mEdtTxt: UITextField!
    
    
    var mNativeToWebHandler : String = "jsMessageHandler"
    
    var mWebPageName : String = "sampleweb"
    
    var mWebPageExtension : String = "html"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // суда кладете ссылку на вебвью
        let url = URL(string: "https://example.com")!
        let contentController = WKUserContentController()
        
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = wkPreferences
        mWebKitView.load(URLRequest(url: url))
        mWebKitView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // такую функцию вызывает JS код вебвью чтобы передать данные в нативное приложение
        mWebKitView.configuration.userContentController.add(self, name: "testPostMessageManager")

        mWebKitView.configuration.userContentController = contentController
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        // отправляем данные в вебвью через инъекцию JS (postMessage)
        let event = String("test-event")
        let data = """
{
    "payload": "test"
}
"""

        // передача данных из нативного приложения в вебвью - на самом деле вызов функции JS, которую мы инъекцируем через evaluateJavaScript.
        self.mWebKitView.evaluateJavaScript("testInvokeWebView(\"\(event)\", \(data))")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "testPostMessageManager" {
            // перехватываем в нативном приложении данные из вебвью
            print(message.body)
        }
    }
}

