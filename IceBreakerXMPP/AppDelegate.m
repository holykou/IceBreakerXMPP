//
//  AppDelegate.m
//  IceBreaker
//
//  Created by Shruthi Sridhar on 22/04/16.
//  Copyright (c) 2016 Koushik Ravikumar. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewController.h"
@interface AppDelegate ()
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;

@end

@implementation AppDelegate
@synthesize _chatDelegate,_messageDelegate;

-(void)setupStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppStream setHostName:@"99.153.250.171"];
    [self.xmppStream setHostPort:5222];
}

-(void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

-(void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}


- (BOOL)connect {
    
    [self setupStream];
    
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    self.password = myPassword;
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    
    [self goOffline];
    [self.xmppStream disconnect];
    
}
#pragma mark XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    self.isOpen = YES;
    NSError *error = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.loginView activityIndicator] startAnimating];
        self.loginView.activityIndicator.hidden = NO;
        self.loginView.activityLabel.text = @"Authenticating...";
    });
    
    [[self xmppStream] authenticateWithPassword:_password error:&error];
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loginView authenticated];
    });
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return NO;
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    
    NSString *msg = [message body];
    //    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    if (msg) {
        [messageDictionary setObject:msg forKey:@"msg"];
        [messageDictionary setObject:[NSString stringWithFormat:@"%@",[message from]] forKey:@"sender"];
        if ([_messageDelegate respondsToSelector:@selector(newMessageReceived:)])
        {
            [_messageDelegate newMessageReceived:messageDictionary];
        }
//        else
//        {
//            [self.viewController pendingMessages:messageDictionary];
//        }
    }
    
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials!"
                                                        message:[NSString stringWithFormat:@"Could not authenticate! Tip: Don't forget to enter @<SERVERNAME> for the username field"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loginView.loginButton.hidden = NO;
        self.loginView.activityIndicator.hidden = YES;
        self.loginView.activityLabel.text = @"";
    });
    
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"tserv"]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"tserv"]];
            
        }
        
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self disconnect];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end