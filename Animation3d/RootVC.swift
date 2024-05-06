//
//  ViewController.swift
//  Animation3d
//
//  Created by Hassan Taleb on 05/05/2024.
//

import UIKit
import SceneKit

class RootVC: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var sceneView: SCNView = {
        let view = SCNView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        sceneView.frame = view.frame
        
        setupScene()
        setupGesture()
    }
    
    func setupScene() {
        guard let scene = SCNScene(named: "Apple_iPad_Pro.usdz") else  {
            return
        }
        scene.rootNode.position = SCNVector3(x: 0, y: 282.523/2, z: 0)
        scene.rootNode.setPivotCenter()
        sceneView.scene = scene
        
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.pointOfView?.scale = .init(x: 1, y: 1, z: 0.3)
        
    }

    func setupGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        sceneView.addGestureRecognizer(doubleTap)
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        let rotationAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(x: 0, y: 1, z: 0), duration: 1)
        sceneView.pointOfView?.runAction(rotationAction)
        //sceneView.scene?.rootNode.runAction(rotationAction)
    }

}

extension SCNNode {
    
    func setPivotCenter() {
        let (min, max) = boundingBox
        let x = min.x + 0.5 * (max.x - min.x)
        let y = min.y + 0.5 * (max.y - min.y)
        let z = min.z + 0.5 * (max.z - min.z)
        self.pivot = SCNMatrix4MakeTranslation(x, y, z)
    }
    
}
