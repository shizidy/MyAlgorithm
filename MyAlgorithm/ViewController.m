//
//  ViewController.m
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *array = @[@1, @2, @3];
//    NSLog(@"%@", array[4]);
//    NSMutableArray *marray = [@[@"1", @"2", @"4", @"5", @"6", @"7", @"8", @"9", @"3"] mutableCopy];
//    [self getMaxArrayWithoriginArray:array];
//    [self quicksortArrayWithoriginArray:marray leftIndex:0 rightIndex:marray.count-1];
//    NSLog(@"%@", marray);
//    [self reverseString:@"12345"];
//    [self removeDuplicateCharacters];
//    [self gcdDemo1];
//    [self semaphore];
//    [self searchTwoNumsForTarget];
//    [self romanToInt];
//    [self reverseInt];
    [self isValid];
// Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // signal崩溃测试用例
//    void *signal = malloc(1024);
//    free(signal);
//    free(signal);
    
    // exception崩溃测试用例
//    NSArray *array = @[@1, @2, @3];
//    NSLog(@"%@", array[4]);
    
}

#pragma mark - 找到数组中和最大的连续子数组
-(NSArray *)getMaxArrayWithoriginArray:(NSArray *)array {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
    int sum = 0;
    int maxsum = 0;
    int start = 0;
    int end = 0;
    for (int i = 0; i < marray.count; i++) {
        sum += [marray[i] intValue];
        if (sum < 0) {
            sum = 0;
            start = i;
        }
        if (sum > maxsum) {
            maxsum = sum;
            end = i;
        }
    }
    NSLog(@"%d", maxsum);
    if (end + 1 < array.count) {//先删除后面的数组
        [marray removeObjectsInRange:NSMakeRange(end + 1, array.count - end - 1)];
    }
    [marray removeObjectsInRange:NSMakeRange(0, start + 1)];
    
//    NSLog(@"%@", marray);
    return marray;
}

