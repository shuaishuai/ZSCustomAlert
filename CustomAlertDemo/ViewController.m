//
//  ViewController.m
//  CustomAlertDemo
//
//  Created by Allen on 2016/11/23.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ViewController.h"
#import "ZSCustomAlert.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)alertButtonClick:(id)sender {
    [ZSShareCustomAlert showWithHeader:@"提示" message:@"测试" showController:self withHandler:^(NSInteger selectedIndex, NSString *title) {
        NSLog(@"index = %ld   title = %@",selectedIndex,title);
    } andTitles:@"title0",@"title1",@"title2", nil];
}

- (IBAction)actionSheetClick:(id)sender {
    ZSCustomAlert *myAlet = ZSShareCustomAlert;
    myAlet.alertStyle = UIAlertControllerStyleActionSheet;
    [myAlet showWithHeader:@"提示" message:@"测试" showController:self withHandler:^(NSInteger selectedIndex, NSString *title) {
        NSLog(@"index = %ld   title = %@",selectedIndex,title);
    } andTitles:@"title0",@"title1",@"title2", nil];
}

@end
