//
//  LoginViewController.h
//  
//
//  Created by Shruthi Sridhar on 21/04/16.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextField *enteredUsername;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,retain) IBOutlet UITextField *enteredPassword;

- (IBAction) login;
-(void)authenticated;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)connected;
@end
