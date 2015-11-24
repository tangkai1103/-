//
//  ViewController.m
//  CCalDemo
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 Mr Tang. All rights reserved.
//

#import "ViewController.h"
#import "WebService.h"
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickAction:(UIButton *)sender {
    WebService *webServiceVC = [WebService new];
    [webServiceVC query:self.textField.text];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
