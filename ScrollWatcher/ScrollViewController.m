//
//  ScrollViewController.m
//  ScrollWatcher
//
//  Created by David Hoerl on 5/2/13.
//  Copyright (c) 2013 dhoerl. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign, readwrite) BOOL isScrolling;
@property (strong, nonatomic) IBOutlet UIView *blueView;

@end

@interface ScrollViewController (UIScrollViewDelegate) <UIScrollViewDelegate>
@end


@implementation ScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self.scrollView addSubview:self.blueView];
	self.scrollView.contentSize = self.blueView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation ScrollViewController (UIScrollViewDelegate)

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

