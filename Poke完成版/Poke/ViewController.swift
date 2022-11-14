//
//  ViewController.swift
//  Poke
//
//  Created by liujun on 2019/4/18.
//  Copyright © 2019 liujun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true//为模型打光
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //类似于平面检测，这里设置为图片检测；并指定哪些图片需要被检测
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Poke Cards", bundle: nil)
        configuration.maximumNumberOfTrackedImages = 4 //设定最大追踪图片数（文档规定）
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //过滤出那些是图片检测的锚点
        guard let imageAnchor = anchor as? ARImageAnchor else{return}
        
        //因程序耗时，故放到主线程里异步执行，防止放置虚拟模型时卡顿
        DispatchQueue.main.async {
            
            //根据项目需求创建带透明的平面节点

            
            //若有多个桌游卡片需要识别时
            if imageAnchor.referenceImage.name == "eevee" {
                let planeNode = SCNNode(geometry: SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height))
                planeNode.opacity = 0.25
                planeNode.eulerAngles.x = -.pi / 2
                //创建伊布（口袋妖怪）的3D模型节点
                guard let eeveeNode = SCNScene(named: "art.scnassets/eevee.scn")?.rootNode.childNode(withName: "eevee", recursively: true) else{return}
                
                
                node.addChildNode(planeNode)
                node.addChildNode(eeveeNode)
            }
            if imageAnchor.referenceImage.name == "ground" {
                let planeNode = SCNNode(geometry: SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height))
                planeNode.opacity = 0.25
                planeNode.eulerAngles.x = -.pi / 2
                //创建伊布（口袋妖怪）的3D模型节点
                guard let eeveeNode = SCNScene(named: "art.scnassets/eevee.scn")?.rootNode.childNode(withName: "eevee", recursively: true) else{return}
                
                
                node.addChildNode(planeNode)
                node.addChildNode(eeveeNode)
            }
            if imageAnchor.referenceImage.name == "desk" {
                let planeNode = SCNNode(geometry: SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height))
                planeNode.opacity = 0.25
                planeNode.eulerAngles.x = -.pi / 2
                //创建伊布（口袋妖怪）的3D模型节点
                guard let eeveeNode = SCNScene(named: "art.scnassets/eevee.scn")?.rootNode.childNode(withName: "eevee", recursively: true) else{return}
                
                
                node.addChildNode(planeNode)
                node.addChildNode(eeveeNode)
            }
            if imageAnchor.referenceImage.name == "window" {
                let planeNode = SCNNode(geometry: SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height))
                planeNode.opacity = 0.25
                planeNode.eulerAngles.x = -.pi / 2
                //创建伊布（口袋妖怪）的3D模型节点
                guard let eeveeNode = SCNScene(named: "art.scnassets/eevee.scn")?.rootNode.childNode(withName: "eevee", recursively: true) else{return}
                
                
                node.addChildNode(planeNode)
                node.addChildNode(eeveeNode)
            }
            //...
            

            
            //注：这里没有给上面这两个模型设位置，是因为session会默认把模型的中心点和检测到的现实卡片的中心点重叠
            //所以3D模型需要根据实际需求提前做好中心点，方向，位置等的处理
        }
        
    }
}
