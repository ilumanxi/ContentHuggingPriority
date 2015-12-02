//
//  MyView.m
//  ContentHuggingPriority
//
//  Created by lumanxi on 15/10/23.
//  Copyright © 2015年 fanfan. All rights reserved.
//

#import "MyView.h"

@implementation MyView

//改写UIView的intrinsicContentSize
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(70, 40);
}
@end
