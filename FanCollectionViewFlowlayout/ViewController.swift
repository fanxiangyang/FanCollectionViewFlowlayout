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
        self.view.backgroundColor=UIColor.white
        configUI();
    }

    /**
     初始化UI界面
     */
    func configUI(){
        self.automaticallyAdjustsScrollViewInsets=false
        let layout=FanCollectionViewFlowlayout();
        layout.naviHeight=20    //一般不设置，默认0即可
        layout.scrollDirection = .vertical//垂直,Horizontal横向
        //横向纵向最小间距(后面有两个代理可以动态改变，所以这里设置无效）
        layout.minimumLineSpacing=3
        layout.minimumInteritemSpacing=0
        fan_collectionView=UICollectionView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50), collectionViewLayout: layout)
        fan_collectionView?.backgroundColor=UIColor.gray
        fan_collectionView?.delegate=self;
        fan_collectionView?.dataSource=self;
        self.view.addSubview(fan_collectionView!)
        //提前注册Cell
        fan_collectionView?.register(UINib(nibName: "FanCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        //提前注册headView
        fan_collectionView?.register(SuppleView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Supple")
        //        fan_collectionView?.registerClass(SuppleView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Supple")
        
        
        let space=(UIScreen.main.bounds.size.width-240)/5
        let titleArr=["宽+20","宽-20","高+20","高-20"]
        for i in 0 ..< 4 {
            let btn=UIButton(type: .custom)
            btn.frame=CGRect(x: space+(space+60)*CGFloat(i), y: 20, width: 60, height: 30)
            print("\(UIScreen.main.bounds.size.width):\(space+(space+50)*CGFloat(i))")
            btn.tag=i
            btn.backgroundColor=UIColor.yellow
            //swift2.2 #selector 新语法，增加类型检查
            btn.addTarget(self, action: #selector(ViewController.btnClick(_:)), for: .touchUpInside)
//            btn.addTarget(self, action: Selector("btnClick:"), forControlEvents: .TouchUpInside)
            btn.setTitle(titleArr[i], for: UIControlState())
            btn.setTitleColor(UIColor.black, for: UIControlState())
            self.view.addSubview(btn)
        }
        
    }
    func btnClick(_ btn:UIButton){
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray[section] as AnyObject).count
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FanCell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FanCell
        let text:String=(dataArray[indexPath.section] as! NSArray)[indexPath.row] as! String;
        cell.userNameLabel.text=text;
        return cell;
    }
    //headView footView 的重用队列类似Cell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let suppleView:SuppleView=collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Supple", for: indexPath) as! SuppleView
        if (kind == UICollectionElementKindSectionHeader) {
            suppleView.backgroundColor=UIColor(white: 0.9, alpha: 1)
            suppleView.titleLabel?.text="第\((indexPath as NSIndexPath).section)分组"
        }else if (kind == UICollectionElementKindSectionFooter){
            suppleView.backgroundColor=UIColor.yellow
        }
        return suppleView
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("您点击了：第\((indexPath as NSIndexPath).section)分组第\((indexPath as NSIndexPath).row)个")
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    //设置所有的cell组成的视图与section 上、左、下、右的间隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 20, 10, 20)
    }
    //设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return CGSizeMake(100, 20)
    //    }
    //反之亦然(当前设置是垂直布局）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 20)//头部布局垂直布局高度有效果
    }
    
    //最小纵向间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //最小横向间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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

