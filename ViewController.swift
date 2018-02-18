//
//  ViewController.swift
//  testNewsApp
//
//  Created by ふうたりすと on 2018/02/13.
//  Copyright © 2018年 ふうたりすと. All rights reserved.
//
//試しにコメントのみ変更
//tableview ↓
//http://docs.fabo.io/swift/uikit/006_uitableview.html
//StoryBoardのViewControllerをインスタンス化する
//https://qiita.com/midori004/items/4a67dc70af582aa91eec


import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    var value: Int = 0 {
        didSet {
            print("New value = \(value)")
        }
    }
    // プロパティオブザーバにする必要はないが、Delegateメソッドが働いていることを確認するため実装しています。
    
    // Other codes
    
    
    // Tableで使用する配列を設定する
    //private let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    private var myItems:[[String:String]] = [
        ["name":"yahoo" , "url":"https://www.yahoo.co.jp/"],
        ["name":"google" , "url":"https://www.google.co.jp/"]
    ]
    private var myTableView: UITableView!
    
    
    var pageMenuController: PMKPageMenuController? = nil
    
    override func setup() {
        super.setup()
        
        self.title = "PageMenuKit Frameworks"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllers: [UIViewController] = []
        let dateFormatter = DateFormatter()
        for month in dateFormatter.monthSymbols {
            let viewController: DataViewController = DataViewController()
            viewController.title = month
            controllers.append(viewController)
        }
        
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        /*
         * Available menuStyles:
         * .Plain, .Tab, .Smart, .Hacka, .Ellipse, .Web, .Suite, .NetLab, .NHK
         * See PMKPageMenuItem.swift in PageMenuKit folder.
         * "menuColors: []" means that we will use the default colors.
         */
        pageMenuController = PMKPageMenuController(controllers: controllers, menuStyle: .Smart, menuColors: [], topBarHeight: statusBarHeight)
        //    pageMenuController = PMKPageMenuController(controllers: controllers, menuStyle: .Plain, menuColors: [.purple], topBarHeight: statusBarHeight)
        pageMenuController?.delegate = self
        self.addChildViewController(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParentViewController: self)
        
        
        
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + statusBarHeight*2
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        
        // Cell名の登録をおこなう.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Num: \(indexPath.row)")
        //print("Value: \(myItems[indexPath.row])")
        print("Value: " + myItems[indexPath.row]["url"]!)
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openUrl = myItems[indexPath.row]["url"]!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        present(nextView, animated: true, completion: nil)
        //let storyboard: UIStoryboard = UIStoryboard(name: "WebViewController", bundle: nil)
        //let nextView = storyboard.instantiateInitialViewController()
        //present(nextView!, animated: true, completion: nil)
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Cellに値を設定する.
        //cell.textLabel!.text = "\(myItems[indexPath.row])"
        //cell.textLabel!.text = myItems[indexPath.row].name
        //let celllabel = myItems[indexPath.row]
        //cell.textLabel!.text = celllabel["name"]
        cell.textLabel!.text = myItems[indexPath.row]["name"]
        
        return cell
    }
}

extension ViewController: PMKPageMenuControllerDelegate
{
    func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didPrepare menuItems: [PMKPageMenuItem]) {
        // XXX: For .Hacka style
        var i: Int = 1
        for item: PMKPageMenuItem in menuItems {
            item.badgeValue = String(format: "%zd", i)
            i += 1
        }
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didSelect menuItem: PMKPageMenuItem, at menuIndex: Int) {
        menuItem.badgeValue = nil // XXX: For .Hacka style
    }
}
