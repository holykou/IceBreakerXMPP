//
//  ChatViewController.m
//  
//
//  Created by Shruthi Sridhar on 22/04/16.
//
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.chatView.delegate = self;
    self.chatView.dataSource = self;
    if (!self.messages) {
        self.messages = [[NSMutableArray alloc ] init];
    }
    AppDelegate *del = [self appDelegate];
    del._messageDelegate = self;
    [self.messageField becomeFirstResponder];
    
}

- (void) setUser:(NSString *) userName {
        self.chatWithUser = userName;
}
#pragma mark -
#pragma mark Actions

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
    return [[self appDelegate] xmppStream];
}

- (IBAction) closeChat {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//Method to send a message to a user using the xmpp protocol
- (IBAction)sendMessage {
    
    NSString *messageString = self.messageField.text;
    
    if([messageString length] > 0) {
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageString];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.chatWithUser];
        [message addChild:body];
        
        [self.xmppStream sendElement:message];
        
        self.messageField.text = @"";
        
        NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
        [messageDictionary setObject:messageString forKey:@"msg"];
        [messageDictionary setObject:@"you" forKey:@"sender"];
        [messageDictionary setObject:[NSString getCurrentTime] forKey:@"time"];
        [self.messages addObject:messageDictionary];
        [self.chatView reloadData];
    }
    
}
//method to handle receiving of messages
- (void)newMessageReceived:(NSMutableDictionary *)messageContent {
    
    NSString *m = [messageContent objectForKey:@"msg"];
    
    [messageContent setObject:m forKey:@"msg"];
    [messageContent setObject:[NSString getCurrentTime] forKey:@"time"];
    [self.messages addObject:messageContent];
    [self.chatView reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1
                                                   inSection:0];
    
    [self.chatView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
}

#pragma mark -
#pragma mark Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *senderDictionary = (NSDictionary *) [self.messages objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"MessageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    //formatting the texts sent and received based on sender
    cell.textLabel.text = [senderDictionary objectForKey:@"msg"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",[senderDictionary objectForKey:@"sender"],[senderDictionary objectForKey:@"time"]];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if ([[senderDictionary objectForKey:@"sender"] isEqualToString:@"you"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.messages count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = self.chatWithUser;
            break;
        
    }
    return sectionName;
}
#pragma mark -
#pragma mark Chat delegates
//To ensure word wrapping of long texts and creating a dynamic table view cell
static CGFloat padding = 20.0;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    
    CGSize  textSize = { 260.0, 10000.0 };
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
                  constrainedToSize:textSize
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += padding*2;
    
    CGFloat height = size.height < 65 ? 65 : size.height;
    return height;
    
}
// react to the message received

@end