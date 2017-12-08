//
//  UserReviewViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 11/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class UserReviewViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var lbl_Title: SkyFloatingLabelTextField!
    
    @IBOutlet var tv_Comment: UITextView!
    
    @IBOutlet var starView: CosmosView!
    var rootVC : UIViewController!
    
    init(nibName nibNameOrNil: String, root parentViewController: UIViewController) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self.rootVC = parentViewController
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.viewBorderColor(ContentView: contentView)
        // Do any additional setup after loading the view.
    }
    @IBAction func reviewAction(_ sender: Any) {
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.rootVC.dismiss(animated: true, completion: nil)
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
