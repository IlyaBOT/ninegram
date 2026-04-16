#import "NGAppDelegate.h"

#import "NGAppCoordinator.h"

@interface NGAppDelegate ()

@property (nonatomic, strong) NGAppCoordinator *appCoordinator;

@end

@implementation NGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.appCoordinator = [[NGAppCoordinator alloc] initWithWindow:self.window];
    [self.appCoordinator start];
    return YES;
}

@end
