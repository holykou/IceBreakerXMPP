//
//  ChatDelegate.h
//  
//
//  Created by Shruthi Sridhar on 22/04/16.
//
//


//A protocol to ensure buddy list stays updated

#import <Foundation/Foundation.h>

@protocol ChatDelegate <NSObject>

- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;

@end
