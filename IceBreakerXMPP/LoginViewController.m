//
//  LoginViewController.m
//  
//
//  Created by Shruthi Sridhar on 21/04/16.
//
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)viewDidAppear:(BOOL)animated
{
    UIView *backgroundImage = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIGraphicsBeginImageContext(backgroundImage.frame.size);
    [[UIImage imageNamed:@"image2.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    backgroundImage.backgroundColor = [UIColor colorWithPatternImage:image];
    backgroundImage.alpha = 0.075f;
    backgroundImage.userInteractionEnabled = NO;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate] ;
    delegate.loginView = self;
    [self.view addSubview:backgroundImage];
    //If the user had already logged in, log in automatically
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]&&[[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]) {
        self.loginButton.hidden = YES;
        self.enteredUsername.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        self.enteredPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
    }
    else
    {
        self.activityIndicator.hidden = YES;
        self.loginButton.hidden = NO;
    }
    
}
//Action when login is tapped
- (IBAction) login {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.enteredUsername.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.enteredPassword.text forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([self.enteredPassword.text isEqualToString:@""]||[self.enteredUsername.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete login details!"
                                                            message:[NSString stringWithFormat:@"Please enter values for both fields!"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        self.loginButton.hidden = YES;
        self.activityIndicator.hidden = NO;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate] ;
        [delegate connect];
        delegate.loginView = self;
    }
}

//Once the user credentials are authenticated, transition to the next view
-(void)authenticated
{
    self.activityLabel.text = @"";
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self performSegueWithIdentifier:@"Login" sender:self];
}
@end
