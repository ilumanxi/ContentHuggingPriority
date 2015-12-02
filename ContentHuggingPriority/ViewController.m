//
//  ViewController.m
//  ContentHuggingPriority
//
//  Created by lumanxi on 15/10/23.
//  Copyright © 2015年 fanfan. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"


/*
 
         iOS: 让自定义控件适应Autolayout注意的问题
         第一个是initWithCoder方法：因为开发者多在Storyboard中使用Autolayout，而Storyboard中的View初始化不是使用常见的initWithFrame方法的，而是使用initWithCoder方法来初始化View。因此自定义控件有初始化逻辑的话（如设置变量默认值什么的），注意不要只写在initWithFrame方法里。
         
         第二个是UIView的translatesAutoresizingMaskIntoConstraints属性，如果使用Autolayout，则不需要将古老的AutoresizingMask转换成Autolayout的Constraint。这个属性默认是YES，不过貌似Storyboard创建时调用initWithCoder方法时控件的translatesAutoresizingMaskIntoConstraints已经是NO了。
         
         第三个是UIView的contentMode属性，如果在Autolayout改变控件尺寸后需要刷新drawRect，则需要设置contentMode属性为UIViewContentModeRedraw。而另一个常见的自定义控件依赖的方法：layoutSubviews，则会被自动调用，这里不需要担心。
 
        Autolayout的话题。先说intrinsicContentSize，也就是控件的内置大小。比如UILabel，UIButton等控件，他们都有自己的内置大小。控件的内置大小往往是由控件本身的内容所决定的，比如一个UILabel的文字很长，那么该UILabel的内置大小自然会很长。控件的内置大小可以通过UIView的intrinsicContentSize属性来获取内置大小，也可以通过invalidateIntrinsicContentSize方法来在下次UI规划事件中重新计算intrinsicContentSize。如果直接创建一个原始的UIView对象，显然它的内置大小为0。
 
 
*/
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //创建一个UIView，利用上面的辅助方法快速设置其在父控件的左，上，右边距为20单位
    MyView *view1 = [MyView new];
    view1.backgroundColor = [UIColor yellowColor];
    //不允许AutoresizingMask转换成Autolayout
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view1];
    //设置左，上，右边距为20.
    [self setEdge:self.view view:view1 attr:NSLayoutAttributeLeft constant:20];
    [self setEdge:self.view view:view1 attr:NSLayoutAttributeTop constant:20];
    [self setEdge:self.view view:view1 attr:NSLayoutAttributeRight constant:-20];
    
    
    //距离父控件边距左，下，右各为20
    MyView *view2 = [MyView new];
    view2.backgroundColor = [UIColor yellowColor];
    //不允许AutoresizingMask转换成Autolayout
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view2];
    //设置左，下，右边距为20.
    
    
    
    //设置两个View上下间距为20

    //接下来，通过代码加入Autolayout中的间距。命令view1和view2上下必须间隔20个单位，注意这里要求view2在view1之下的20单位，所以创建NSLayoutConstraint中view2参数在前面。同时注意，view2的attribute参数是NSLayoutAttributeTop，而view1的attribute参数是NSLayoutAttributeBottom：
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self setEdge:self.view view:view2 attr:NSLayoutAttributeLeft constant:20];
    [self setEdge:self.view view:view2 attr:NSLayoutAttributeBottom constant:-20];
    [self setEdge:self.view view:view2 attr:NSLayoutAttributeRight constant:-20];
    

    //设置两个View上下间距为20
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    
   // Content Hugging Priority代表控件拒绝拉伸的优先级。优先级越高，控件会越不容易被拉伸。

    //Content Compression Resistance Priority代表控件拒绝压缩内置空间的优先级。优先级越高，控件的内置空间会越不容易被压缩。而这里的内置空间，就是上面讲的UIView的intrinsicContentSize。
    
//    所以，如果我们把view1（上图中被拉伸的，在上面的View）的Content Hugging Priority设置一个更高的值，那么当Autolayout遇到这种决定谁来拉伸的情况时，view1不会被优先拉伸，而优先级稍低的view2才会被拉伸。
    
    
    
//    可以直接通过UIView的setContentHuggingPriority:forAxis方法来设置控件的Content Hugging Priority，其中forAxis参数代表横向和纵向，本例中只需要设置纵向，所以传入UILayoutConstraintAxisVertical。整句代码：
    
    //提高view1的Content Hugging Priority
     UILayoutPriority layoutPrior = [view1 contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    
    [view1 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
   layoutPrior = [view1 contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    
}

//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:1.0 constant:constant]];
}
@end
