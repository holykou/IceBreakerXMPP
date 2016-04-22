//
//  ChatViewController.h
//  
//
//  Created by Shruthi Sridhar on 22/04/16.
//
//

#import <UIKit/UIKit.h>
#import "MessageDelegate.h"

//This view controller manages the chat screen
@interface ChatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, MessageDelegate>

@property (nonatomic,retain) IBOutlet UITextField *messageField;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) IBOutlet UITableView *chatView;

- (void) setUser:(NSString *) userName;
- (IBAction) sendMessage;
- (IBAction) closeChat;

@end