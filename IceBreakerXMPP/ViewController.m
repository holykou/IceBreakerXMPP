//
//  ViewController.m
//  IceBreaker
//
//  Created by Shruthi Sridhar on 21/04/16.
//  Copyright (c) 2016 Koushik Ravikumar. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "XMPP.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize buddyView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.buddyView.delegate = self;
    self.buddyView.dataSource = self;
    onlineBuddies = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = [self appDelegate];
    appDelegate._chatDelegate = self;
    appDelegate.viewController = self;
    
}

//methods to ensure Presence of users are reflected
-(void)newBuddyOnline:(NSString *)buddyName
{
    [onlineBuddies addObject:buddyName];
    [self.buddyView reloadData];
}

-(void)buddyWentOffline:(NSString *)buddyName
{
    [onlineBuddies removeObject:buddyName];
    [self.buddyView reloadData];
}

//Action when user logs out
- (void) showLogin {
    [[(AppDelegate *)[self appDelegate] xmppStream] disconnect];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userPassword"];
    [[self appDelegate] loginView].enteredPassword.text = @"";
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
    return [[self appDelegate] xmppStream];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.buddyView reloadData];
}

#pragma mark -
#pragma mark Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"UserCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [onlineBuddies count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *userName = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    [chatViewController setUser:userName];
    [chatViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    XMPPPresence *presence = [XMPPPresence presence];
    [[[self appDelegate] xmppStream] sendElement:presence];
    [self presentViewController:chatViewController animated:YES completion:^{
        
    }];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Online Buddies";
            break;
            
    }
    return sectionName;
}
@end