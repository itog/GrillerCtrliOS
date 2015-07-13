//
//  BluetoothViewController.swift
//  KonashiTest
//
//  Created by Yuan Ito on 7/13/15.
//  Copyright © 2015 pigmal. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()

        // Do any additional setup after loading the view.
        print("loaded BluetoothViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMainLabel(text:String) {
//        label.text = text
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
