//
//  WebViewController.swift
//  testNewsApp
//
//  Created by ふうたりすと on 2018/02/18.
//  Copyright © 2018年 ふうたりすと. All rights reserved.
//
//戻るボタン指定
//http://yuu.1000quu.com/screen_transition_in_swift
//wkwebview
//https://qiita.com/on0z/items/9768d2bccc29cc4e1851
//autolayout
//https://qiita.com/_ha1f/items/5c292bb6a4617da60d4f

import UIKit
import WebKit // ブラウザ（WKWebView）に必要

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UINavigationControllerDelegate {
    
    var webView: WKWebView!
    //private let refreshControl = UIRefreshControl()
    
    @IBAction func backPage(_ sender: Any) {
        print("back")
        self.dismiss(animated: true, completion: nil)
    }
    override func loadView() {
        super.loadView()
        //let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height))
        //webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //self.view = webView
        self.view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 自身をDelegate委託相手とする。
        navigationController?.delegate = self
        
        
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //print(appDelegate.openUrl)
        let url = URL(string: appDelegate.openUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
        
        //webView.refreshControl = refreshControl
        //refreshControl.addTarget(self, action: #selector(WebViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Webのロード完了後に実行されるメソッド。WKNavigationDelegateのdelegateを通しておくことを忘れないこと
        let title = webView.title
    }
    
    
    //@objc func refresh(sender: UIRefreshControl)
    //{
        // 更新するコード(webView.reload()など)
      //  webView.reload()
    //}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // UINavigationControllerDelegateのメソッド。遷移する直前の処理。
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 遷移先が、ViewControllerだったら……
        if let controller = viewController as? ViewController {
            // AViewControllerのプロパティvalueの値変更。
            controller.value = 100
        }
    }
}