#pragma mark - 冒泡排序法
-(void)maopaoSortArray {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:@[@1, @2, @8, @4, @10, @23, @0]];
    for (int i = 0; i < marray.count - 1; i++) {
        for (int j = 0; j < marray.count - 1 - i; j++) {
            if (marray[j] < marray[j + 1]) {
                [marray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    NSLog(@"%@", marray);
    
}

#pragma mark - 选择排序
-(void)xuanzeSortArray {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:@[@1, @2, @8, @4, @10, @23, @0]];
    for (int i = 0; i < marray.count - 1; i++) {
        for (int j = i + 1; j < marray.count; j++) {
            if (marray[i] < marray[j]) {
                [marray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"%@", marray);
}

#pragma mark - 快速排序法
-(void)quicksortArrayWithoriginArray:(NSMutableArray *)marray leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) {
        return;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    NSInteger key = [marray[i] integerValue];

    while (i < j) {
        while (i < j && [marray[j] integerValue] >= key) {//从右边找到比key小的
            j--;
        }
        marray[i] = marray[j];

        while (i < j && [marray[i] integerValue] <= key) {//从左边找到比key大的
            i++;
        }
        marray[j] = marray[i];
    }
    marray[i] = [NSString stringWithFormat:@"%ld", key];//把基准数放在正确的位置
    //递归
    [self quicksortArrayWithoriginArray:marray leftIndex:leftIndex rightIndex:i - 1];//排序基准数左边的
    [self quicksortArrayWithoriginArray:marray leftIndex:i + 1 rightIndex:rightIndex];//排序基准数右边的
}

#pragma mark - 二分查找（前提数组是有序的）
- (void)binarySearchWithArray:(NSArray *)array key:(NSInteger)key {
    array = @[@1, @2, @3, @4, @5, @6];
    //查找@4的下标index
    NSInteger lo = 0;
    NSInteger hi = array.count - 1;
    NSInteger index = 0;
    while (lo <= hi) {
        NSInteger mid = lo + (hi - lo) / 2;
        NSNumber *number = array[mid];
        if (key < [number integerValue]) {
            hi = mid - 1;
        } else if (key > [number integerValue]) {
            lo = mid + 1;
        } else {
            index = mid;
        }
    }
}

#pragma mark - 二分查找-迭代法（前提数组是有序的）
- (void)rank:(NSArray *)array key:(NSInteger)key {
    [self binarySearchWithArray:array key:key leftIndex:0 rightIndex:array.count - 1];
}
- (NSInteger)binarySearchWithArray:(NSArray *)array key:(NSInteger)key leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    if (leftIndex > rightIndex) {
        return -1;
    }
    NSInteger mid = leftIndex + (rightIndex - leftIndex) / 2;
    NSNumber *number = array[mid];
    if (key < [number integerValue]) {
        return [self  binarySearchWithArray:array key:key leftIndex:leftIndex rightIndex:mid - 1];
    } else if (key > [number integerValue]) {
        return [self binarySearchWithArray:array key:key leftIndex:mid + 1 rightIndex:rightIndex];
    } else {
        return 0;
    }
}

#pragma mark - 给定一个数组，把奇数排在一起，偶数排在一起，相对前后顺序不变
- (void)resortArray {
    //思路，相当于排序（升序的话），如果想奇数在前，就当做奇数小往前排，偶数大往后排
    NSMutableArray *marray = [NSMutableArray arrayWithObjects:@18, @2, @9, @12, @11, @23, @14, @24, nil];
    //利用冒泡原则来排
    //把奇数排在前
    for (int i = 0; i < marray.count - 1; i++) {
        for (int j = 0; j < marray.count - 1 - i; j++) {
            NSInteger num1 = [marray[j] integerValue];
            NSInteger num2 = [marray[j + 1] integerValue];
            if (num2 % 2 != 0 && num1 % 2 == 0) {
                [marray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    NSLog(@"%@", marray);
    //把偶数排在前
    for (int i = 0; i < marray.count - 1; i++) {
        for (int j = 0; j < marray.count - 1 - i; j++) {
            NSInteger num1 = [marray[j] integerValue];
            NSInteger num2 = [marray[j + 1] integerValue];
            if (num2 % 2 == 0 && num1 % 2 != 0) {
                [marray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    NSLog(@"%@", marray);
}

#pragma mark - 去重
-(void)quchongMethod {//去除字符串不相邻的重复字符
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:@"aaadfghaeectem"];
    for (int i = 0; i < str1.length - 1; i++) {
        for (int j = i + 1; j < str1.length; j++) {
            // 由于字符的特殊性  无法使用 字符串 isEqualToString 进行比较 只能转化为ASCII 值进行比较  所以 需要加 unsigined 修饰
            unsigned char a = [str1 characterAtIndex:i];
            unsigned char b = [str1 characterAtIndex:j];
            if (a == b) {
                if (j - i > 1) {
                    // NSRange:  截取字符串   {j, 1} j: 第一个字符开始  1: 截取几个字符
                    [str1 deleteCharactersInRange:NSMakeRange(j, 1)];
                    j = i--;
                }
            }
        }
    }
    NSLog(@"------ %@-------", str1);
}

#pragma mark - 字符串反转
- (void)reverseString:(NSString *)string {
    NSMutableString *mStr = [NSMutableString stringWithCapacity:string.length];
    for (NSInteger i = string.length - 1; i >= 0; i--) {
        [mStr appendString:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    NSLog(@"%@", mStr);
}

#pragma mark - 字符串去重
- (void)removeDuplicateCharacters {
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"aaadfghaeectem"];
    for (NSInteger i = 0; i < mStr.length - 2; i++) {
        @autoreleasepool {
            NSString *str_i = [mStr substringWithRange:NSMakeRange(i, 1)];
            for (NSInteger j = i + 1; j < mStr.length - 1; j++) {
                @autoreleasepool {
                    NSString *str_j = [mStr substringWithRange:NSMakeRange(j, 1)];
                    if ([str_i isEqualToString:str_j]) {
                        [mStr deleteCharactersInRange:NSMakeRange(j, 1)];
                        j--;
                    }
                }
            }
        }
    }
    NSLog(@"%@", mStr);
}

#pragma mark - 两数之和（给定一个无重复元素的数字数组和一个target，找出和等于target的两元素）
- (void)searchTwoNumsForTarget {
    NSInteger target = 10;
    NSArray *array = @[@1, @4, @9, @10, @5, @7, @20];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:array.count];
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)i];
        NSNumber *number = array[i];
        NSInteger minus = target - number.integerValue;
        if (minus < 0) {
            continue;
        }
        if ([dict.allKeys containsObject:[NSString stringWithFormat:@"%ld", (long)minus]]) {
            NSLog(@"%@ + %@ = %@，下标是%@和%ld", [NSString stringWithFormat:@"%ld", (long)minus], number, [NSString stringWithFormat:@"%ld", (long)target], dict[[NSString stringWithFormat:@"%ld", (long)minus]], (long)i);
        } else {
            [dict setValue:key forKey:[NSString stringWithFormat:@"%@", number]];
        }
    }
}

#pragma mark - 罗马数字转整数
- (void)romanToInt {
    // 列出所有罗马符号代表的数字
    /*
     I = 1
     V = 5
     X = 10
     L = 50
     C = 100
     D = 500
     M = 1000
     IV = 4
     IX = 9
     XL = 40
     XC = 90
     CD = 400
     CM = 900
     MCMXCIV = 1994
     */
    NSDictionary *dict = @{
        @"I":@"1",
        @"V":@"5",
        @"X":@"10",
        @"L":@"50",
        @"C":@"100",
        @"D":@"500",
        @"M":@"1000",
        @"IV":@"4",
        @"IX":@"9",
        @"XL":@"40",
        @"XC":@"90",
        @"CD":@"400",
        @"CM":@"900",
    };
    NSString *roman = @"MMCMI";
    NSInteger sum = 0;
    for (NSInteger i = 0; i < roman.length; i++) {
        @autoreleasepool {
            NSInteger len = i == roman.length - 1 ? 1 : 2;  // 当i == roman.length时，令len = 1，因为len = 2 string1 = [roman substringWithRange:NSMakeRange(i, len)]越界
            NSString *string1 = [roman substringWithRange:NSMakeRange(i, len)];
            NSString *string2 = [roman substringWithRange:NSMakeRange(i, 1)];
//            NSLog(@"%@ %@", string1, string2);
            NSString *value = @"";
            if ([dict.allKeys containsObject:string1]) {
                value = dict[string1];
                NSLog(@"string1==%@", string1);
                i += 1;  // 重定义下一轮遍历起点
            } else {
                value = dict[string2];
                NSLog(@"string2==%@", string2);
            }
            sum += [value integerValue];
        }
    }
    NSLog(@"MCMXCIV = %ld", (long)sum);
}

#pragma mark - 整数反转，不借助数组等，考虑整数溢出
- (void)reverseInt {
    int num = 12345;
    int re = 0;
    int result = 0;
    while (num > 0) {
        re = num % 10;
        num = (int)(num / 10);
        if (result > (int)(INT_MAX / 10)) {
            return;
        }
        if (result == (int)(INT_MAX / 10) && re > 7) {
            return;
        }
        if (result < (int)(INT_MIN / 10)) {
            return;
        }
        if (result == (int)(INT_MIN / 10) && re < -7) {
            return;
        }
        result = result * 10 + re;
        NSLog(@"%d", re);
    }
    NSLog(@"%d", result);
}

#pragma mark - 有效的括号(检查符号是否成对出现)
- (void)isValid {
    // 思路
    NSString *string = @"{[[]{}]}<()()>";
    NSDictionary *dict = @{
        @"{":@"}",
        @"[":@"]",
        @"(":@")",
        @"<":@">",
    };
    int count = 0;
    for (int i = 0; i < string.length; i++) {
        @autoreleasepool {
            NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
            if ([dict.allKeys containsObject:subStr]) {
                count++;
            }
            if ([dict.allValues containsObject:subStr]) {
                count--;
            }
        }
    }
    if (count == 0) {
        NSLog(@"有效的");
    } else {
        NSLog(@"无效的");
    }
}


- (void)gcdDemo1 {
    // 1. 队列
    dispatch_queue_t queue = dispatch_queue_create("com.itheima.queue", DISPATCH_QUEUE_SERIAL);
    // 2. 执行任务
    for (int i = 0; i < 10; ++i) {
        NSLog(@"--- %d", i);
        
        dispatch_async(queue, ^{
            NSLog(@"%@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"come here");
}

-(void)semaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    for (int i=0; i<5; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"%@==%d", [NSThread currentThread], i);
            dispatch_semaphore_signal(semaphore);
        });
        NSLog(@"%d", i);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}


@end
