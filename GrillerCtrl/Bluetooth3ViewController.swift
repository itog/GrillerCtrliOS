//
//  Bluetooth3ViewController.swift
//

import UIKit
import CoreBluetooth

class Bluetooth3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate,  UITextFieldDelegate{
    
    var myTableView: UITableView!
    var myCharacteristicsUuids: NSMutableArray = NSMutableArray()
    var myCharacteristics: NSMutableArray = NSMutableArray()
    var myTargetPeriperal: CBPeripheral!
    var myService: CBService!
    var myTargetCharacteristics: CBCharacteristic!
    var stopButton: UIButton!
    var rotate1Button: UIButton!
    var rotate2Button: UIButton!
    var rotate3Button: UIButton!
    var rotate4Button: UIButton!


    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成( status barの高さ分ずらして表示 ).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight/2 - barHeight))
        
        // Cellの登録.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定.
        myTableView.dataSource = self
        
        // Delegateを設定.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)

        // tagはそのまま送信データに使う
        stopButton = UIButton()
        stopButton.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 10,100,40)
        stopButton.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        stopButton.layer.masksToBounds = true
        stopButton.setTitle("Stop", forState: UIControlState.Normal)
        stopButton.layer.cornerRadius = 20.0
        stopButton.tag = 0
        stopButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(stopButton)

        rotate1Button = UIButton()
        rotate1Button.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 60,100,40)
        rotate1Button.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        rotate1Button.layer.masksToBounds = true
        rotate1Button.setTitle("Rotate 1", forState: UIControlState.Normal)
        rotate1Button.layer.cornerRadius = 20.0
        rotate1Button.tag = 2
        rotate1Button.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(rotate1Button)

        rotate2Button = UIButton()
        rotate2Button.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 110,100,40)
        rotate2Button.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        rotate2Button.layer.masksToBounds = true
        rotate2Button.setTitle("Rotate 2", forState: UIControlState.Normal)
        rotate2Button.layer.cornerRadius = 20.0
        rotate2Button.tag = 3
        rotate2Button.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(rotate2Button)

        rotate3Button = UIButton()
        rotate3Button.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 160,100,40)
        rotate3Button.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        rotate3Button.layer.masksToBounds = true
        rotate3Button.setTitle("Rotate ", forState: UIControlState.Normal)
        rotate3Button.layer.cornerRadius = 20.0
        rotate3Button.tag = 4
        rotate3Button.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(rotate3Button)

        rotate4Button = UIButton()
        rotate4Button.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 210,100,40)
        rotate4Button.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        rotate4Button.layer.masksToBounds = true
        rotate4Button.setTitle("Rotate 4", forState: UIControlState.Normal)
        rotate4Button.layer.cornerRadius = 20.0
        rotate4Button.tag = 5
        rotate4Button.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(rotate4Button)
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
    func setService(service: CBService) {
        
        self.myService = service
        print(service)
    }
    
    /*
    Charactaristicsの検索
    */
    func searchCharacteristics(){
        
        print("searchService")
        self.myTargetPeriperal.delegate = self
        self.myTargetPeriperal.discoverCharacteristics(nil, forService: self.myService)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!,
        error: NSError!) {
            print("didDiscoverCharacteristicsForService")
            
            for characteristics in service.characteristics ?? [] {
                myCharacteristicsUuids.addObject(characteristics.UUID)
                myCharacteristics.addObject(characteristics)
            }
            
            myTableView.reloadData()
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("CharactaristicsUuid: \(myCharacteristicsUuids[indexPath.row])")
        myTargetCharacteristics = myCharacteristics[indexPath.row] as! CBCharacteristic
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCharacteristicsUuids.count
        
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.textLabel!.text = "\(myCharacteristicsUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        // Cellに値を設定(下).
        cell.detailTextLabel!.text = "Characteristics"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        
        return cell
        
    }
    
    
    /*
    ボタンイベント.
    */
    func onClickMyButton(sender: UIButton){
        print("onClickMyButton:")
        print("sender.currentTitile: \(sender.currentTitle)")
        print("sender.tag:\(sender.tag)")
        
        if(self.myTargetCharacteristics != nil){
            print("write")

            var data:UInt8 = UInt8(sender.tag)
            let payload = NSData(bytes: &data, length: 1)

            self.myTargetPeriperal.writeValue(payload, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
        }
    }

    
    /*
    Write
    */
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!)
    {
        print("Success")
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForDescriptor descriptor: CBDescriptor!, error: NSError!) {
        print("Success")
        
    }
}
