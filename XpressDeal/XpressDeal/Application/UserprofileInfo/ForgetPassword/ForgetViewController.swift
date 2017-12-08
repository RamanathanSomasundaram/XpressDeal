//
//  ForgetViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 07/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var txt_resetEmail: SkyFloatingLabelTextField!
    @IBOutlet var resetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.viewBorderColor(ContentView: contentView)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.height / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.bgView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    //Tap Gesture method
    @objc func handleTap(sender: UITapGestureRecognizer?) {
        // handling code
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetPasswordAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
