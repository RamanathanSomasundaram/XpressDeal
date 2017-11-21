//
//  CategoriesListViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 17/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class CategoriesListViewController: UIViewController {

    @IBOutlet var tbl_CategoryList: UITableView!
    var categoryID : String!
    var categoriesListArray: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesListArray = NSMutableArray()
        self.title = "XpressDeal"
        self.tbl_CategoryList.register(UINib.init(nibName: "DisplayAdTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayCell")
        self.loadCategoriesList()
        tbl_CategoryList.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        // Do any additional setup after loading the view.
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadCategoriesList()
    {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request("http://172.104.181.194/demos/dj/index.php?option=com_djclassifieds&view=items&format=json&cid=\(categoryID!)").responseJSON { response in
                if let json = response.result.value {
                    //print("JSON: \(json)") // serialized json response
                    let jsonResult = ((json as AnyObject).value(forKey: "data")! as! [Any])
                    self.categoriesListArray = NSMutableArray(array: jsonResult)
                }
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    Utilities.callSideMenu(rootVC: self)
                    self.tbl_CategoryList.reloadData()
                    Utilities.hideLoading()
                })
            }
        }
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

extension CategoriesListViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriesListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DisplayAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell") as! DisplayAdTableViewCell
        let dicValues = self.categoriesListArray.object(at: indexPath.row) as! NSDictionary
        cell.backgroundColor = UIColor.black
        cell.configurationCell(dicValues: dicValues)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
