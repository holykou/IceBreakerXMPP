//
//  AppDelegate.h
//  IceBreaker
//
//  Created by Shruthi Sridhar on 22/04/16.
//  Copyright (c) 2016 Koushik Ravikumar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPP.h"
#import "ChatDelegate.h"
#import "MessageDelegate.h"

@class ViewController,LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>
{
    __weak NSObject <ChatDelegate> *_chatDelegate;
    __weak NSObject <MessageDelegate> *_messageDelegate;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginView;
@property (nonatomic, retain) IBOutlet ViewController *viewController;
@property (nonatomic, retain) XMPPStream *xmppStream;
@property (nonatomic, retain) NSString *password;
@property (assign,nonatomic) BOOL isOpen;

@property (weak,nonatomic) id _chatDelegate;
@property (weak,nonatomic) id _messageDelegate;
- (BOOL)connect;
- (void)disconnect;
@end

