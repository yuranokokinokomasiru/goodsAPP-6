//
//  hensyuViewController.swift
//  goodsAPP
//
//  Created by cl_umeda_001 on 2021/10/27.
//

import UIKit

class hensyuViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var saveData : UserDefaults! = UserDefaults.standard
    
    var table: UITableView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    
    var cellNum:Int! // 選択されたcellのNumberを入れる変数
    var goodArray = [GoodsData]()
    
    // 編集画面が表示された時
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cellNum)
        // テーブルの情報を更新する
//        table.reloadData()
        
        titleTextField.delegate = self
        
        numberTextField.delegate = self
        print(goodArray)
        // UserDefaultsに保存されているデータを取得して、フィールド変数に代入する
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "udGoodsArray"),
              let decodeData = try? jsonDecoder.decode([GoodsData].self, from: data) else {
            print(goodArray[cellNum])
            return
        }
        goodArray = decodeData
        // 編集するtitleTextFieldに選択したグッズのタイトルを表示する
        titleTextField.text = goodArray[cellNum].name
        print(goodArray[cellNum])
        // 編集するnumberTextFieldに選択したグッズの数を表示する
        numberTextField.text = String(goodArray[cellNum].num)
    }
    
    // 戻るボタン
    @IBAction func modoru() {
        dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func hozon() {
        // 入力されたテキストを上書きして各配列に格納する
        goodArray[cellNum].name = titleTextField.text!
        goodArray[cellNum].num = Int(numberTextField.text!)! ?? 0
        
        // UserDeafultsに追加された配列を保存する
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(goodArray) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "udGoodsArray")
        
        // テーブルの情報を更新する
//        table.reloadData()
        
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
        
        // グッズの画像を上書きする
        goodArray[cellNum].image = data as Data
        // UserDefaultsにグッズの画像が保存された配列を保存する
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(goodArray) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "udGoodsArray")
        
//        table.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ViewController
        // ViewControllerにsaveDataの値を渡す
        nextVC.saveData = saveData
    }
    
    // Enter押したときに自動的にキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

