//
//  ViewController.h
//  IceBreaker
//
//  Created by Shruthi Sridhar on 21/04/16.
//  Copyright (c) 2016 Koushik Ravikumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDelegate.h"
@interface ViewController :UIViewController <UITableViewDelegate, UITableViewDataSource,ChatDelegate> {
    
    UITableView *buddyView;
    NSMutableArray *onlineBuddies;
    
}

@property (nonatomic,retain) IBOutlet UITableView *buddyView;
//@property (nonatomic,retain) NSMutableArray *pendingMessages;
- (IBAction) showLogin;
//-(void)pendingMessages:(NSMutableDictionary *)message;
@end
