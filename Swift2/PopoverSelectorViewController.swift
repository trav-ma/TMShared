//
//  PopoverSelectorViewController.swift
//  DemoCustomControls
//
//  Created by Travis Ma on 2/10/15.
//  Copyright (c) 2015 IMSHealth. All rights reserved.
//

import UIKit

class PopoverSelectorViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var tableData = [AnyObject]()
    var filteredTableData = [AnyObject]()
    var titleKey = ""
    var subtitleKey = ""
    var didSelectItem: ((AnyObject) -> Void)!
    var shouldShowSearchBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.view.frame.size
        searchBar.hidden = !shouldShowSearchBar
        searchBar.text = ""
        filteredTableData = tableData
    }
    
}

extension PopoverSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        didSelectItem(filteredTableData[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if (subtitleKey.isEmpty) {
            cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell")
            if (cell == nil) {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DefaultCell")
                cell?.textLabel!.textColor = UIColor.darkGrayColor()
                cell?.textLabel!.font = UIFont.systemFontOfSize(14)
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell")
            if (cell == nil) {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "SubtitleCell")
                cell?.textLabel!.textColor = UIColor.darkGrayColor()
                cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
                cell?.textLabel!.font = UIFont.systemFontOfSize(14)
                cell?.detailTextLabel?.font = UIFont.systemFontOfSize(10)
            }
        }
        cell!.imageView!.image = nil
        let item : AnyObject = filteredTableData[indexPath.row]
        if (item is String) {
            cell?.textLabel!.text = item as? String
        } else {
            let d = item as! [String: AnyObject]
            cell?.textLabel!.text = d[titleKey] as? String
            if (!subtitleKey.isEmpty) {
                cell?.detailTextLabel!.text = d[subtitleKey] as? String
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableData.count
    }
    
}

extension PopoverSelectorViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString
        if (text.isEmpty) {
            filteredTableData = tableData
        } else {
            filteredTableData = []
            let tokens = text.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
            let indices = (tableData as NSArray).indexesOfObjectsPassingTest({(obj: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
                var wasFound = true
                for token: String in tokens {
                    var searchableText : NSString = ""
                    if (obj is String) {
                        searchableText = obj as! NSString
                    } else {
                        let d = obj as! NSDictionary
                        searchableText = d[self.titleKey]!.uppercaseString + " " + (self.subtitleKey.isEmpty || d[self.subtitleKey] == nil ? "" : d[self.subtitleKey]!.uppercaseString)
                    }
                    if (searchableText.rangeOfString(token).location == NSNotFound) {
                        wasFound = false
                        break
                    }
                }
                return wasFound
            })
            filteredTableData += (tableData as NSArray).objectsAtIndexes(indices)
        }
        tableView.reloadSections(NSIndexSet(index:0), withRowAnimation: .Automatic)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}