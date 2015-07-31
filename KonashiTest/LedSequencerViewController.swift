//
//  LedSequencerViewController.swift
//  KonashiTest
//
//  Created by itog on 7/25/15.
//  Copyright © 2015 pigmal. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class LedSequencerViewController: UIViewController {

    let NUM_BUTTONS = 16
    var buttons:[UIButton] = []
    var selected = 0
    var redSlider:UISlider! = nil
    var greenSlider:UISlider! = nil
    var blueSlider:UISlider! = nil
    var running = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        let buttonWidth = Int(self.view.frame.width) / 4;
        for i in 0..<NUM_BUTTONS {
            let btn = UIButton()
            btn.tag = i

            btn.frame = CGRectMake(CGFloat(buttonWidth*(i%4) + 5), CGFloat(100+i/4*50), CGFloat(buttonWidth) - 10, 40)
            switch i % 4 {
            case 0:
                btn.backgroundColor = UIColor(colorLiteralRed: 0xff, green: 0, blue: 0, alpha: 1)

            case 1:
                btn.backgroundColor = UIColor(colorLiteralRed: 0, green: 0xff, blue: 0, alpha: 1)

            case 2:
                btn.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0xff, alpha: 1)

            default:
                btn.backgroundColor = UIColor(colorLiteralRed: 0xff, green: 0xff, blue: 0xff, alpha: 1)
            }
            btn.layer.cornerRadius = 10.0
            btn.layer.borderWidth = 2;
            btn.setTitle("button", forState: UIControlState.Normal)
            btn.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            buttons.append(btn)
            self.view.addSubview(btn)

            prepareSound()
        }

        let SLIDER_Y:CGFloat = 320;
        redSlider = UISlider(frame:CGRectMake(20, SLIDER_Y, 280, 20))
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        redSlider.continuous = true
        redSlider.tintColor = UIColor.redColor()
        redSlider.value = 0
        redSlider.addTarget(self, action: "redValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(redSlider)

        greenSlider = UISlider(frame:CGRectMake(20, SLIDER_Y + 40, 280, 20))
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 255
        greenSlider.continuous = true
        greenSlider.tintColor = UIColor.greenColor()
        greenSlider.value = 0
        greenSlider.addTarget(self, action: "greenValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(greenSlider)

        blueSlider = UISlider(frame:CGRectMake(20, SLIDER_Y + 80, 280, 20))
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 255
        blueSlider.continuous = true
        blueSlider.tintColor = UIColor.blueColor()
        blueSlider.value = 0
        blueSlider.addTarget(self, action: "blueValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(blueSlider)

        let btn1 = UIButton()
        btn1.frame = CGRectMake(0, 0, 80, 40)
        btn1.backgroundColor = UIColor.redColor()
        btn1.layer.cornerRadius = 10.0
        btn1.layer.borderWidth = 2;
        btn1.layer.position = CGPoint(x: self.view.frame.width - btn1.frame.width, y: SLIDER_Y + 130)
        btn1.setTitle("Check", forState: UIControlState.Normal)
        btn1.addTarget(self, action: "sendClicked:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)

        let btn = UIButton()
        btn.frame = CGRectMake(0, 0, 200, 40)
        btn.backgroundColor = UIColor.redColor()
        btn.layer.cornerRadius = 10.0
        btn.layer.borderWidth = 2;
        btn.layer.position = CGPoint(x: self.view.frame.width/2 + 20, y:self.view.frame.height-50)
        btn.setTitle("Run", forState: UIControlState.Normal)
        btn.addTarget(self, action: "runClicked:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)

        // Swicthを作成する.
        mySwicth.layer.position = CGPoint(x: 40, y: self.view.frame.height - 50)
//        mySwicth.tintColor = UIColor.blackColor()
//        mySwicth.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(mySwicth)
    }
    let mySwicth: UISwitch = UISwitch()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClicked(sender:UIButton) {
        print("buttonClickd \(sender.tag)")
        selected = sender.tag
        sender.backgroundColor = UIColor(red:CGFloat(redSlider.value/255), green:CGFloat(greenSlider.value/255), blue:CGFloat(blueSlider.value/255), alpha:CGFloat(1))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func redValueDidChange(sender:UISlider!) {
        let c = CIColor(color: buttons[selected].backgroundColor!)
        buttons[selected].backgroundColor = UIColor(colorLiteralRed:sender.value/255, green:Float(c.green), blue:Float(c.blue), alpha:Float(1))
    }

    func greenValueDidChange(sender:UISlider!) {
        let c = CIColor(color: buttons[selected].backgroundColor!)
        buttons[selected].backgroundColor = UIColor(colorLiteralRed:Float(c.red), green:Float(sender.value/255), blue:Float(c.blue), alpha:Float(1))
    }

    func blueValueDidChange(sender:UISlider!) {
        let c = CIColor(color: buttons[selected].backgroundColor!)
        buttons[selected].backgroundColor = UIColor(colorLiteralRed:Float(c.red), green:Float(c.green), blue:Float(sender.value/255), alpha:Float(1))
    }

    func runClicked(sender:UIButton) {
        if running {
            print("runnning")
        } else {
            running = true
            playSequenceAsync()
        }
        print("hoge")
    }

    func playSequenceAsync() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            repeat {
                self.playSequence()
            } while self.mySwicth.on
            self.running = false
        })
    }

    func playSequence() {
        for btn in buttons {
            let c = CIColor(color:btn.backgroundColor!)
            print("id: \(btn.tag), color: \(c.red) \(c.green) \(c.blue)")
            NSThread.sleepForTimeInterval(1.0)

            let data:[UInt8] = [0xff, 0x01, UInt8(c.red*255), UInt8(c.green*255), UInt8(c.blue*255)];
            sendI2C(data, address: 0x04)
            AudioServicesPlaySystemSound(soundIdRing)
            }
    }

    func sendClicked(sender:UIButton) {
        //        let data:[UInt8] = [0xff, 0x01, 0xff, 0x00, 0xff];
        let r:UInt8 = UInt8(redSlider.value)
        let g:UInt8 = UInt8(greenSlider.value)
        let b:UInt8 = UInt8(blueSlider.value)

        let data:[UInt8] = [0xff, 0x01, r, g, b];
        sendI2C(data, address: 0x04)
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

    var player : AVAudioPlayer! = nil
    var soundIdRing:SystemSoundID = 0

    func prepareSound() {
//        let path = NSBundle.mainBundle().pathForResource("se_maoudamashii_system46", ofType:"mp3")
//        let fileURL = NSURL(fileURLWithPath: path!)
//        do {
//            try player = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
//        } catch {
//            print("Error to create player")
//        }
//        player.prepareToPlay()
//        //        player.delegate = self

        let path = NSBundle.mainBundle().pathForResource("se_maoudamashii_system46", ofType:"wav")
        let soundUrl = NSURL(fileURLWithPath: path!) //"/System/Library/Audio/UISounds/new-mail.caf")
        AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
    }
}
