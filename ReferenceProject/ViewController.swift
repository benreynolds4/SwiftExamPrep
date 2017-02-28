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
    var currentScale:CGFloat = 1.0
    
    // Triangle view hooked up with the control drag from storyboard.
    @IBOutlet weak var triangleView: TriangleView! {
        didSet {
            triangleView.dataSource = self
        }
    }
    
    // Instance of the triangle model created, on setting it then calls updateUI and sets points for
    // triangle.
    var triangleModel = TriangleModel() {
        didSet {
            triangleModel.setPoints(x: CGPoint(x:10, y:10), y: CGPoint(x:30, y:0), z: CGPoint(x:20, y:20))
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Gestures */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeSize(sender:)))
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
        
        
        // User Defaults is like sharedPreferences in Android, stores data or objects
        self.testUserDefaults()
        
        // Property lists are like a file version of a database
        self.readPropertyLists()
        self.addToPropertyList(value:"Ben Reynolds")

    }
    
    // Update UI is called when the triangle mode is set
    // it reloads the custom view.
    private func updateUI() {
        self.triangleView.setNeedsDisplay()
    }
    
    
    // Called on Tap Gesture. 
    // Scales the Triangle By 1.5 bu setting a new instance of the TriangleModel with scaled vales
    func changeSize(sender: UITapGestureRecognizer) {
        currentScale = CGFloat(triangleModel.scale)
        triangleModel = TriangleModel(x: CGPoint(x:10, y:10), y: CGPoint(x:17, y:25), z: CGPoint(x:20, y:20),  Scale: self.currentScale * 1.5)
        triangleModel.scale = self.currentScale * 1.5
    }
    
    // Action for the slider in the View.
    //  Scales the Triangle By setting a new instance of the TriangleModel with scaled vales
    @IBAction func setSliderScale(_ sender: UISlider) {
        triangleModel = TriangleModel(x: CGPoint(x:10, y:10), y: CGPoint(x:17, y:25), z: CGPoint(x:20, y:20), Scale: CGFloat(sliderVal.value))
    }
    
    // Delegate Method. Protocol is set in the custom view.
    // This method gets the array from the triangleModel and returns them to the
    // draw method in the custom view.
    func scale(sender: TriangleView) -> [CGPoint]? {
        let vertices = triangleModel.scale(atCenter: CGPoint(x: 0, y: 0))
        return vertices
    }
    
    /* Gesture Methods */
    func changeColor(_ sender: UITapGestureRecognizer) {
        swipeLabel.textColor = UIColor.darkGray
    }
    /* Gesture Methods */
    func changeFontSizeLarger(sender: UIRotationGestureRecognizer) {
        swipeLabel.font = UIFont(name: swipeLabel.font.fontName, size: 30)
    }
    /* Gesture Methods */
    func changeFontSizeSmaller(sender: UIRotationGestureRecognizer) {
        swipeLabel.font = UIFont(name: swipeLabel.font.fontName, size: 10)
    }
    /* Gesture Methods */
    func changeText(sender: UIPinchGestureRecognizer) {
        swipeLabel.text = "PINCHED"
    }
    /* Gesture Methods */
    func changeTextEdge(sender: UIPinchGestureRecognizer) {
        swipeLabel.text = "Edge"
    }
    /* Gesture Methods */
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

