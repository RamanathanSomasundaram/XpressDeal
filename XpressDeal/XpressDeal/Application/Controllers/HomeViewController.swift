//
//  ViewController.swift
//  XpressDeal
//
//  Created by Lakeba_Adminstrator on 04/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet var searchBarControl: UISearchBar!
    @IBOutlet var listCollectionView: UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var searchBarBool : Bool = false
    var categoriesListArray: NSMutableArray!
    var isFiltered : Bool = false
    var arrayForSearchFiles : NSMutableArray!
    var searchString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.loadCategoriesList(URLString: CategoriesListAPI)
        self.listCollectionView.register(UINib.init(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categorieCell")
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        categoriesListArray = NSMutableArray()
        //self.revealViewController().delegate = self
        //self.setupNavigationController()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationController()
        searchBarTopConstraint.constant = -80
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchBarCancelButtonClicked(searchBarControl)
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        let size1 = Utilities.collectionViewCellWidth()
        collectionViewFlowLayout.itemSize = CGSize(width: size1, height: size1)
        collectionViewFlowLayout.minimumLineSpacing = 1
        collectionViewFlowLayout.minimumInteritemSpacing = 1
        collectionViewFlowLayout.scrollDirection = .vertical
        self.listCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    //Navigation controller setup
    func setupNavigationController()
    {
        Utilities.homeNavigationMenu(rootVC: self)
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        if(UserDefaults.standard.bool(forKey: "UserLogin"))
        {
            let container = UIView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            let UserProfile = UIButton.init(frame: CGRect(x: 0, y: 4, width: 30, height: 30))
            let img = UIImage (named: "user")
            UserProfile .setImage(img, for: .normal)
            UserProfile.addTarget(self, action: #selector(profileView), for: .touchUpInside)
            container.addSubview(UserProfile)
            let searchButton=UIButton.init(frame: CGRect(x: 40, y: 4, width: 30, height: 30))
            let imag = UIImage(named: "search.png")
            searchButton .setImage(imag, for: .normal)
            searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
            container.addSubview(searchButton)
            container .layoutIfNeeded()
            container.backgroundColor = UIColor.clear
            let item = UIBarButtonItem.init(customView: container)
            let arrBtns = NSArray.init(object: item)
            self.navigationItem.rightBarButtonItems=(arrBtns as! [UIBarButtonItem])
            
        }
        else
        {
            let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "search.png"), style: .plain, target: self, action: #selector(search))
            flipRightButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = flipRightButton
        }
        
    }

    @objc func leftMenuAction()
    {
         present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @objc func profileView()
    {
        UserDefaults.standard.set(false, forKey: "menu")
        UserDefaults.standard.synchronize()
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    func loadCategoriesList(URLString : String)    {
        if(Utilities.checkForInternet())
        {
        Utilities.showLoading()
        Alamofire.request(URLString).responseJSON { response in
            if let json = response.result.value {
                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! [Any])
                self.categoriesListArray = NSMutableArray(array: jsonResult)
                commonAppDelegate.categoriesListArray = self.categoriesListArray
            }
            let dispatchTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                Utilities.callSideMenu(rootVC: self)
                self.listCollectionView.reloadData()
                Utilities.hideLoading()
            })
        }
        }
    }
    
    //SearchController actions
    @objc func search()
    {
        if(!searchBarBool)
        {
            searchBarBool = true
            searchBarTopConstraint.constant = 0
            searchBarControl.showsCancelButton = true
            searchBarControl.delegate = self
            searchBarControl.returnKeyType = .search
            searchBarControl.becomeFirstResponder()
        }
        else
        {
            searchBarBool = false
            searchBarTopConstraint.constant = -80
            searchBarControl.resignFirstResponder()
            searchBarControl.text = ""
        }
    }
    
    @IBAction func AdvanceSearchAction(_ sender: Any) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//UIcollectionView Datasource and delegate methods
extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isFiltered)
        {
            return arrayForSearchFiles.count
        }
        else
        {
        return categoriesListArray.count
        }

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoriesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorieCell", for: indexPath) as! CategoriesCollectionViewCell
        var dictValues : NSDictionary!
        if(isFiltered)
        {
            dictValues = self.arrayForSearchFiles.object(at: indexPath.row) as! NSDictionary
            for subview: UIView in (cell.contentView.subviews){
                if (subview is UIButton) {
                    subview.removeFromSuperview()
                }
            }
        }
        else
        {
           dictValues = self.categoriesListArray.object(at: indexPath.row) as! NSDictionary
        }
        cell.configurationCell(dicValues: dictValues)
        cell.setNeedsDisplay()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicSelected : NSDictionary!
        if(isFiltered)
        {
            dicSelected = self.arrayForSearchFiles.object(at: indexPath.row) as! NSDictionary
        }
        else
        {
            dicSelected = self.categoriesListArray.object(at: indexPath.row) as! NSDictionary
        }
        let categoryClass = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesListViewController") as! CategoriesListViewController
        categoryClass.categoryID = (dicSelected.value(forKey: "id") as! String)
        self.navigationController?.pushViewController(categoryClass, animated: true)
        
    }
    
    
}
//SearchBar controller delegate
extension HomeViewController : UISearchBarDelegate{
    //MARK: - user click on the search icon to search the items in the tables list
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarControl.resignFirstResponder()
        self.listCollectionView.reloadData()
        //self.searchBarController.endEditing(true)
    }
    // user can change the text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            // searchBar.resignFirstResponder()
            //searchBarController.resignFirstResponder()
            isFiltered = false
            self.listCollectionView.reloadData()
            searchString = ""
        }
        else {
            arrayForSearchFiles = NSMutableArray()
            searchString = searchText
            for i in 0 ..< categoriesListArray.count
            {
                let rec = categoriesListArray.object(at: i) as! NSDictionary
                let finalName = (rec.value(forKey: "name") as! String)
                let stringMatch = finalName.lowercased().range(of:searchText.lowercased())
                if(stringMatch != nil)
                {
                    let dicAudioTypeDetails = rec
                    arrayForSearchFiles.add(dicAudioTypeDetails)
                }
                else
                {
                }
                
            }
            isFiltered = true
            self.listCollectionView.reloadData()
        }

    }
    
    // user finished editing the search text
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarControl.resignFirstResponder()

    }
    
    // Search bar cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarControl.resignFirstResponder()
        searchBar.text = ""
        searchBarBool = false
        searchBarTopConstraint.constant = -80
        isFiltered = false
        self.searchBarControl.endEditing(true)
        self.listCollectionView.reloadData()
    }
}

//Slidemenu 
extension HomeViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        //print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        //print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        //print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        //print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}

