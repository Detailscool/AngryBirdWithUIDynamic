//
//  ViewController.m
//  AngryBirdWithUIDynamic
//
//  Created by Detailscool on 16/1/17.
//  Copyright © 2016年 Detailscool. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic,weak)UIView * redView;
@property (nonatomic,weak)UIView * blueView;

@property (nonatomic,weak)UIPanGestureRecognizer * pan;

@property (nonatomic,strong)UIDynamicAnimator * animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * redView = [[UIView alloc]initWithFrame:CGRectMake(150, 250, 30, 30)];
    redView.backgroundColor = [UIColor redColor];
    self.redView = redView;
    [self.view addSubview:redView];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    self.pan = pan;
    [redView addGestureRecognizer:pan];
    
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(600, 200, 30, 30)];
    blueView.backgroundColor = [UIColor blueColor];
    self.blueView = blueView;
    [self.view addSubview:blueView];
    
    UIScreen *screen =[UIScreen mainScreen];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    UIButton * reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake((screen.bounds.size.width -100)*0.5, 20, 100, 50)];
    [reloadBtn setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:reloadBtn];
    [reloadBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}



- (void)reload{
    
    ViewController * vc = [[ViewController alloc]init];
//    vc.view = [[MyView alloc]init];
//    vc.view.backgroundColor = [UIColor whiteColor];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = vc;
}

- (void)loadView{
    
    self.view = [[MyView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{

    CGPoint currentPoint = [pan locationInView:self.view];
    CGPoint panCentre = pan.view.center;
    CGFloat offsetX = currentPoint.x - panCentre.x;
    CGFloat offsetY = currentPoint.y - panCentre.y;
    CGFloat distance = sqrt(pow(offsetX, 2)+pow(offsetY, 2));
    
    if (distance >80) {
        CGFloat angle = atan2(offsetY, offsetX);
        offsetX = 80 * cos(angle);
        offsetY = 80 * sin(angle);
    }
    
    self.redView.transform = CGAffineTransformMakeTranslation(offsetX, offsetY);
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        UIPushBehavior * push = [[UIPushBehavior alloc]initWithItems:@[self.redView] mode:UIPushBehaviorModeInstantaneous];
        push.magnitude = distance/80;
        push.angle = atan2(-offsetY, -offsetX);
        [self.animator addBehavior:push];
        
        UICollisionBehavior * collision = [[UICollisionBehavior alloc]initWithItems:@[self.redView,self.blueView]];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        collision.collisionDelegate = self;
        [self.animator addBehavior:collision];
        
        UIGravityBehavior * gravity = [[UIGravityBehavior alloc]initWithItems:@[self.redView]];
        gravity.magnitude = 1;
        [self.animator addBehavior:gravity];
        
        [self.redView removeGestureRecognizer:self.pan];
        
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
    UIGravityBehavior * gravityBlue = [[UIGravityBehavior alloc]initWithItems:@[self.blueView]];
    gravityBlue.magnitude = 1;
    [self.animator addBehavior:gravityBlue];

}

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}

@end
