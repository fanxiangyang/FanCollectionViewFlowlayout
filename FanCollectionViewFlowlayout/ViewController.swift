//
//  ViewController.swift
//  FanCollectionViewFlowlayout
//
//  Created by 向阳凡 on 16/3/28.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var cellHeight:CGFloat=150.0,cellWidth:CGFloat=200.0
    
    var fan_collectionView:UICollectionView?
    var dataArray:NSMutableArray=[["小五","王杰","小明","小红","小亮"],["iOS","android","WPhone"],["section1","section2"]];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor=UIColor.whiteColor()
        configUI();
    }

    /**
     初始化UI界面
     */
    func configUI(){
        self.automaticallyAdjustsScrollViewInsets=false
        let layout=FanCollectionViewFlowlayout();
        layout.naviHeight=20    //一般不设置，默认0即可
        layout.scrollDirection = .Vertical//垂直,Horizontal横向
        //横向纵向最小间距(后面有两个代理可以动态改变，所以这里设置无效）
        layout.minimumLineSpacing=3
        layout.minimumInteritemSpacing=0
        fan_collectionView=UICollectionView(frame: CGRectMake(0, 50, CGRectGetWidth( self.view.frame), CGRectGetHeight(self.view.frame)-50), collectionViewLayout: layout)
        fan_collectionView?.backgroundColor=UIColor.grayColor()
        fan_collectionView?.delegate=self;
        fan_collectionView?.dataSource=self;
        self.view.addSubview(fan_collectionView!)
        //提前注册Cell
        fan_collectionView?.registerNib(UINib(nibName: "FanCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        //提前注册headView
        fan_collectionView?.registerClass(SuppleView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Supple")
        //        fan_collectionView?.registerClass(SuppleView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Supple")
        
        
        let space=(UIScreen.mainScreen().bounds.size.width-240)/5
        let titleArr=["宽+20","宽-20","高+20","高-20"]
        //TODO: for(i in 0 ..< 4) swift3.0
        for(var i=0;i<4;i++){
            let btn=UIButton(type: .Custom)
            btn.frame=CGRectMake(space+(space+60)*CGFloat(i), 20, 60, 30)
            print("\(UIScreen.mainScreen().bounds.size.width):\(space+(space+50)*CGFloat(i))")
            btn.tag=i
            btn.backgroundColor=UIColor.yellowColor()
            //swift2.2 #selector 新语法，增加类型检查
            btn.addTarget(self, action: #selector(ViewController.btnClick(_:)), forControlEvents: .TouchUpInside)
//            btn.addTarget(self, action: Selector("btnClick:"), forControlEvents: .TouchUpInside)
            btn.setTitle(titleArr[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.view.addSubview(btn)
        }
        
    }
    func btnClick(btn:UIButton){
        switch btn.tag{
        case 0:
            cellWidth+=20.0
            break
        case 1:
            cellWidth-=20.0
            break
        case 2:
            cellHeight+=20.0
            break
        case 3:
            cellHeight-=20.0
            break
        default:
            break
        }
        fan_collectionView?.reloadData()
    }
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    //cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:FanCell=collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FanCell
        cell.userNameLabel.text=dataArray[indexPath.section][indexPath.row] as? String
        return cell;
    }
    //headView footView 的重用队列类似Cell
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let suppleView:SuppleView=collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Supple", forIndexPath: indexPath) as! SuppleView
        if (kind == UICollectionElementKindSectionHeader) {
            suppleView.backgroundColor=UIColor(white: 0.9, alpha: 1)
            suppleView.titleLabel?.text="第\(indexPath.section)分组"
        }else if (kind == UICollectionElementKindSectionFooter){
            suppleView.backgroundColor=UIColor.yellowColor()
        }
        return suppleView
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("您点击了：第\(indexPath.section)分组第\(indexPath.row)个")
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth, cellHeight)
    }
    //设置所有的cell组成的视图与section 上、左、下、右的间隔
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 20, 10, 20)
    }
    //设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return CGSizeMake(100, 20)
    //    }
    //反之亦然(当前设置是垂直布局）
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(100, 20)//头部布局垂直布局高度有效果
    }
    
    //最小纵向间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    //最小横向间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 12
    }
    //MARK: - 其他
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        configUI()
    //    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

