//
//  ViewController.swift
//  BluetoothCentralForiOSPeripheral
//
//

import UIKit
import CoreBluetooth

let serviceUUID = CBUUID(string: "5FBDB555-14E7-4CC6-A612-6821474550DD")
let writeUUID = CBUUID(string: "7B28942C-9604-4AF6-B84E-274F12605F0C")
let readUUID = CBUUID(string: "7B28942C-9604-4AF6-B84E-274F12605F0C")
let notifyUUID = CBUUID(string: "CE807494-7CEA-49D1-A230-F2EAB5120985")


class ViewController: UIViewController {

    @IBOutlet weak var writeTextField: UITextField!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    
    var centralManager: CBCentralManager!
    var fuxinPeripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)//创建中心设备管理器
    }
    
    //手动给特征写值
    @IBAction func write(_ sender: Any) {
        guard let writeCharacteristic = writeCharacteristic else{return}
        fuxinPeripheral.writeValue(writeTextField.text!.data(using: .utf8)!, for: writeCharacteristic , type: .withResponse)
    }

}


extension ViewController: CBCentralManagerDelegate{
    
    //判断设备状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .unknown,.resetting,.unsupported,.unauthorized,.poweredOff:
            print("请检查设备")
        case .poweredOn:
            print("启动成功")
            central.scanForPeripherals(withServices: [serviceUUID])//扫描外设
        @unknown default:
            print("来自未来的错误")
        }
    }
    
    //发现外设
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        fuxinPeripheral = peripheral
        central.stopScan()
        central.connect(peripheral)//连接外设
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.connect(peripheral)//重连
    }
    
    //已连接到外设
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])//寻找服务
    }
}


//CBPeripheralDelegate方法
extension ViewController: CBPeripheralDelegate{
    
    //发现服务
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first else{return}
        //寻找特征
        peripheral.discoverCharacteristics([writeUUID,readUUID,notifyUUID], for: service)
    }
    
    //发现特征
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else{return}
        for characteristic in characteristics{
            
            if characteristic.properties.contains(.write){
                writeCharacteristic = characteristic
                peripheral.writeValue("88".data(using: .utf8)!, for: characteristic, type: .withResponse)
            }
            if characteristic.properties.contains(.read){
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify){
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
        }
    }
    
    //读取可读特征值+实时读取订阅特征值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid{
        case readUUID:
            readLabel.text = String(data: characteristic.value!, encoding: .utf8)
        case notifyUUID:
            notifyLabel.text = String(data: characteristic.value!, encoding: .utf8)
        default:
            break
        }
    }
    
    
}

