//
//  AddCellViewController.swift
//  goodsAPP
//
//  Created by Kusunose Hosho on 2021/11/23.
//

import UIKit

class AddCellViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var table: UITableView!
    
    var saveData : UserDefaults!
    
    var cellNum:Int! // 選択されたcellのNumberを入れる変数
    
    var selectData: NSData? = nil
    var goodArray = [GoodsData]()

    @IBOutlet var titleTextField: UITextField! // タイトルを入力するTextField
    @IBOutlet var numberTextField: UITextField! // 個数を入力するTextField
    
    // 画面が読まれた時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        numberTextField.delegate = self
        
    }
    
    // 戻るボタン
    @IBAction func modoru() {
        dismiss(animated: true, completion: nil)
    }
    
    // 追加ボタン
    @IBAction func add() {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "udGoodsArray"),
              let decodeData = try? jsonDecoder.decode([GoodsData].self, from: data) else {
            return
        }
        goodArray = decodeData
        
        let goods = GoodsData(name: titleTextField.text!, num: Int(numberTextField.text!) ?? 0, image: selectData! as Data)
        
        goodArray.append(goods)
        
        // UserDefaultsにグッズの画像が保存された配列を保存する
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(goodArray) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "udGoodsArray")
        // UserDefaultsに保存されているデータを取得して、フィールド変数に代入する
//        gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
//        numArray = (saveData.object(forKey: "udNumArray") as? [String])!
//        imageNameArray = (saveData.object(forKey: "udImageNameArray") as? [NSData])!
        
        // 入力されたテキストを各配列に格納する
//        gNameArray.append(titleTextField.text!)
//        numArray.append(numberTextField.text!)
//        imageNameArray.append(selectData!)
//
//        // UserDeafultsに追加された配列を保存する
//        saveData.set(gNameArray, forKey: "udNameArray")
//        saveData.set(numArray, forKey: "udNumArray")
//        saveData.set(imageNameArray, forKey: "udImageNameArray")
        
        // テーブルの情報を更新する
        table.reloadData()
        
        // モーダルを閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
    // 写真ライブラリから画像を選択する
    @IBAction func selectImage() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()

        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let data = image.pngData()! as NSData

        // グッズの画像を保存する配列に追加する
//        imageNameArray.append(data)
        selectData = data
        // UserDefaultsにグッズの画像が保存された配列を保存する
//        saveData.set(imageNameArray, forKey: "udImageNameArray")
        // テーブルの情報を更新する
//        table.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ViewController
        
//        nextVC.gNameArray = gNameArray
//        nextVC.numArray = numArray
        nextVC.goodArray = goodArray
        nextVC.table.reloadData()
        // ViewControllerにsaveDataの値を渡す
//        nextVC.saveData = saveData
    }

    // Enter押したときに自動的にキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
