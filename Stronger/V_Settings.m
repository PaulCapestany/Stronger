//
//  V_Settings.m
//  CBLDemo
//
//  Created by Jens Alfke on 8/8/11.
//  Copyright 2011 TDbase, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.

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
