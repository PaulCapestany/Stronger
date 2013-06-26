//
//  MasterViewController.h
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
