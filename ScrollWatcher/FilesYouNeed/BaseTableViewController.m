//
//  BaseTableViewController.m
//  ScrollWatcher
//
//  Created by David Hoerl on 3/21/13.
//  Copyright (c) 2013 dhoerl. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property (nonatomic, assign, readwrite) BOOL isScrolling;

@end

@interface BaseTableViewController (UIScrollViewDelegate)
@end

@implementation BaseTableViewController
@end

@implementation BaseTableViewController (UIScrollViewDelegate)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	//[super scrollViewWillBeginDragging:scrollView];	// pull to refresh

	self.isScrolling = YES;
	NSLog(@"+scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];	// pull to refresh

	if(!decelerate) {
		self.isScrolling = NO;
	}
	NSLog(@"%@scrollViewDidEndDragging", self.isScrolling ? @"" : @"-");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.isScrolling = NO;
	NSLog(@"-scrollViewDidEndDecelerating");
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{	
	self.isScrolling = NO;
	NSLog(@"-scrollViewDidScrollToTop");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	self.isScrolling = NO;
	NSLog(@"-scrollViewDidEndScrollingAnimation");
}

#if 0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];	// pull to refresh
}
#endif

@end
