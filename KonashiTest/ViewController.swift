//
//  ViewController.swift
//  KonashiTest
//
//  Created by Yuan Ito on 7/12/15.
//  Copyright © 2015 pigmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Konashi.initialize()

        // readyじゃなくてconnectedのタイミングで来てるっぽい
        Konashi.addObserver(self, selector:"ready", name: KonashiEventReadyToUseNotification)

        //イベント来ない
        Konashi.shared().connectedHandler = {() -> Void in
            print("Connected to Konashi \(Konashi.softwareRevisionString())");
        }
        Konashi.shared().readyHandler = {() -> Void in
            print("Ready to use Konashi \(Konashi.softwareRevisionString())");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(sender: AnyObject) {
        print("hello swift");
        Konashi.find()
    }

    @IBAction func readButtonClicked(sender: AnyObject) {
        print("Connected to Konashi \(Konashi.softwareRevisionString())");
        blinkLed()
//        print("clicked")
//        if Konashi.isConnected() {
//            let value = Konashi.digitalRead(KonashiDigitalIOPin.DigitalIO0);
//            print ("level = \(value)")
//            
//            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.High)
//            Konashi.digitalWrite(KonashiDigitalIOPin.LED3, value: KonashiLevel.High)
//            Konashi.digitalWrite(KonashiDigitalIOPin.LED4, value: KonashiLevel.High)
//        }
    }

    internal func ready() {
        print("ready")
        if Konashi.isConnected() {
            print("Connected to Konashi \(Konashi.softwareRevisionString())");
        }
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
}

