//
//  ViewController.m
//  Lemonogin test
//
//  Created by Pedro Cardoso on 01/05/14.
//
//

#import "ViewController.h"
#import "Lemonogin.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

#ifdef DEBUG

    [[Lemonogin manager] setSourceURL:[NSURL URLWithString:@"http://localhost:8000/lemonogin.html"]];
    [[Lemonogin manager] triggerOnAnchor:self.loginButton
                                    view:self.view
                                callback:^(NSString *username, NSString *password, NSString *notes) {
                                    self.usernameField.text = username;
                                    self.passwordField.text = password;
                                }];
#endif

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
