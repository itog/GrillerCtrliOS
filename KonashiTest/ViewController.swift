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
            let vc = LedSequencerViewController.new()
            self.navigationController?.pushViewController(vc, animated: true)
            connectButton.enabled = true;
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
        connectButton.enabled = false;
    }

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBAction func button2Clicked(sender: AnyObject) {
        print("button2Clicked");
    }

    @IBAction func openSequencerClicked(sender: AnyObject) {
        let vc = LedSequencerViewController.new()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func openButtonClicked(sender: AnyObject) {
        let bluetoothViewController = Bluetooth1ViewController.new()
        self.navigationController?.pushViewController(bluetoothViewController, animated: true)
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
}

