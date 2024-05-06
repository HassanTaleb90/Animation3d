import SceneKit

var myScene = SCNScene()

class RootVC: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var sceneView: SCNView = {
        let view = SCNView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSceneView()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0.0, 0.0, +10.0)
        myScene.rootNode.addChildNode(cameraNode)
        
        self.setupiPad()
        
        setupGesture()
    
    }
    
    func setupGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        sceneView.addGestureRecognizer(doubleTap)
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        
        sceneView.pointOfView?.transform = SCNMatrix4(m11: -0.99805325, m12: 9.313226e-10, m13: -0.062367648, m14: 0.0, m21: 0.001364812, m22: 0.9997605, m23: -0.021840723, m24: 0.0, m31: 0.062352777, m32: -0.021883326, m33: -0.9978142, m34: 0.0, m41: 0.61549366, m42: -0.21884802, m43: -9.97974, m44: 1.0)
        sceneView.pointOfView?.camera?.fieldOfView = 60
        
        SCNTransaction.commit()
    }
    
    func setupiPad() {
        let iPadNode = SCNNode(named: "Apple_iPad_Pro.usdz")
        // iPadNode.pivot = SCNMatrix4MakeTranslation(0.0, +150.0, 0.0)
        iPadNode.scale = SCNVector3(0.01, 0.01, 0.01)
        iPadNode.setPivotCenter()
        myScene.rootNode.addChildNode(iPadNode)
    }
    
    func setupSceneView() {
        
        self.view.backgroundColor = UIColor.white
        
        // MARK: Setup SceneView
        // sceneView.delegate                              = self
        view.addSubview(sceneView)
        
        sceneView.frame                                 = view.frame
        sceneView.isPlaying                             = true
        sceneView.backgroundColor                       = .black
        sceneView.antialiasingMode                      = .none
        sceneView.isJitteringEnabled                    = false
        sceneView.autoenablesDefaultLighting            = true
        sceneView.allowsCameraControl                   = false
        //sceneView.rendersContinuously                   = true
        
        // MARK: Set Scene and Configs
        sceneView.scene                                 = myScene
        sceneView.scene?.rootNode.castsShadow           = false
        
        // MARK: Scene Physics Configuration
        // sceneView.scene?.physicsWorld.contactDelegate = self
        // sceneView.scene?.physicsWorld.gravity           = defaultGravity
        // sceneView.scene?.physicsWorld.timeStep       = 1/240 // 1/120 // DO NOT SET
        // sceneView.scene?.physicsWorld.speed          = 1.0 // not configured
        
        // MARK: Environment
        myScene.lightingEnvironment.contents          = UIColor.white
        myScene.background.contents                   = UIColor.white
        
        // MARK: Debug Options (Disabled)
        // sceneView.showsStatistics                    = true // statistics such as fps and timing information
        // sceneView.debugOptions                       = [SCNDebugOptions.showPhysicsShapes]
        // sceneView.debugOptions                       = [SCNDebugOptions.showBoundingBoxes]
        // sceneView.debugOptions                       = [SCNDebugOptions.showSkeletons]
        // sceneView.debugOptions                       = [SCNDebugOptions.showWireframe]
        // sceneView.debugOptions                       = [SCNDebugOptions.renderAsWireframe]
        // sceneView.debugOptions                       = [SCNDebugOptions.showLightExtents, SCNDebugOptions.showLightInfluences]
        
        print("SceneView and Scene setup completed")
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

extension SCNNode {
    convenience init(named name: String) {
        self.init()
        guard let scene = SCNScene(named: name) else {return}
        for childNode in scene.rootNode.childNodes {addChildNode(childNode)}
    }
}
