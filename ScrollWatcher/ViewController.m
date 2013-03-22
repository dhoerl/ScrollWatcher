//
//  ViewController.m
//  ScrollWatcher
//
//  Created by David Hoerl on 3/21/13.
//  Copyright (c) 2013 dhoerl. All rights reserved.
//

#include <unistd.h>

#import "ViewController.h"


static char *myContext = "myContext";



@interface ViewController ()
@end

@interface ViewController (UITableViewDataSource) <UITableViewDataSource>
@end

@interface ViewController (UITableViewDelegate) <UITableViewDelegate>
@end

@implementation ViewController
{
	IBOutlet UIView		*headerView;
	IBOutlet UILabel	*label;

	NSMutableArray		*titles;
	dispatch_queue_t	queue;
	
	__block uint64_t	counter;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	
	}
	return self;
}
- (void)dealloc
{
	NSLog(@"DEALLOC");
	[self removeObserver:self forKeyPath:@"isScrolling"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	queue = dispatch_queue_create("com.me.test", DISPATCH_QUEUE_SERIAL);
#if 1
	dispatch_async(queue, ^
		{
			while(YES) {
				++counter;
				if((counter % 1000000LL) == 0) {
					NSString *str = [NSString stringWithFormat:@"%llu is=%d", counter/1000000LL, self.isScrolling];
					dispatch_async(dispatch_get_main_queue(), ^
						{
							label.text = str;
						} );
					//usleep(100);
				}
				//if(self.isScrolling) sleep(1);
			}
		} );
#endif
	dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));

	[self addObserver:self forKeyPath:@"isScrolling" options:0 context:myContext];

	titles = [NSMutableArray arrayWithCapacity:100];
	for(int i=0; i<100; ++i) {
		[titles addObject:[NSString stringWithFormat:@"Cell %d", i]];
	}
	
	UIRefreshControl *rc = [UIRefreshControl new];
	[rc addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = rc;
}

- (void)changeSpeed:(BOOL)goFast
{
#if 1
	if(goFast == YES) {
		dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
	} else {
		dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
	}
#endif
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRow:(NSString *)str
{

}

- (IBAction)tableViewGotPulled:(id)sender
{



}
- (IBAction)refreshAction:(id)sender
{
	UIRefreshControl *rc = (UIRefreshControl *)sender;
	//NSLog(@"REFRESHING %d", rc.refreshing);

	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
		{
			if(rc.refreshing) {
				[rc endRefreshing];
			} else {
				[rc beginRefreshing];	
			}
		} );
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//NSLog(@"observeValueForKeyPath: context=%s keyPath=%@ change=%@", context, keyPath, change);

	if(context == myContext) {
		if([keyPath isEqualToString:@"isScrolling"]) {
			NSLog(@"isScrolling is %d", self.isScrolling);
			[self changeSpeed:!self.isScrolling];
		}
	} else {
		if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)])
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end

@implementation ViewController (UITableViewDataSource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
	}
	cell.textLabel.text = titles[indexPath.row];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [titles count];
}

@end

@implementation ViewController (UITableViewDelegate)

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return headerView.bounds.size.height;
}

@end
