//
//  V_Settings.m
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "AppDelegate.h"
#import "V_Settings.h"
#import <CouchbaseLite/CouchbaseLite.h>


@implementation V_Settings


- (id)init {
    LogFunc;

    self = [super initWithNibName:@"V_Settings" bundle:nil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Configure Sync";

        UIBarButtonItem *purgeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(done:)];
        self.navigationItem.leftBarButtonItem = purgeButton;
    }
    return self;
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    LogFunc;

    [super viewWillAppear:animated];
}

// triggered by console button push
- (IBAction)pairViaConsole:(id)sender {
    LogFunc;

//    set view to pairing-info style
}

//facebook button was clicked
- (IBAction)pairViaFacebook:(id)sender {
    LogFunc;
}

- (void)pop {
    LogFunc;


    UINavigationController *navController = (UINavigationController *)self.parentViewController;
    [navController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
    LogFunc;

    [self pop];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    LogFunc;

    if (buttonIndex > 0) {
        [self pop]; // Go back to the main screen without saving the URL
    }
}

@end
