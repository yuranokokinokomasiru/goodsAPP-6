//
//  ViewController.swift
//  goodsAPP
//
//  Created by cl_umeda_001 on 2021/10/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var gNameArray = [String]() // グッズの名前を入れる配列
    var numArray = [String]() // グッズの数を入れる配列
    var cellNum:Int! // 選択されたcellのNumberを入れる変数
    var imageNameArray = [NSData]() // グッズの画像を入れる配列
    
    var saveData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults内のデータリセット
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        table.dataSource = self
        table.delegate = self
        
        // まだUserDefaultsにデータが何も保存されていない時以外は、UserDefaultsの各データをフィールドの変数に代入する
        if(saveData.object(forKey: "udNumArray") != nil){
            gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
            numArray = (saveData.object(forKey: "udNumArray") as? [String])!
            //            imageNameArray = (saveData.object(forKey: "udImageNameArray") as? [NSData])!
        }
        
        // AddCellViewConrollerで値を追加するために変数をUserDefaultに保存する
        /*
         → はじめ(ViewController)
         gNameArray[], udNameArray[]
         
         → 追加する(addCellViewController)                              ← この時にUserDefaultsから取得したい&UserDefaultsのデータをcellに表示したいから
         ここでUserDefaultsにフィールドの変数を保存してる
         udNameArray[""]をUserDefaultsから取得
         gNameArray["ガチャピン"], udNameArray["ガチャピン"]
         
         → 2回目の追加(addCellViewController)
         udNameArray["ガチャピン"]をUserDefaultsから取得
         gNameArray["ガチャピン"] に "ムック" を追加する(appendする)
         
         → 以降繰り返し
         */
        saveData.set(gNameArray, forKey: "udNameArray")
        saveData.set(numArray, forKey: "udNumArray")
        saveData.set(imageNameArray, forKey: "udImageNameArray")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //値持たせて画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // StoryBoardのidentifierに名前つけて判別してる
        if segue.identifier == "toHensyu" {
            let hensyuVC = segue.destination as! hensyuViewController
            hensyuVC.gNameArray = gNameArray // 選択されたグッズの配列を編集Viewに教える
            hensyuVC.numArray = numArray // 選択されたグッズの配列を編集Viewに教える
            hensyuVC.cellNum = cellNum // 選択されたCellのNumberを編集Viewに教える
            hensyuVC.saveData = saveData // UserDeafaultsのインスタンス
            hensyuVC.imageNameArray = imageNameArray // 選択されたグッズの配列を編集Viewに教える
            hensyuVC.table = table // テーブルの情報更新するためにtableを編集Viewに教える
        } else if segue.identifier == "toAdd" {
            let addVC = segue.destination as! AddCellViewController
            addVC.gNameArray = gNameArray // 選択されたグッズの配列を追加Viewに教える
            addVC.numArray = numArray // 選択されたグッズの配列を追加Viewに教える
            addVC.cellNum = cellNum // 選択されたCellのNumberを追加Viewに教える
            addVC.saveData = saveData // UserDeafaultsのインスタンス
            addVC.imageNameArray = imageNameArray // 選択されたグッズの配列を追加Viewに教える
            addVC.table = table // テーブルの情報更新するためにtableを追加Viewに教える
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 保存されているgNameArrayの個数分表示する(numArray,imageNameArrayでも同様)
        let gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
        return gNameArray.count
    }
    
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        // cellに各タイトルを表示させる
        cell?.textLabel?.text = gNameArray[indexPath.row]
        // cellに各イメージを表示させる
        let imageNameArray = (saveData.object(forKey: "udImageNameArray") as? [NSData])!
        cell?.imageView?.image = UIImage(data: (imageNameArray[indexPath.row] as NSData) as Data)
        
        return cell!
    }
    
    // 各cellの詳細モーダル
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNum = indexPath.row
        // 編集モーダルに遷移する
        performSegue(withIdentifier: "toHensyu", sender: nil)
        

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        print(gNameArray.count)
        gNameArray.remove(at: indexPath.row)
        numArray.remove(at: indexPath.row)
        imageNameArray.remove(at: indexPath.row)
        //        myTableView.deleteRows(at: [indexPath], with: .fade)
        
        
        
    }
    
}
