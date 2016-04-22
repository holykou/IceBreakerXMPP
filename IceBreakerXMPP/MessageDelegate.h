//
//  MessageDelegate.h
//  
//
//  Created by Shruthi Sridhar on 22/04/16.
//
//

#import <Foundation/Foundation.h>

@protocol MessageDelegate <NSObject>

- (void)newMessageReceived:(NSDictionary *)messageContent;

@end
