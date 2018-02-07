//
//  ViewController.m
//  Pigeons
//
//  Created by Girijah Nagarajah on 2/7/18.
//  Copyright © 2018 Core Sparker. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () 
@property (weak, nonatomic) IBOutlet UIButton *call;
@property (weak, nonatomic) IBOutlet UIButton *notifyBTN;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextBox;
@property (weak, nonatomic) IBOutlet UITextField *SMSTextBox;
@property (weak, nonatomic) IBOutlet UITextField *reminderTitleTextBox;
@property (weak, nonatomic) IBOutlet UITextView *reminderMessageTextBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.notifyBTN addTarget:self action:@selector(generateLocalNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}


- (void)generateLocalNotification:(id)sender {
    
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    localNotification.title = [NSString localizedUserNotificationStringForKey:_reminderTitleTextBox.text arguments:nil];
    localNotification.body = [NSString localizedUserNotificationStringForKey:_reminderMessageTextBox.text arguments:nil];
    localNotification.sound = [UNNotificationSound defaultSound];
    localNotification.launchImageName = @"launch-pic";
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_reminderTitleTextBox.text content:localNotification trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Notification created");
    }];
}

- (void)takeActionWithLocalNotification:(UNNotification *)localNotification {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localNotification.request.content.title message:localNotification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
    }];
    [alertController addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{
        }];
    });
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification alert" message:@"This app just sent you a notification, do you want to see it?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"IGNORE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ignore");
    }];
    UIAlertAction *see = [UIAlertAction actionWithTitle:@"SEE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takeActionWithLocalNotification:notification];
    }];
    
    [alertController addAction:ignore];
    [alertController addAction:see];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [self takeActionWithLocalNotification:response.notification];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)SMS:(id)sender {
    NSString *preCode = @"sms:";
    NSString *smsFormat = [preCode stringByAppendingString:_SMSTextBox.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:smsFormat] options:nil completionHandler:nil];
}


- (IBAction)call:(id)sender {
    NSString *preCode = @"tel:";
    NSString *phoneCallFormat = [preCode stringByAppendingString:_phoneNumberTextBox.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallFormat] options:nil completionHandler:nil];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}



@end
