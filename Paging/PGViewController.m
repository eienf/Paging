//
//  PGViewController.m
//  Paging
//
//  Created by eien.support@gmail.com on 2014/02/23.
//  Copyright (c) 2014年 Eien Factory Ltd. All rights reserved.
//

#import "PGViewController.h"
#import "PGPageViewController.h"

@interface PGViewController ()

@property (assign) NSInteger pageNumber;

@end

const NSInteger kPageMax = 3;

@implementation PGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < kPageMax; i++ ) {
        PGPageViewController *pageViewController;
        pageViewController = [[PGPageViewController alloc]
                                                    initWithNibName:@"PGPageViewController"
                                                    bundle:nil];
        [self.scrollView addSubview:pageViewController.view];
        pageViewController.labelView.text = [NSString stringWithFormat:@"%d",i + 1];
        [self addChildViewController:pageViewController];
    }
    self.pageNumber = 0;
    self.pagingView.numberOfPages = kPageMax;
    self.pagingView.currentPage = self.pageNumber;
    [self scrollViewDidScroll:self.scrollView];
}

- (void)adjustSubviews
{
    CGRect aRect = self.scrollView.frame;
    int i = 0;
    for (UIViewController *viewController in self.childViewControllers) {
        viewController.view.frame = CGRectMake(aRect.size.width*(i++),
                                               0,
                                               aRect.size.width,
                                               aRect.size.height);
    }
    self.scrollView.contentSize = CGSizeMake(aRect.size.width * kPageMax,
                                             aRect.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustSubviews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self adjustSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (self.pageNumber != page) {
        self.pageNumber = page;
        self.pagingView.currentPage = self.pageNumber;
    }
}

- (IBAction)pageControlDidChanged:(id)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pagingView.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
