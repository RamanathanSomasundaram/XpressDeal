//
//  CategoriesViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 05/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class MarkCategoriesViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MarkAction(_ sender: Any) {
        let markVC = MarkViewController.init(nibName: "MarkViewController", root: self)
        markVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(markVC, animated: true, completion: nil)
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
