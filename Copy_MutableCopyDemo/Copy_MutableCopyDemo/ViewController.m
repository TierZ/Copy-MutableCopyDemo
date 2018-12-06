//
//  ViewController.m
//  Copy_MutableCopyDemo
//
//  Created by CumminsTY on 2018/12/6.
//  Copyright © 2018 --. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testString1];
//    [self testString2];
//    [self testArray1];
//    [self testArray2];
    [self testArray3];
}

-(void)testString1{
    NSString * str1 = @"hello world";
    NSString * str2 = [str1 copy];
    NSMutableString * str3 = [str1 copy];
    NSMutableString * str4 = [str1 mutableCopy];
    [str4 appendString:@"!!!"];
    NSString * str5 = [str1 mutableCopy];
    NSLog(@"\n %p \n %p \n %p \n %p \n %p",str1,str2,str3,str4,str5);
    /*
     0x1006a2068
     0x1006a2068
     0x1006a2068
     0x6000008a2be0
     0x60000271b030

     打印的四个地址，可以看出 str2 、str3与str1 内存地址都一样。指向的是同一块内存区域，此时str2，str3的引用计数和str1的一样都为２。而str4，str5则是我们所说的真正意义上的复制，系统为其分配了新内存，但指针所指向的字符串还是和string所指的一样。
     */
}
-(void)testString2{
    NSMutableString * str1 = [NSMutableString stringWithFormat:@"hello world"];
    NSString * str2 = [str1 copy];
    NSMutableString * str3 = [str1 copy];
    NSString * str4 = [str1 mutableCopy];
    NSMutableString * str5 = [str1 mutableCopy];
    [str1 appendString:@"!!!"];
//    [str3 appendString:@"!!!!"]; //报错： Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attempt to mutate immutable object with appendString:'
    [str5 appendString:@"!!!!!"];
    NSLog(@"\n %p \n %p \n %p \n %p \n %p",str1,str2,str3,str4,str5);
    NSLog(@"\n");
    NSLog(@"\n %@ \n %@ \n %@ \n %@ \n %@",str1,str2,str3,str4,str5);

    /*
     0x6000003553b0
     0x600000d58e20
     0x600000d58e00
     0x6000003557a0
     0x6000003554d0
     
     打印的四个地址，可以看出 5个字符串的内存地址都不一样，但是对于str3其实是个imutable对象，所以当调用方法[str3 appendString:@"!!!!"]时会报错。
     对于系统的非容器类对象，我们可以认为，如果对一不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。
     如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的。。
     */
}

-(void)testArray1{
    NSArray * arr1 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    NSLog(@"  %ld",[arr1 retainCount]);
    NSArray * arr2 = [arr1 copy];
     NSLog(@" %ld -- %ld",[arr1 retainCount],[arr2 retainCount]);
    NSArray * arr3 = [arr1 mutableCopy];
    NSLog(@" %ld -- %ld --- %ld",[arr1 retainCount],[arr2 retainCount],[arr3 retainCount]);
    NSMutableArray * arr4 = [arr1 copy];
    NSLog(@" %ld -- %ld --- %ld -- %ld",[arr1 retainCount],[arr2 retainCount],[arr3 retainCount],[arr4 retainCount]);
    NSMutableArray * arr5 = [arr1 mutableCopy];
    NSLog(@" %ld -- %ld --- %ld -- %ld --- %ld",[arr1 retainCount],[arr2 retainCount],[arr3 retainCount],[arr4 retainCount],[arr5 retainCount]);
    
    
    
    
//    [arr4 addObject:@"5"]; //会崩溃，Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSArrayI addObject:]: unrecognized selector sent to instance 0x6000038dc450'  本质上copy后的内容为不可变。
    [arr5 addObject:@"6"];
    
    NSLog(@"\n %p \n %p \n %p \n %p \n %p",arr1,arr2,arr3,arr4,arr5);
    NSLog(@"\n");
    
    /*
     0x6000037e1ce0
     0x6000037e1ce0
     0x6000037e2190
     0x6000037e1ce0
     0x6000037e2010
     可以看出 copy操作后的内存地址不变，为指针复制。，mutablecopy 为对象复制，
     //copy操作后的数组和arr1同一个NSArray对象（指向相同的对象），包括arr1里面的元素也是指向相同的指针
     //mutableCopy操作后的数组是arr1的可变副本，指向的对象和arr1不同，但是其中的元素和arr1中的元素指向的是同一个对象。mutableCopy后的数组还可以修改自己的对象
     copy是指针复制，而mutableCopy是对象复制，mutableCopy还可以改变期内的元素：删除或添加。但是注意的是，容器内的元素内容都是指针复制。
     */
}
-(void)testArray2{
    NSArray * arr = [NSArray arrayWithObjects:[NSMutableString stringWithFormat:@"abc"],@"1",@"2",@"3", nil];
    NSLog(@"retainCount= %ld",[arr retainCount]);
    NSArray * arr2 = [arr copy];
    NSLog(@"retainCount2= %ld",[arr retainCount]);
    NSMutableArray * arr3 = [arr mutableCopy];
    NSLog(@"retainCount3= %ld",[arr retainCount]);
    NSMutableString * str = arr[0];
    [str appendString:@"def"];
    
    NSLog(@"arr = %@ \n arr2 = %@ \n arr3 = %@\n",arr,arr2,arr3);
    /*
     arr = (
     abcdef,
     1,
     2,
     3
     )
     arr2 = (
     abcdef,
     1,
     2,
     3
     )
     arr3 = (
     abcdef,
     1,
     2,
     3
     )
     
     可以发现修改后所有的数组 都变了，由此可见对于容器而言，其元素对象始终是指针复制。如果需要元素对象也是对象复制，就需要实现深拷贝。
     */
    
}
-(void)testArray3{
    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"first"],@"b",@"c",nil];
    NSArray *deepCopyArray=[[NSArray alloc] initWithArray: array copyItems: YES];
    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                  [NSKeyedArchiver archivedDataWithRootObject: array]];
    
    NSMutableString * str = array[0];
    [str appendString:@"def"];
    
    NSLog(@"arr = %@ \n arr2 = %@ \n arr3 = %@\n",array,deepCopyArray,trueDeepCopyArray);
    
    /*
     arr = (
     firstdef,
     b,
     c
     )
     arr2 = (
     first,
     b,
     c
     )
     arr3 = (
     first,
     b,
     c
     )
     这里可以看到 修改完以后 元素的数据并没有全部跟着改变，实现了元素深拷贝
     trueDeepCopyArray是完全意义上的深拷贝，而deepCopyArray则不是，对于deepCopyArray内的不可变元素其还是指针复制。或者我们自己实现深拷贝的方法。因为如果容器的某一元素是不可变的，那你复制完后该对象仍旧是不能改变的，因此只需要指针复制即可。除非你对容器内的元素重新赋值，否则指针复制即已足够
     */
}
@end
