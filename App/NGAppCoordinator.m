#import "NGAppCoordinator.h"

#import "NGServiceContainer.h"
#import "NGTheme.h"
#import "NGChatsViewController.h"
#import "NGChatPlaceholderViewController.h"
#import "NGChatViewController.h"
#import "NGDialog.h"
#import "NGSettingsViewController.h"

@interface NGAppCoordinator () <NGChatsViewControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NGServiceContainer *services;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *phoneChatsNavigationController;
@property (nonatomic, strong) UINavigationController *splitDetailNavigationController;

@end

@implementation NGAppCoordinator

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        _window = window;
        _services = [[NGServiceContainer alloc] init];
    }
    return self;
}

- (void)start {
    [NGTheme applyGlobalAppearance];

    self.window.backgroundColor = [NGTheme backgroundColor];
    self.window.tintColor = [NGTheme accentColor];

    NGChatsViewController *chatsViewController = [[NGChatsViewController alloc] initWithBackend:self.services.backend
                                                                                  avatarProvider:self.services.avatarProvider];
    chatsViewController.delegate = self;

    NGSettingsViewController *settingsViewController = [[NGSettingsViewController alloc] initWithServiceContainer:self.services];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:1];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.view.backgroundColor = [NGTheme backgroundColor];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:chatsViewController];
        UIViewController *placeholderViewController = [[NGChatPlaceholderViewController alloc] init];
        self.splitDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:placeholderViewController];

        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        splitViewController.viewControllers = @[masterNavigationController, self.splitDetailNavigationController];
        splitViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chats" image:nil tag:0];

        if ([splitViewController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
            splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        }

        self.tabBarController.viewControllers = @[splitViewController, settingsNavigationController];
    } else {
        self.phoneChatsNavigationController = [[UINavigationController alloc] initWithRootViewController:chatsViewController];
        self.phoneChatsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chats" image:nil tag:0];
        self.tabBarController.viewControllers = @[self.phoneChatsNavigationController, settingsNavigationController];
    }

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)chatsViewController:(NGChatsViewController *)controller didSelectDialog:(NGDialog *)dialog {
    NGChatViewController *chatViewController = [[NGChatViewController alloc] initWithDialog:dialog backend:self.services.backend];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.splitDetailNavigationController setViewControllers:@[chatViewController] animated:NO];
    } else {
        [self.phoneChatsNavigationController pushViewController:chatViewController animated:YES];
    }
}

@end
