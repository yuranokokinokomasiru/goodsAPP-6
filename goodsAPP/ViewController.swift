//
//  ViewController.swift
//  goodsAPP
//
//  Created by cl_umeda_001 on 2021/10/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    
    
    @IBOutlet var table: UITableView!
    var isFirstAppear = true
    
    var cellNum:Int! // 選択されたcellのNumberを入れる変数
    var imageNameArray = [NSData]() // グッズの画像を入れる配列
    
    var saveData = UserDefaults.standard
    var goodArray = [GoodsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults内のデータリセット
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        table.dataSource = self
        table.delegate = self
        
        // まだUserDefaultsにデータが何も保存されていない時以外は、UserDefaultsの各データをフィールドの変数に代入する
        if(saveData.object(forKey: "udNumArray") != nil){
            // UserDefaultsに保存されているデータを取得して、フィールド変数に代入する
            let jsonDecoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: udGoodArrayKey),
                  let decodeData = try? jsonDecoder.decode([GoodsData].self, from: data) else {
                return
            }
            goodArray = decodeData
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            isFirstAppear = false
            return
        }
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: udGoodArrayKey),
              let decodeData = try? jsonDecoder.decode([GoodsData].self, from: data) else {
            return
        }
        goodArray = decodeData
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
//
//        return cell
//    }
//
//    //値持たせて画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // StoryBoardのidentifierに名前つけて判別してる
        if segue.identifier == "toHensyu" {
            if let indexPath = table.indexPathForSelectedRow {
                let hensyuVC = segue.destination as! hensyuViewController
                //            hensyuVC.gNameArray = gNameArray // 選択されたグッズの配列を編集Viewに教える
                //            hensyuVC.numArray = numArray // 選択されたグッズの配列を編集Viewに教え
                //            print(cellNum)
                hensyuVC.cellNum = cellNum // 選択されたCellのNumberを編集Viewに教える
                //            hensyuVC.imageNameArray = imageNameArray // 選択されたグッズの配列を編集Viewに教える
                //            hensyuVC.table = table // テーブルの情報更新するためにtableを編集Viewに教える
            } else if segue.identifier == "toAdd" {
                let addVC = segue.destination as! AddCellViewController
                //            addVC.gNameArray = gNameArray // 選択されたグッズの配列を追加Viewに教える
                //            addVC.numArray = numArray // 選択されたグッズの配列を追加Viewに教える
                addVC.cellNum = cellNum // 選択されたCellのNumberを追加Viewに教える
                //            addVC.imageNameArray = imageNameArray // 選択されたグッズの配列を追加Viewに教える
                
            }
        }
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // 保存されているgNameArrayの個数分表示する(numArray,imageNameArrayでも同様)
            //        let gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
            return goodArray.count
        }
        
        func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            guard let cell = cell else {
                fatalError("cell is not found")
            }
            
            // cellに各タイトルを表示させる
            cell.textLabel?.text = goodArray[indexPath.row].name
            // cellに各イメージを表示させる
            cell.imageView?.image = UIImage(data: goodArray[indexPath.row].image)
            
            return cell
        }
        
        // 各cellの詳細モーダル
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            cellNum = indexPath.row
            print(indexPath.row)
            print(cellNum)
            // 編集モーダルに遷移する
            performSegue(withIdentifier: "toHensyu", sender: nil)
            
            
        }
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            goodArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
        
    
}
