//
//  ViewController.swift
//  KonashiTest
//
//  Created by Yuan Ito on 7/12/15.
//  Copyright © 2015 pigmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        Konashi.initialize()

//        Konashi.addObserver(self, selector:"connecting", name: KonashiEventConnectingNotification)
//        Konashi.addObserver(self, selector:"connected", name: KonashiEventConnectedNotification)
//        // readyじゃなくてconnectedのタイミングで来てるっぽい
        Konashi.addObserver(self, selector:"ready", name: KonashiEventReadyToUseNotification)
        
        //イベント来ない
        Konashi.shared().connectedHandler = {() -> Void in
            print("Connected to Konashi \(Konashi.softwareRevisionString())");
        }
        Konashi.shared().readyHandler = {() -> Void in
            print("Ready to use Konashi \(Konashi.softwareRevisionString())");
        }
    }

    func checkKonashi() {
        print("checking if Konashi is connected")
        if Konashi.isReady() {
            self.statusLabel.text = "Ready";
        } else {
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkKonashi", userInfo: nil, repeats: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(sender: AnyObject) {
        Konashi.reset()
        Konashi.find()
    }

    @IBAction func checkButtonClicked(sender: AnyObject) {
        if Konashi.isReady() {
            statusLabel.text = "Ready";
            print("Konashi: \(Konashi.softwareRevisionString())");
        } else {
            statusLabel.text = "Not ready";
        }
    }

    @IBAction func doButtonClicked(sender: AnyObject) {
        blinkLed()
    }

    @IBAction func i2cButtonClicked(sender: AnyObject) {
        let data:[UInt8] = [0xff, 0x01, 0xff, 0x00, 0xff];
        sendI2C(data, address: 0x04)
    }

    @IBAction func openButtonClicked(sender: AnyObject) {
        let bluetoothViewController = Bluetooth1ViewController.new()
        self.navigationController?.pushViewController(bluetoothViewController, animated: true)

//        let storyboard = UIStoryboard(name: "Bluetooth", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! BluetoothViewController
//        self.presentViewController(vc, animated: true, completion: nil)
    }

    internal func connecting() {
        print("connecting")
    }

    internal func connected() {
        print("connected")
    }

    internal func ready() {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkKonashi", userInfo: nil, repeats: false)
    }

    func initPins() {
        Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.Output)
    }

    func blinkLed() {
        // Drive LED
        Konashi.pwmMode(KonashiDigitalIOPin.LED2, mode: KonashiPWMMode.EnableLED)
        
        //Blink LED (interval: 0.5s)
        Konashi.pwmPeriod(KonashiDigitalIOPin.LED2, period:1000000)   // 1.0s
        Konashi.pwmDuty(KonashiDigitalIOPin.LED2, duty:500000)       // 0.5s
        Konashi.pwmMode(KonashiDigitalIOPin.LED2, mode:KonashiPWMMode.Enable)
    }

    func sendI2C(data:[UInt8], address: UInt8) {
        let size = data.count
        let dataPointer = UnsafeMutablePointer<UInt8>.alloc(size)
        for i in 0..<size {
            dataPointer[i] = data[i]
        }

        Konashi.i2cMode(KonashiI2CMode.Enable400K)
        Konashi.i2cStartCondition()
        Konashi.i2cWrite(Int32(size), data: dataPointer, address: address)
        NSThread.sleepForTimeInterval(0.01)
        Konashi.i2cStopCondition()
        NSThread.sleepForTimeInterval(0.02)
    }

}

