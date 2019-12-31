//
//  CardViewController.swift
//  CollectionView-Note
//
//  Created by zuber on 2018/11/19.
//  Copyright © 2018年 zuber. All rights reserved.
//

import UIKit
import Alamofire

struct DestinyStruct: Codable {
    let id: String
    let nickname: String
    let portrait: String
    
    let age:String?
    let gender:String?
    let region:String?
    let property:String?
    
    let signature:String?
}

class CardViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  var colors: [UIColor] = []
  
  var dataList:[DestinyUserInfo] = []
    
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //设置融云当前用户信息
    let userInfo = UserDefaults()
    let userID = userInfo.string(forKey: "userID")
    
    let parameters: Parameters = ["myid": userID!]
    
    print("缘分")
    
    Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=DestinyList&m=socialchat", method: .post, parameters: parameters).response { response in
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
        }
        if let data = response.data {
            let decoder = JSONDecoder()
            do {
                let jsonModel = try decoder.decode([DestinyStruct].self, from: data)
                for index in 0..<jsonModel.count{
                    let cell = DestinyUserInfo(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait, userNickName: jsonModel[index].nickname,userAge: jsonModel[index].age  ?? "?",userGender: jsonModel[index].gender  ?? "?",userProperty: jsonModel[index].region  ?? "?",userRegion: jsonModel[index].property ?? "?",userSignature: jsonModel[index].signature ?? "?" )
                    self.dataList.append(cell)
                    print("缘分列表数: \(self.dataList.count)")
                }
                self.collectionView.reloadData()
            } catch {
                print("解析 JSON 失败")
            }
        }
    }
    
    
    collectionView.dataSource = self
    colors = DataManager.shared.generalColors(20)
  }
}

// MARK: - UICollectionViewDataSource

extension CardViewController: UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let oneOfList = dataList[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicsCell.reuseID, for: indexPath) as! BasicsCell
    cell.backgroundColor = colors[indexPath.row]
    cell.setData(data: oneOfList)
    return cell
  }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = dataList[indexPath.row].userID
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
  
}
