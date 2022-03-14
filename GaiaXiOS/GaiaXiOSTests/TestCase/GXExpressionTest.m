//
//  GXExpressionTest.h
//  GaiaXiOS
//
//  Copyright (c) 2021, Alibaba Group Holding Limited.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <XCTest/XCTest.h>
#import <GaiaXiOS/GaiaXiOS.h>

@interface GXExpressionTest : XCTestCase

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation GXExpressionTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _dictionary = @{
        @"id":@"组件id",
        @"type":@"component",
        @"typeName":@"componentType",
        @"data":@{
            @"title":@"组件标题",
            @"sub-title":@"组件副标题"
        },
        @"nodes":@[
            @{
                @"id":@"坑位id",
                @"type":@"item",
                @"typeName":@"itemType",
                @"data":@{
                    @"title":@"坑位标题",
                    @"desc":@"坑位描述",
                    @"img":@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F07%2F20190107133703_aQuB4.thumb.400_0.jpeg",
                    @"mark":@{
                        @"data":@{
                            @"color":@"标签颜色",
                            @"text":@"标签内容"
                        },
                        @"type":@"normal"
                    },
                    @"favor":@{
                        @"id":@"坑位id",
                        @"type":@"SHOW",
                        @"isFavor":@true
                    },
                    @"action":@{
                        @"type":@"jump-to-url",
                        @"url":@"www.youku.com"
                    }
                    
                }
            }
        ]
        
    };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// test value expression
- (void)testValueExp{
    
    NSString *exp0 = @"常量内容";
    GXExpression *expression0 = [GXExpression expressionWithString:exp0];
    XCTAssertTrue([[expression0 valueWithObject:self.dictionary] isEqualToString:@"常量内容"]);
    
    NSString *exp1 = @"${data.title}";
    GXExpression *expression1 = [GXExpression expressionWithString:exp1];
    XCTAssertTrue([[expression1 valueWithObject:self.dictionary] isEqualToString:@"组件标题"]);

    NSString *exp2 = @"${nodes[0].data.title}";
    GXExpression *expression2 = [GXExpression expressionWithString:exp2];
    XCTAssertTrue([[expression2 valueWithObject:self.dictionary] isEqualToString:@"坑位标题"]);

    NSString *exp3 = @"${nodes[0].data.mark.data.text}";
    GXExpression *expression3 = [GXExpression expressionWithString:exp3];
    XCTAssertTrue([[expression3 valueWithObject:self.dictionary] isEqualToString:@"标签内容"]);
    
}

// test condition expression
- (void)testConditionExp{
    
    NSString *exp0 = @"@{${nodes[0].data.favor.isFavor} ? '关注' : '未关注'}";
    GXExpression *expression0 = [GXExpression expressionWithString:exp0];
    XCTAssertTrue([[expression0 valueWithObject:self.dictionary] isEqualToString:@"关注"]);
    
    NSString *exp1 = @"@{${nodes[0].data.title} ?: '默认标题'}";
    GXExpression *expression1 = [GXExpression expressionWithString:exp1];
    XCTAssertTrue([[expression1 valueWithObject:self.dictionary] isEqualToString:@"坑位标题"]);
    
}

// test eval expression
- (void)testEvalExp{
    NSString *exp0 = @"@{eval(${data.}) ? '关注' : '未关注'}";
    GXExpression *expression0 = [GXExpression expressionWithString:exp0];
    XCTAssertTrue([[expression0 valueWithObject:self.dictionary] isEqualToString:@"关注"]);
    
    NSString *exp1 = @"@{${nodes[0].data.title} ?: '默认标题'}";
    GXExpression *expression1 = [GXExpression expressionWithString:exp1];
    XCTAssertTrue([[expression1 valueWithObject:self.dictionary] isEqualToString:@"坑位标题"]);
}

// test size expression
- (void)testSizeExp{
    NSString *exp0 = @"@{eval(size($(data)) == 2) ? true : false}";
    GXExpression *expression0 = [GXExpression expressionWithString:exp0];
    XCTAssertTrue([expression0 valueWithObject:self.dictionary]);
    
    NSString *exp1 = @"@{eval(size($(nodes)) == 1) ? true : false}";
    GXExpression *expression1 = [GXExpression expressionWithString:exp1];
    XCTAssertTrue([expression1 valueWithObject:self.dictionary]);
}

// test plus expression
- (void)testPlusExp{
    
    NSString *exp0 = @"${data.title} + 123";
    GXExpression *expression0 = [GXExpression expressionWithString:exp0];
    XCTAssertTrue([[expression0 valueWithObject:self.dictionary] isEqualToString:@"组件标题123"]);

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
