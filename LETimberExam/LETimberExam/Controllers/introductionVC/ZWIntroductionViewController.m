#import "ZWIntroductionViewController.h"

@interface ZWIntroductionViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *backgroundViews;
@property (nonatomic, strong) NSArray *scrollViewPages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger centerPageIndex;

@end

@implementation ZWIntroductionViewController

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames];
    }
    return self;
}

- (id)initWithBackgroundImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithBackgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames button:(UIButton *)button
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backgroundImageNames = bgNames;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames
{
    self.coverImageNames = coverNames;
}

- (void)initSelfWithBackgroundImageNames:(NSArray *)bgNames
{
    self.backgroundImageNames = bgNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackgroundViews];
    
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.pagingScrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    
    if (!self.enterButton) {
        self.enterButton = [UIButton new];
        [self.enterButton setTitle:NSLocalizedString(@"开始体验", nil) forState:UIControlStateNormal];
        
        
        _enterButton.titleLabel.font =  [UIFont fontWithName:@"Heiti SC" size:24];
        [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.enterButton.layer.borderWidth = 0.5;
//        self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.enterButton setBackgroundColor:[UIColor clearColor]];
        
        [self.enterButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.enterButton.layer setBorderWidth:1];
        [self.enterButton.layer setMasksToBounds:YES];
        self.enterButton.layer.cornerRadius = 15.0;
    }
    if (!self.passButton) {
        self.passButton = [UIButton new];
        [self.passButton setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        
        
        self.passButton.titleLabel.font =  [UIFont fontWithName:@"Heiti SC" size:16];
        [self.passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        self.enterButton.layer.borderWidth = 0.5;
        //        self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.passButton setBackgroundColor:[UIColor clearColor]];
        
//        [self.passButton.layer setBorderColor:[UIColor whiteColor].CGColor];
//        [self.passButton.layer setBorderWidth:1];
//        [self.passButton.layer setMasksToBounds:YES];
        [self.passButton setBackgroundImage:[UIImage imageNamed:@"引导_03(3)"] forState:UIControlStateNormal];
        self.passButton.layer.cornerRadius = 15.0;
    }
    
    
    [self.enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    self.enterButton.frame = [self frameOfEnterButton];
    self.enterButton.alpha = 0;
    [self.passButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    self.passButton.frame = [self frameOfPassButton];
    self.passButton.alpha =1;
    
    [self.view addSubview:self.enterButton];
    [self.view addSubview:self.passButton];
    
    [self reloadPages];
}

- (void)addBackgroundViews
{
    CGRect frame = self.view.bounds;
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self backgroundImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        [self.view addSubview:imageView];
    }];
    
    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)reloadPages
{
    self.pageControl.numberOfPages = [[self coverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];
    
    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.pagingScrollView addSubview:obj];
        
        x += obj.frame.size.width;
    }];
    
    // fix enterButton can not presenting if ScrollView have only one page
    if (self.pageControl.numberOfPages == 1) {
        self.enterButton.alpha = 1;
        self.passButton.alpha = 0;
        self.pageControl.alpha = 0;
    }else{
    
    }
    
    // fix ScrollView can not scrolling if it have only one page
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
}

- (CGRect)frameOfEnterButton
{
    CGSize size = self.enterButton.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.8, 50);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height-20, size.width, size.height);
}
- (CGRect)frameOfPassButton
{
//    CGSize size = self.passButton.bounds.size;
    CGSize size = CGSizeMake(60, 28);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.8, 50);
    }
    return CGRectMake(self.view.frame.size.width  - size.width -10, 20, size.width, size.height);
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
    
    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
            [self.passButton setAlpha:alpha];
        }
    }
    
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
 
    switch (self.pageControl.currentPage) {
        case 0:
            [self.passButton setBackgroundImage:[UIImage imageNamed:@"ic_introduce_btn1"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.passButton setBackgroundImage:[UIImage imageNamed:@"ic_introduce_btn2"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.passButton setBackgroundImage:[UIImage imageNamed:@"ic_introduce_btn3"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

    
    [self pagingScrollViewDidChangePages:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        if (![self hasNext:self.pageControl]) {
            [self enter:nil];
        }
    }
}

#pragma mark - UIScrollView & UIPageControl DataSource

- (BOOL)hasNext:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self coverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.enterButton.alpha = 0;
            self.passButton.alpha = 1;
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 1;
                self.passButton.alpha = 0;
                self.pageControl.alpha = 0;
            }];
        }
    } else {
        if (self.pageControl.alpha == 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 0;
                self.pageControl.alpha = 1;
                self.passButton.alpha = 1;
            }];
        }
    }
}

- (BOOL)hasEnterButtonInView:(UIView*)page
{
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && obj == self.enterButton) {
            result = YES;
        }
    }];
    return result;
}

- (UIImageView*)scrollViewPage:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize size = {[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

- (NSArray*)scrollViewPages
{
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageView *v = [self scrollViewPage:obj];
        [tmpArray addObject:v];
        
    }];
    
    _scrollViewPages = tmpArray;
    
    return _scrollViewPages;
}

- (CGSize)contentSizeOfScrollView
{
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}

#pragma mark - Action

- (void)enter:(id)object
{
    self.didSelectedEnter();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end