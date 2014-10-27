//
//  TodayViewController.swift
//  Workday
//
//  Created by siddiqui on 10/19/14.
//  Copyright (c) 2014 siddiqui. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var calendarScrollView: UIScrollView!
    @IBOutlet weak var taskScrollView: UIScrollView!
    
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var placedTask: UIView!

    @IBOutlet weak var calendarHeader: UIImageView!
    @IBOutlet weak var task1: UIImageView!
    @IBOutlet weak var task2: UIImageView!
    @IBOutlet weak var task3: UIImageView!
    
    // Task list
    @IBOutlet weak var taskTrelloBilling: UIImageView!
    @IBOutlet weak var taskPivotalError: UIImageView!
    @IBOutlet weak var taskTrelloNew: UIImageView!
    @IBOutlet weak var taskTrelloStyleguide: UIImageView!
    @IBOutlet weak var taskPivotalHomePage: UIImageView!
    @IBOutlet weak var taskPivotalRoadmap: UIImageView!
    @IBOutlet weak var taskTrelloDashboard: UIImageView!
    
    
    var task1Copy: UIImageView!
    var panGesture: UIPanGestureRecognizer!
    var originalPressDownLocation : CGPoint!
    var originalImageCenter : CGPoint!
    var taskFrame : CGRect!
    
    @IBOutlet var task1Gesture: UIPanGestureRecognizer!
    @IBOutlet var task2Gesture: UIPanGestureRecognizer!
    @IBOutlet var task3Gesture: UIPanGestureRecognizer!
    
    var taskLocation : CGPoint!
    var taskScrollViewIsScrolling = false
    var tasktoSegue : UIImageView!
    var taskCenter: CGPoint!
    var imageView: UIImageView!
    
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var clock: UIImageView!
    
    
    // View from the storyboard
