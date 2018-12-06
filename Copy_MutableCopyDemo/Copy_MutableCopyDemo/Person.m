//
//  Person.m
//  Copy_MutableCopyDemo
//
//  Created by CumminsTY on 2018/12/6.
//  Copyright © 2018 --. All rights reserved.
//

#import "Person.h"

@interface Person()<NSCopying,NSMutableCopying>
{
    NSMutableString *name;
    NSString *imutableStr;
    int age;
}
@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSString *imutableStr;
@property (nonatomic) int age;
@end

@implementation Person
@synthesize name;
@synthesize age;
@synthesize imutableStr;
- (id)init
{
    if (self = [super init])
    {
        self.name = [[NSMutableString alloc]init];
        self.imutableStr = [[NSString alloc]init];
        age = -1;
    }
    return self;
}
- (void)dealloc
{
    [name release];
    [imutableStr release];
    [super dealloc];
}
- (id)copyWithZone:(NSZone *)zone
{
    Person * copy = [[[self class] allocWithZone:zone] init];
    copy.name = [name copy];
    copy.imutableStr = [imutableStr copy];
  
    copy.age = age;
    return copy;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    Person *copy = [[[self class]mutableCopyWithZone:zone]init ];
    copy.name = [self.name mutableCopy];
    copy.age = age;
    return copy;
}

@end
