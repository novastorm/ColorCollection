//
//  ColorViewController.swift
//  Updated to Swift 4 by Adland on 11/5/16
//
//  ColorViewController.swift
//  Updated to Swift 3 by Mark on 11/5/16
//
//  Created by Jason on 3/10/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData
import MapKit

/**
 The color collection demonstrates two techniques that will be useful in the
 Virtual Tourist app
 
 - Selecting and deselecting cells in a collection
 - Using NSFetchedResultsController with a collection
 
 Before you proceed, take a minute to run the app, and then read the Readme
 file. It gives a brief introduction to these two topics.
 */

class ColorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Instance Variables
    lazy var fetchedResultsController: NSFetchedResultsController<Color> = {
        
        let fetchRequest = Color.fetchRequest()
        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "value", ascending: true, comparator: { (a, b) -> ComparisonResult in
//                
//                let a = a as! UIColor
//                let b = b as! UIColor
//
//                if a.hue == b.hue {
//                    return .orderedSame
//                }
//                
//                return a.hue < b.hue ? .orderedAscending : .orderedDescending
//            })
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController as! NSFetchedResultsController<Color>
    }()
    
    var coreDataClient = (UIApplication.shared.delegate as! AppDelegate).coreDataClient
    var sharedContext: NSManagedObjectContext {
        return coreDataClient.mainContext
    }
    /**
     The selected indexes array keeps all of the indexPaths for cells that are
     "selected". The array is used inside cellForItemAtIndexPath to lower the
     alpha of selected cells. You can see how the array works by searching
     through the code for 'selectedIndexes'
     */
    var selectedIndexes = [IndexPath]()
    
    // Track of insertions, deletions, and updates.
    var insertedIndexPaths = [IndexPath]()
    var deletedIndexPaths = [IndexPath]()
    var updatedIndexPaths = [IndexPath]()
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        print("in viewDidLoad()")
        
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ColorsViewController.addColor(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Start the fetched results controller
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("Error performing initial fetch: \(error)")
        }
        
        updateBottomButton()
    }
    
    // Layout the collection view
    
    override func viewDidLayoutSubviews() {
        print("in viewDidLayoutSubviews()")
        super.viewDidLayoutSubviews()
        
        // Layout the collection view so that cells take up 1/3 of the width,
        // with no space in-between.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    
    // MARK: - UICollectionView
    func configureCell(_ cell: ColorCell, atIndexPath indexPath: IndexPath) {
        print("in configureCell")
        let colorRecord = self.fetchedResultsController.object(at: indexPath)
        
        cell.color = colorRecord.value
        cell.rgbLabel.text = String(describing: colorRecord.value.hue)
        print(String(describing: colorRecord.value.hue))
        
        /**
         If the cell is "selected", its color panel is grayed out. We use the Swift `find` function to see if the indexPath is in the array
         */
        
        if let _ = selectedIndexes.index(of: indexPath) {
            cell.colorPanel.alpha = 0.05
        } else {
            cell.colorPanel.alpha = 1.0
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("in numberOfSectionsInCollectionView()")
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("in collectionView(_:numberOfItemsInSection)")
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("in collectionView(_:cellForItemAtIndexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in collectionView(_:didSelectItemAtIndexPath)")
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        
        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
        if let index = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: index)
        } else {
            selectedIndexes.append(indexPath)
        }
        
        // Then reconfigure the cell
        configureCell(cell, atIndexPath: indexPath)
        
        // And update the buttom button
        updateBottomButton()
    }
    
    // MARK: - Actions and Helpers
    
    @IBAction func addColor(_ sender: UIButton) {
        
        let color = Color(insertIntoMangedObjectContext: sharedContext)
        color.value = .randomHSV
        
        coreDataClient.saveContext()
    }
    
    @IBAction func buttonButtonClicked() {
        
        if selectedIndexes.isEmpty {
            deleteAllColors()
        } else {
            deleteSelectedColors()
        }
    }
    
    func deleteAllColors() {
        
        for color in fetchedResultsController.fetchedObjects! {
            sharedContext.delete(color)
        }
        
        coreDataClient.saveContext()
        
        updateBottomButton()
    }
    
    func deleteSelectedColors() {
        var colorsToDelete = [Color]()
        
        for indexPath in selectedIndexes {
            colorsToDelete.append(fetchedResultsController.object(at: indexPath) )
        }
        
        for color in colorsToDelete {
            sharedContext.delete(color)
        }
        
        selectedIndexes = [IndexPath]()
        
        updateBottomButton()
    }
    
    func updateBottomButton() {
        if selectedIndexes.count > 0 {
            bottomButton.title = "Remove Selected Colors"
        } else {
            bottomButton.title = "Clear All"
        }
    }
    
}

// MARK: - Fetched Results Controller Delegate
extension ColorsViewController: NSFetchedResultsControllerDelegate {
    
    /**
     Whenever changes are made to Core Data the following three methods are
     invoked. This first method is used to create three fresh arrays to record
     the index paths that will be changed.
     */
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        /*
         New changes are about to occur. Start with empty arrays for each
         change type.
         */
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
        updatedIndexPaths.removeAll()
        
        print("in controllerWillChangeContent")
    }
    
    /**
     This method may be called multiple times, once for each Color object
     that is added, deleted, or changed.
     
     Store index paths into the corresponding array.
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            print("Insert an item")
            /**
             A new Color instance has been added to Core Data.
             
             The "newIndexPath" parameter contains the desired the index path
             for this case.
             
             Remember its index path to eventually add a cell during
             "controllerDidChangeContent".
             */
            insertedIndexPaths.append(newIndexPath!)
        case .delete:
            print("Delete an item")
            /**
             A Color instance has been removed from Core Data.
             
             The "indexPath" parameter contains the desired the index path
             for this case.
             
             Remember its index path to eventually remove a cell during
             "controllerDidChangeContent".
             */
            deletedIndexPaths.append(indexPath!)
        case .update:
            print("Update an item.")
            /**
             A Color instance has been updated in Core Data.
             
             Changes to Color instances is not expected after they are created.
             But Core Data would notify us of changes if any occured. This can
             be useful if you want to respond to changes that come about after
             data is downloaded.
             
             The "indexPath" parameter contains the desired the index path
             for this case.
             
             Remember its index path to eventually update a cell during
             "controllerDidChangeContent".
             */
            updatedIndexPaths.append(indexPath!)
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            /**
             A Color instance has been removed from Core Data.
             
             The "indexPath" parameter contains the current index path of the
             item and "newIndexPath" parameter contains the new index path of
             the item for this case.
             
             Remember these index path to eventually update a cell during
             "controllerDidChangeContent".
             */
            updatedIndexPaths.append(newIndexPath!)
            updatedIndexPaths.append(indexPath!)
        // default:
            // no default needed since all cases are handled
        }
    }
    
    
    /**
     This method is invoked after all of the changed objects in the current
     batch have been collected into the three index path arrays
     (insert, delete, and upate). We now need to loop through the arrays and
     perform the changes.
     
     The most interesting thing about the method is the collection view's
     "performBatchUpdates" method. Notice that all of the changes are performed
     inside a closure that is handed to the collection view.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
        
        collectionView.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
            
        }, completion: nil)
    }
}