//    var todayViewController: UIViewController!
//    var trelloArchiveViewController: UIViewController!
//    var trelloLaterViewController: UIViewController!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarScrollView.contentSize = calendarImage.image!.size
        
        //make sure that the scrollview starts at 1PM (current time is 12.18 PM)
        calendarScrollView.contentOffset.y = 550
        
        // Adding the Storyboard and views
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        todayViewController = storyboard.instantiateViewControllerWithIdentifier("TodayViewController") as UIViewController
//        trelloArchiveViewController = storyboard.instantiateViewControllerWithIdentifier("TrelloArchiveViewController") as UIViewController
//        trelloLaterViewController = storyboard.instantiateViewControllerWithIdentifier("TrelloLaterViewController") as UIViewController

        

        checkmark.alpha = 0
        clock.alpha = 0
        
        var taskTrelloBillingHeight = taskTrelloBilling.image!.size.height
        var taskTrelloNewHeight = taskTrelloNew.image!.size.height
        var taskTrelloStyleguideHeight = taskTrelloStyleguide.image!.size.height
        var taskTrelloDashboardHeight = taskTrelloDashboard.image!.size.height
        var taskPivotalErrorHeight = taskPivotalError.image!.size.height
        var taskPivotalHomePageHeight = taskPivotalHomePage.image!.size.height
        var taskPivotalRoadmapHeight = taskPivotalRoadmap.image!.size.height
        
        var scrollHeight = taskTrelloBillingHeight + taskTrelloNewHeight + taskTrelloStyleguideHeight + taskTrelloDashboardHeight + taskPivotalErrorHeight + taskPivotalHomePageHeight + taskPivotalRoadmapHeight


        println("total is \(scrollHeight)")
        
        task1Gesture.delegate = self
        task2Gesture.delegate = self
        task3Gesture.delegate = self
        
        taskScrollView.contentSize = CGSize(width: 375, height: scrollHeight)
        
        taskScrollView.delegate = self
        calendarScrollView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    /*---------Turning on simultaneous gestures--------------------------*/
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        println("tapped")
    }
    @IBAction func onLongPress1(sender: UILongPressGestureRecognizer) {
        
        taskLocation = sender.locationInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            
            task1Gesture.enabled = false
            
            task1.alpha = 0.5
            
            originalPressDownLocation = taskLocation
            var originalImageCenter = task1.center
            
            //Create Copy of Task 1
            taskFrame = view.convertRect(task1.frame, fromView: taskScrollView)
            task1Copy = UIImageView(frame: taskFrame)
            task1Copy.image = task1.image
            
            //transform it
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations:{ () -> Void in
                self.task1Copy.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }, completion: nil)
            println("copied at \(taskLocation)")
            
            view.addSubview(task1Copy)
            
            //Adding a shadow on the copy
            task1Copy.layer.shadowColor = UIColor.darkGrayColor().CGColor
            task1Copy.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            task1Copy.layer.shadowOpacity = 0.7
            task1Copy.layer.shadowRadius = 2
            task1Copy.layer.masksToBounds = true
            task1Copy.clipsToBounds = false
            

        } else if sender.state == UIGestureRecognizerState.Changed {
            
            println("Changed long press at \(taskLocation)")
            let translation = CGPoint(x:originalPressDownLocation.x - taskLocation.x, y:originalPressDownLocation.y - taskLocation.y)
            
            //            task1Copy.center.x = originalPressDownLocation.x - translation.x
            //            task1Copy.center.y = originalPressDownLocation.y - translation.y
            task1Copy.frame.origin.x = taskFrame.origin.x - translation.x
            task1Copy.frame.origin.y = taskFrame.origin.y - translation.y
            
            //this will make the calendar scroll when the task is dragged to the bottom of the screen, and the velocity is taking into account the direction (downward in this case)
            if task1Copy.center.y > 602 && calendarScrollView.contentOffset.y < 1471{
                println("welcome to the bottom")
                calendarScrollView.contentOffset.y  = calendarScrollView.contentOffset.y + 10
                println("\(calendarScrollView.contentOffset.y)")
            }
                
            else if task1Copy.center.y > 370 && task1Copy.center.y < 400 && calendarScrollView.contentOffset.y > 0 {
                println("welcome to the top")
                calendarScrollView.contentOffset.y  = calendarScrollView.contentOffset.y - 10
                println("\(calendarScrollView.contentOffset.y)")
            }
            
            //if the user is moving the object up, the calendar should scroll up, the reason it is between 396 and 602, is in case the user goes back to the task scrollview, the bottom scrollview will stop scrolling
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            //fade out the original copy when it is placed
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.task1Copy.alpha = 0
            })
            
            task1Gesture.enabled = true
            task1.alpha = 1.0
            
        }
        
        
    }

    
    /*-------------TASK IS SCROLLING ON------------------------------*/

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        taskScrollViewIsScrolling = true
        println("\(taskScrollViewIsScrolling)")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        taskScrollViewIsScrolling = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        taskScrollViewIsScrolling = false

    }
    
    
    /*-------------TASK PANNING------------------------------*/
    
    @IBAction func didPanTask(sender: UIPanGestureRecognizer) {
        
        tasktoSegue = sender.view as UIImageView
        
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        
        
        if translation.x > 0 || translation.x < 0 {
            
        }
        
        if taskScrollViewIsScrolling == false {
            
            if sender.state == UIGestureRecognizerState.Began {
                
                taskCenter = tasktoSegue.center
                
            } else if sender.state == UIGestureRecognizerState.Changed {
                checkmark.alpha = 0
                clock.alpha = 0
                
                tasktoSegue.center.x = translation.x + taskCenter.x
                var position = tasktoSegue.frame.origin.x
                taskScrollView.scrollEnabled = false
                
                
                if translation.x < 0 {
                    clock.alpha = 1
                    clock.center.x = translation.x + 410
                    clock.center.y = tasktoSegue.center.y

                } else if translation.x > 0 {
                    checkmark.alpha = 1
                    checkmark.center.x = translation.x - 30
                    checkmark.center.y = tasktoSegue.center.y
                }
                
                
            } else if sender.state == UIGestureRecognizerState.Ended {
                // Swipe left to do later
                if translation.x < -60 {
                    println("do it later")
                }
                
                // Swipe right to archive
                if translation.x > 60 {
                    println("archive it")
                }
                
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.tasktoSegue.frame.origin.x = 0
                })
                
                taskScrollView.scrollEnabled = true
                
            }
            
        }

        
    }
    
    
    
    
    
    
    
    
    
//last one
}




















