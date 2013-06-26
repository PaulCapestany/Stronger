//
//  DetailViewController.h
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
