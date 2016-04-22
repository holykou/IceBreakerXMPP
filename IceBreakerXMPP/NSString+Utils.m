//
//  NSString+Date.m
//  JabberClient
//
//  Created by cesarerocchi on 9/12/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "NSString+Utils.h"


@implementation NSString (Utils)

+ (NSString *) getCurrentTime {

	NSDate *nowUTC = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	return [dateFormatter stringFromDate:nowUTC];
	
}


@end
