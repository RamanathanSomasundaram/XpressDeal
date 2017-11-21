//
//  MenuListViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 09/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController {

    @IBOutlet var tbl_MenuList: UITableView!
    var CategoryName : String!
    var kjtreeInstance: KJTree = KJTree()
    var arrayParents: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CategoryName
        self.navigationController?.navigationItem.hidesBackButton = true
        Utilities.homeNavigationMenu(rootVC:self )
        Utilities.callSideMenu(rootVC: self)
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        tbl_MenuList.tableFooterView = UIView()
         let treeDictionary = commonAppDelegate!.menulistArray.object(forKey: CategoryName) as! NSArray
        let subTree = treeDictionary.object(at: 0) as! NSDictionary
            if let arrayOfParents = subTree.object(forKey: "subcat") as? NSArray {
                arrayParents = arrayOfParents
            }
        
        if let arrayOfParents = arrayParents {
            kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "subcat", idKey: "parent_id")
        }
        tbl_MenuList.reloadData()
        // Do any additional setup after loading the view.
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
extension MenuListViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
    
        let indexTuples = node.index.components(separatedBy: ".")
        let arrayParent = (arrayParents!.object(at: (indexTuples[0] as NSString).integerValue) as! NSDictionary)
        let arrayName = (arrayParent.value(forKey: "subcat") as? NSArray)
        // Return below cell for more internal levels....
        var tableviewcell = tableView.dequeueReusableCell(withIdentifier: "cellidentity")
        if tableviewcell == nil {
            tableviewcell = UITableViewCell(style: .default, reuseIdentifier: "cellidentity")
        }
        // You can return different cells for Parents, childs, subchilds, .... as below.
        if indexTuples.count == 1  || indexTuples.count == 4 {
            // return cell for Parents and subchilds at level 4. (For Level-1 and Internal level-4)
            tableviewcell?.textLabel?.text = (arrayParent.value(forKey: "name") as! String)
            
        }else if indexTuples.count == 2{
            let cellIdentifierChilds = "childCell"
            var cellChild: ListChildTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? ListChildTableViewCell
            if cellChild == nil {
                tableView.register(UINib(nibName: "ListChildTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? ListChildTableViewCell
            }
            cellChild?.childTitle.text = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "name") as! String)
            return cellChild!
            // return cell for Childs of Parents. (Level-2)
        }else if indexTuples.count == 3{
            // return cell for Subchilds of Childs inside Parent. (Level-3)
        }
        let viewButton = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        viewButton.addSubview(imageView)
        if node.state == .open {
            imageView.image = UIImage(named: "minus")
            tableviewcell?.accessoryView = viewButton
        }else if node.state == .close {
            imageView.image = UIImage(named: "plus")
            tableviewcell?.accessoryView = viewButton
        }else{
            tableviewcell?.accessoryView = nil
        }
        tableviewcell?.textLabel?.textColor = UIColor.white
        tableviewcell?.backgroundColor = UIColor.black
        tableviewcell?.selectionStyle = .none
        tbl_MenuList.separatorStyle = .none
        return tableviewcell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        if(indexTuples.count == 2)
        {
            self.CallCategoryClass(CategoryID : node.id)

        }
        else if(indexTuples.count == 3)
        {
            self.CallCategoryClass(CategoryID : node.id)
        }
        else
        {
            self.CallCategoryClass(CategoryID : node.id)

        }
        print(node.index)
        // if you've provided a 'Key'/'Id', you will receive it here.
        print(node.keyIdentity)
        // if you've added any identifier or used indexing format
        print(node.givenIndex)
        
    }
    
    func CallCategoryClass(CategoryID : String)
    {
        let collectionListVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesListViewController") as! CategoriesListViewController
        collectionListVC.categoryID = CategoryID
        self.navigationController?.pushViewController(collectionListVC, animated: true)
    }
}
