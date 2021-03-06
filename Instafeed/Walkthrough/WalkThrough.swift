//
//  WalkThrough.swift
//  Instafeed
//
//  Created by gulam ali on 18/07/19.
//  Copyright © 2019 gulam ali. All rights reserved.
//

import UIKit



class WalkThrough: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var laguageSelectionView: UIView!
    @IBOutlet weak var hindiButton: UIView!
    @IBOutlet weak var englishButton: UIView!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Everyone's Personal Voice", message: "A community-driven space for curating quality information. Now get localized comunity information on your fingertips", imageName: "w1")
        
        let secondPage = Page(title: "For Citizens", message: "Every Citizen wants to uncover reality and share quality information with the community by being anonymous", imageName: "w2")
        
        let thirdPage = Page(title: "For superstar", message: "Your information has a recognition & you get paid for every piece of quality information you share with instafeed Community", imageName: "w3")
        
        let fourthpage = Page(title: "For Brands", message: "Your brand is unheard in the local communities. now get your brand an extra mileage by getting more readers for the information you share.", imageName: "w4")
        
         let fifthpage = Page(title: "News Commerce", message: "Now you can sell the quality information you gather everyday at our mandi & get paid for every authentic information.", imageName: "w5")
        
        
        return [firstPage, secondPage, thirdPage, fourthpage, fifthpage]
    }()
    
    let loginCellId = "loginCellId"
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.pages.count
        return pc
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skiptapped), for: .touchUpInside)
        return button
    }()
    
    @objc func skiptapped(){
        pageControl.currentPage = pages.count - 1
        nextTapped()
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func nextTapped(){
        
        if pageControl.currentPage == pages.count{
            return //we are at last page nd to prevent from crash
        }
        
        if pageControl.currentPage == pages.count - 1{ //at second last page
            skipButton.isHidden = true
            nextButton.isHidden = true
            pageControl.isHidden = true
        }
        
        
        let indexpath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    @IBAction func hindiTapped(_ sender: UIButton) {
        
        UserDefaults.standard.saveData(data: "2", key: "languageId")
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            appDelegate.currentLanguage = "hi"
            UserDefaults.standard.userLoggedIn(value: false)
            //remove all the vc's
            if let vc = appDelegate.window?.topMostController() as? ViewController {
                vc.navigationController?.viewControllers.removeAll()
            }
            
            laguageSelectionView.isHidden = true
            UserDefaults.standard.saveData(data: "1", key: "languageSelection")

            constnt.appDelegate.mainlogin()
        }

    }
    
    @IBAction func englishTapped(_ sender: UIButton) {
        
        UserDefaults.standard.saveData(data: "1", key: "languageId")
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            appDelegate.currentLanguage = "en"
            UserDefaults.standard.userLoggedIn(value: false)
            //remove all the vc's
            if let vc = appDelegate.window?.topMostController() as? ViewController {
                vc.navigationController?.viewControllers.removeAll()
            }
            laguageSelectionView.isHidden = true
            UserDefaults.standard.saveData(data: "1", key: "languageSelection")
            constnt.appDelegate.mainlogin()
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hindiButton.layer.cornerRadius = 75.0
        hindiButton.layer.borderWidth = 2.0
        hindiButton.layer.borderColor = UIColor(hexValue: 0xE94033).cgColor
        
        englishButton.layer.cornerRadius = 75.0
        englishButton.layer.borderWidth = 2.0
        englishButton.layer.borderColor = UIColor(hexValue: 0xE94033).cgColor

        view.addSubview(collectionView)
        
        //use autolayout instead
        collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        registerCells()
        
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
    
        
        skipButtonTopAnchor = skipButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[1]

        nextButtonTopAnchor = nextButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[1]
       
        view.bringSubviewToFront(laguageSelectionView)
        
        if UserDefaults.standard.value(forKey: "languageSelection") != nil {
            laguageSelectionView.isHidden = true
        }
        
    }
    
    

    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == pages.count {
            
            skipButton.isHidden = true
            nextButton.isHidden = true
            pageControl.isHidden = true
            
//            pageControlBottomAnchor?.constant = 40
//            skipButtonTopAnchor?.constant = -80
//            nextButtonTopAnchor?.constant = 80
        } else {
            //back on regular pages
            
            skipButton.isHidden = false
            nextButton.isHidden = false
            pageControl.isHidden = false
            
//            pageControlBottomAnchor?.constant = 0
//            skipButtonTopAnchor?.constant = 0
//            nextButtonTopAnchor?.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count  {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell

            loginCell.delegate = self
            return loginCell

        }

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[indexPath.item]
        cell.page = page
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}


extension WalkThrough : WalkThroughControllerDelegate{
    
    func signIntapped() {
        let move = storyboard?.instantiateViewController(withIdentifier: "startnav") as! startnav
        present(move, animated: true, completion: nil)
    }
    
    
    func GetstaryedTap() {
        //we'll perhaps implement the home controller a little later
//        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        guard let mainNavigationController = rootViewController as? startnav else { return }
//
//        mainNavigationController.viewControllers = [ViewController()]
//
////        UserDefaults.standard.setIsLoggedIn(value: true)
//
//        dismiss(animated: true, completion: nil)
        
        
        let move = storyboard?.instantiateViewController(withIdentifier: "startnav") as! startnav
        present(move, animated: true, completion: nil)
        
    }
    
    
    
    
}

extension UIView {
    
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    
}
