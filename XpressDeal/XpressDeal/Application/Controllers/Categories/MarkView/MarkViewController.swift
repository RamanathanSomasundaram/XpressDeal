//
//  MarkViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 05/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class MarkViewController: UIViewController {

    @IBOutlet var listView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var tbl_Mark: UITableView!
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
        tbl_Mark.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.bgView.addGestureRecognizer(tap)
        listView.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }
    //Tap Gesture method
    @objc func handleTap(sender: UITapGestureRecognizer?) {
        // handling code
        self.dismiss(animated: true, completion: nil)
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
extension MarkViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "MarkCell")
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "MarkCell")
        }
        cell?.backgroundColor = UIColor.black
        cell?.textLabel?.text = "Car"
        cell?.textLabel?.textColor = UIColor.white
        cell?.imageView?.image = UIImage.init(named: "car")
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
