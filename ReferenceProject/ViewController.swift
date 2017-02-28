//
//  ViewController.swift
//  ReferenceProject
//
//  Created by Ben Reynolds on 28/02/2017.
//  Copyright © 2017 Ben Reynolds. All rights reserved.
//

import UIKit



class ViewController: UIViewController, TriangleViewDataSource {

    @IBOutlet weak var storedDetails: UILabel!
    @IBOutlet weak var devicesLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var sliderVal: UISlider!
    
    var tableData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /* Gestures */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeColor(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.changeText(sender:)))
        let rotationGesture = UIRotationGestureRecognizer(target:self, action:#selector(self.changeFontSizeLarger(sender:)))
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(self.changeFontSizeSmaller(sender:)))
        let screenEdgeGesture = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(self.changeTextEdge(sender:)))
        leftSwipe.direction = .left  // .up and .down can be used also.
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(rotationGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(screenEdgeGesture)
        
        self.testUserDefaults()
        self.readPropertyLists()
        self.addToPropertyList(value:"Ben Reynolds")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var triangleView: TriangleView! {
        didSet {
            triangleView.dataSource = self
        }
    }
    
    var triangleModel = TriangleModel() {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.triangleView.setNeedsDisplay()
    }

    
    @IBAction func setSliderScale(_ sender: UISlider) {
        triangleModel = TriangleModel(Start: CGPoint(x: 0, y: 0), Scale: Int(sliderVal.value))
    }
    
    /* slider method */
    func scale(sender: TriangleView) -> [CGPoint]? {
        var vertices = triangleModel.scale(atCenter: CGPoint(x: 0, y: 0))
        return vertices
    }
    
    
    /* Gesture Methods */
    func changeColor(_ sender: UITapGestureRecognizer) {
        swipeLabel.textColor = UIColor.darkGray
    }
    func changeFontSizeLarger(sender: UIRotationGestureRecognizer) {
        swipeLabel.font = UIFont(name: swipeLabel.font.fontName, size: 30)
    }
    func changeFontSizeSmaller(sender: UIRotationGestureRecognizer) {
        swipeLabel.font = UIFont(name: swipeLabel.font.fontName, size: 10)
    }
    func changeText(sender: UIPinchGestureRecognizer) {
        swipeLabel.text = "PINCHED"
    }
    func changeTextEdge(sender: UIPinchGestureRecognizer) {
        swipeLabel.text = "Edge"
    }
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .left) {
            print("Left Swipe")
            let labelPosition = CGPoint(x:self.swipeLabel.frame.origin.x - 50, y:self.swipeLabel.frame.origin.y )
            swipeLabel.frame = CGRect(x:labelPosition.x, y:labelPosition.y, width:self.swipeLabel.frame.size.width, height: self.swipeLabel.frame.size.height )
        } else if(sender.direction == .right) {
            print("Right Swipe")
            let labelPosition = CGPoint(x:self.swipeLabel.frame.origin.x + 50, y:self.swipeLabel.frame.origin.y )
            swipeLabel.frame = CGRect(x:labelPosition.x, y:labelPosition.y, width:self.swipeLabel.frame.size.width, height: self.swipeLabel.frame.size.height )
        }
    }
    
    /* User Defualts */
    func testUserDefaults() {
        // Stores Ben Reynolds and 22 in User Defaults and pulls it out again. Like SharedPreferences in Android.
        let name = "Ben Reynolds"
        let age = 22
        let ud = UserDefaults.standard
        ud.setValue(name, forKey: "name")
        ud.setValue(age, forKey: "age")
        let nameNew = ud.string(forKey: "name")
        let ageNew = ud.integer(forKey: "age")
        storedDetails.text = "Stored \(nameNew! as String): \(ageNew)"
    }
    
    /* Property List Stuff - Plist. */
    
    func readPropertyLists() {
        let path = Bundle.main.path(forResource: "Devices", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        tableData = dict!.object(forKey: "AppleDevice") as! [String]
        var output = ""
        for value in tableData {
            output += " " + value
        }
        devicesLabel.text = output
    }
    
    func addToPropertyList(value:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
        let documentDirectory = paths[0] as String
        let path = documentDirectory.appending("/newPlist.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject(value, forKey: "string" as NSCopying)
        //writing to newPlist.plist
        dict.write(toFile: path, atomically: false)
    }
}

