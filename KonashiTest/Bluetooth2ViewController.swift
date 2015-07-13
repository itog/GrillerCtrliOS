//
//  Bluetooth2ViewController.swift
//

import UIKit
import CoreBluetooth

class Bluetooth2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate{
    
    var myTableView: UITableView!
    var myServiceUuids: NSMutableArray = NSMutableArray()
    var myService: NSMutableArray = NSMutableArray()
    var myButtonBefore: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myCentralManager: CBCentralManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blueColor()
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成( status barの高さ分ずらして表示 ).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        // Cellの登録.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定.
        myTableView.dataSource = self
        
        // Delegateを設定.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
    }
    
    /*
    接続先のPeripheralを設定
    */
    func setPeripheral(target: CBPeripheral) {
        
        self.myTargetPeriperal = target
        
        print(target)
        
    }
    
    /*
    CentralManagerを設定
    */
    func setCentralManager(manager: CBCentralManager) {
        
        self.myCentralManager = manager
        print(manager)
    }
    
    /*
    Serviceの検索
    */
    func searchService(){
        
        print("searchService")
        self.myTargetPeriperal.delegate = self
        self.myTargetPeriperal.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        print("didDiscoverServices")
        for service in peripheral.services ?? [] {
            myServiceUuids.addObject(service.UUID)
            myService.addObject(service)
            print("P: \(peripheral.name) - Discovered service S:'\(service.UUID)'")
        }
        
        myTableView.reloadData()
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("ServiceUuid: \(myServiceUuids[indexPath.row])")
        
        // 遷移するViewを定義する.
        let myThirdViewController: Bluetooth3ViewController = Bluetooth3ViewController()
        myThirdViewController.setPeripheral(self.myTargetPeriperal)
        myThirdViewController.setService(self.myService[indexPath.row] as! CBService)
        myThirdViewController.searchCharacteristics()
        
        // アニメーションを設定する.
        myThirdViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        print(self.navigationController)
        // Viewの移動する.
        self.navigationController?.pushViewController(myThirdViewController, animated: true)
        
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myServiceUuids.count
        
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myServiceUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        // Cellに値を設定(下).
        cell.detailTextLabel!.text = "Service"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        
        return cell
        
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            self.myCentralManager.cancelPeripheralConnection(self.myTargetPeriperal)
        }
    }
    
}