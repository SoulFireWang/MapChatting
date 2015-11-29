//
//  ViewController.m
//  LTInfiniteScrollView
//
//  Created by ltebean on 14/11/21.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "SFImageViewController.h"
#import "LTInfiniteScrollView.h"
#import "SFPersonHeadView.h"
#import "SFPersonEnity.h"
#import "SFConstants.h"

#define COLOR [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]

#define NUMBER_OF_VISIBLE_VIEWS 5

@interface SFImageViewController ()<LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>
@property (nonatomic,strong) LTInfiniteScrollView *scrollView;
@property (nonatomic) CGFloat viewSize;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong)NSArray *images;



@end

@implementation SFImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.v
    
    self.title = @"头像";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];
}

-(void)saveClick:(UIButton *)sender{
    NSLog(@"保存信息");
    
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_PERSON_IMAGE object:self userInfo:@{NOTIFICATION_UPDATE_PERSON_IMAGE: self.image}];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.scrollView = [[LTInfiniteScrollView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 400)];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    self.scrollView.pagingEnabled= NO;
    
    self.viewSize = CGRectGetWidth(self.view.bounds) / NUMBER_OF_VISIBLE_VIEWS;
    [self.scrollView reloadData];
    
}

# pragma mark - LTInfiniteScrollView dataSource
- (NSInteger)numberOfViews
{
    return 999;
}

- (NSInteger)numberOfVisibleViews
{
    return NUMBER_OF_VISIBLE_VIEWS;
}

# pragma mark - LTInfiniteScrollView delegate
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    SFPersonHeadView *personHeadView = (SFPersonHeadView *)view;
    SFPersonEnity *person = [SFPersonEnity new];
    
    int imageIndex = 0;
    
    if (index < 0) {
        imageIndex = self.images.count - (-1 * index) % self.images.count - 1;
    }else{
        imageIndex = index % self.images.count;
    }
    
    person.imageURL = self.images[imageIndex];
    
    self.image = self.images[(self.images.count + imageIndex - 3) % self.images.count];
    
    self.imageView.image = [UIImage imageNamed:self.image];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.borderWidth = 3;
    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.borderColor = [SFConstants themeColor].CGColor;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    if (view) {
        personHeadView.person = person;
        return personHeadView;
    }
    
    personHeadView = [[SFPersonHeadView alloc]initWithPerson:person andWidth:self.viewSize];

    return personHeadView;
}

- (void)updateView:(UIView *)view withDistanceToCenter:(CGFloat)distance scrollDirection:(ScrollDirection)direction
{
    // you can appy animations duration scrolling here
    
    CGFloat percent = distance / CGRectGetWidth(self.view.bounds) * NUMBER_OF_VISIBLE_VIEWS;
    
    CATransform3D transform = CATransform3DIdentity;
    
    // scale
    CGFloat size = self.viewSize;
    CGPoint center = view.center;
    view.center = center;
    size = size * (1.4 - 0.3 * (fabs(percent)));
    view.frame = CGRectMake(0, 0, size, size);
    view.layer.cornerRadius = size / 2;
    view.center = center;
    
    // translate
    CGFloat translate = self.viewSize / 3 * percent;
    if (percent > 1) {
        translate = self.viewSize / 3;
    } else if (percent < -1) {
        translate = -self.viewSize / 3;
    }
    transform = CATransform3DTranslate(transform,translate, 0, 0);
    
    // rotate
    if (fabs(percent) < 1) {
        CGFloat angle = 0;
        if( percent > 0) {
            angle = - M_PI * (1-fabs(percent));
        } else {
            angle =  M_PI * (1-fabs(percent));
        }
        transform.m34 = 1.0/-600;
        if (fabs(percent) <= 0.5) {
            angle =  M_PI * percent;
//            UILabel *label = (UILabel*) view;
//            label.text = @"back";
//            label.backgroundColor = [UIColor darkGrayColor];
        } else {
//            UILabel *label = (UILabel*) view;
//            label.text = [NSString stringWithFormat:@"%d",(int)view.tag];
//            label.backgroundColor = COLOR;
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    } else {
//        UILabel *label = (UILabel *)view;
//        label.text = [NSString stringWithFormat:@"%d",(int)view.tag];
//        label.backgroundColor = COLOR;
    }
    
    view.layer.transform = transform;
    
}

# pragma mark - config views
- (void)configureForegroundOfLabel:(UILabel *)label
{
    NSString *text = [NSString stringWithFormat:@"%d",(int)label.tag];
    if ([label.text isEqualToString:text]) {
        return;
    }
    label.text = text;
    label.backgroundColor = COLOR;
}

- (void)configureBackgroundOfLabel:(UILabel *)label
{
    NSString* text = @"back";
    if ([label.text isEqualToString:text]) {
        return;
    }
    label.text = text;
    label.backgroundColor = [UIColor blackColor];
}
- (NSArray *)images {
	if(_images == nil) {
		_images = @[@"52d7f86606988622.jpg!200x200", @"5042ef0132e13_200x200_3", @"130119165848004", @"rBACE1LP8UKwL0FcAAAeyQH9soc176_200x200_3", @"rBACE1NzOQOzNKD5AAB3cJB_RW0336_200x200_3", @"rBACE1OYPoyzwUb8AAAbiR4VA0w215_200x200_3", @"rBACE1P1rDzj1Io1AAAaEl08MDQ481_200x200_3", @"rBACE1PUY1vyW_WUAAAYpkeZVpY967_200x200_3", @"rBACFFHybr_StWCEAAAhkjZOycI762_200x200_3", @"rBACFFOYPoyih-G3AAAjXyz4XMk996_200x200_3", @"rBACFFPSD3yDf8EMAADeQiNCD2Y614_200x200_3", @"u=1920132780,2115968557&fm=21&gp=0", @"u=2463451128,2027855742&fm=21&gp=0", @"u=4196456247,3870486792&fm=21&gp=0"];
	}
	return _images;
}

- (UIImageView *)imageView {
	if(_imageView == nil) {
		_imageView = [[UIImageView alloc] init];
        
        _imageView = [UIImageView new];
        
        _imageView.frame = CGRectMake(100, 50, 120, 120);
        
        _imageView.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:_imageView];
	}
	return _imageView;
}

@end
