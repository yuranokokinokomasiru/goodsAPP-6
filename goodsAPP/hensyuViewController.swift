//
//  hensyuViewController.swift
//  goodsAPP
//
//  Created by cl_umeda_001 on 2021/10/27.
//

import UIKit

class hensyuViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var saveData : UserDefaults!
    
    var table: UITableView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    
    var gNameArray = [String]() // グッズの名前を入れる配列
    var numArray = [String]() // グッズの数を入れる配列
    var cellNum:Int! // 選択されたcellのNumberを入れる変数
    var imageNameArray = [NSData]() // グッズのイメージを入れる配列

    // 編集画面が表示された時
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルの情報を更新する
        table.reloadData()
        
        titleTextField.delegate = self
        
        numberTextField.delegate = self
        
        // UserDefaultsに保存されているデータを取得して、フィールド変数に代入する
        gNameArray = (saveData.object(forKey: "udNameArray") as? [String])!
        numArray = (saveData.object(forKey: "udNumArray") as? [String])!
        imageNameArray = (saveData.object(forKey: "udImageNameArray") as? [NSData])!

        // 編集するtitleTextFieldに選択したグッズのタイトルを表示する
        titleTextField.text = gNameArray[cellNum!]
        // 編集するnumberTextFieldに選択したグッズの数を表示する
        numberTextField.text = numArray[cellNum!]
    }
    
    // 戻るボタン
    @IBAction func modoru() {
        dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func hozon() {
        // 入力されたテキストを上書きして各配列に格納する
        gNameArray[cellNum!] = titleTextField.text!
        numArray[cellNum!] = numberTextField.text!
        
        // UserDeafultsに追加された配列を保存する
        saveData.set(gNameArray, forKey: "udNameArray")
        saveData.set(numArray, forKey: "udNumArray")
        saveData.set(imageNameArray, forKey: "udImageNameArray")
        
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

        // グッズの画像を上書きする
        imageNameArray[cellNum] = data
        // UserDefaultsにグッズの画像が保存された配列を保存する
        saveData.set(imageNameArray, forKey: "udImageNameArray")
        // テーブルの情報を更新する
        table.reloadData()
        
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

