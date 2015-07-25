//
//  LedSequencerViewController.swift
//  KonashiTest
//
//  Created by itog on 7/25/15.
//  Copyright © 2015 pigmal. All rights reserved.
//

import UIKit

class LedSequencerViewController: UIViewController {

    let NUM_BUTTONS = 16
    var buttons:[UIButton] = []
    var selected = 0

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
        }

        let redSlider = UISlider(frame:CGRectMake(20, 400, 280, 20))
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        redSlider.continuous = true
        redSlider.tintColor = UIColor.redColor()
        redSlider.value = 0
        redSlider.addTarget(self, action: "redValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(redSlider)

        let greenSlider = UISlider(frame:CGRectMake(20, 430, 280, 20))
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 255
        greenSlider.continuous = true
        greenSlider.tintColor = UIColor.greenColor()
        greenSlider.value = 0
        greenSlider.addTarget(self, action: "greenValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(greenSlider)

        let blueSlider = UISlider(frame:CGRectMake(20, 460, 280, 20))
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 255
        blueSlider.continuous = true
        blueSlider.tintColor = UIColor.blueColor()
        blueSlider.value = 0
        blueSlider.addTarget(self, action: "blueValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(blueSlider)

        let btn = UIButton()
        btn.frame = CGRectMake(CGFloat(buttonWidth*2 + 5), 500, 200, 40)
        btn.backgroundColor = UIColor.redColor()
        btn.layer.cornerRadius = 10.0
        btn.layer.borderWidth = 2;
        btn.setTitle("Run", forState: UIControlState.Normal)
        btn.addTarget(self, action: "runClicked:", forControlEvents: .TouchUpInside)
        buttons.append(btn)
        self.view.addSubview(btn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClicked(sender:UIButton) {
        print("buttonClickd \(sender.tag)")
        selected = sender.tag
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
        sender.enabled = false
        for btn in buttons {
            let c = CIColor(color:btn.backgroundColor!)
            print("id: \(btn.tag), color: \(c.red) \(c.green) \(c.blue)")
            NSThread.sleepForTimeInterval(1.0)

            let data:[UInt8] = [0xff, 0x01, UInt8(c.red*255), UInt8(c.green*255), UInt8(c.blue*255)];
            sendI2C(data, address: 0x04)
        }
        sender.enabled = true
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
