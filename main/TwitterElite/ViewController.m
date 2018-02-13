//
//  ViewController.m
//  TwitterElite
//
//  Created by oneSecure on 16/02/2017.
//  Copyright © 2017 oneSecure. All rights reserved.
//

#import "ViewController.h"
#import "constants.h"
#import "FHSTwitterEngine.h"

@interface ViewController () <FHSTwitterEngineAccessTokenDelegate>
@end

@implementation ViewController {
    __weak FHSTwitterEngine *_twitterEngine;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];

    _twitterEngine = [FHSTwitterEngine sharedEngine];

    [_twitterEngine permanentlySetConsumerKey:consumerKey andSecret:consumerSecret];
    [_twitterEngine setDelegate:self];
    [_twitterEngine loadAccessToken];

    self.title = [_twitterEngine authenticatedUsername];

    UIBarButtonItem *logInOut = nil;
    if (_twitterEngine.isAuthorized) {
        logInOut = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    } else {
        logInOut = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginOAuth)];
    }

    self.navigationItem.rightBarButtonItem = logInOut;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loginOAuth {
    UIViewController *loginController = [_twitterEngine loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        //[_theTableView reloadData];
        self.navigationController.viewControllers = @[[[ViewController alloc] init]];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void) logout {
    [_twitterEngine clearAccessToken];
    self.navigationController.viewControllers = @[[[ViewController alloc] init]];
}

#pragma mark - FHSTwitterEngineAccessTokenDelegate
- (NSString *) loadAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedAccessHTTPBody"];
}

- (void) storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (void) twitterEngineControllerDidCancel {
}

@end
