#import "NGChatPlaceholderViewController.h"

#import "NGTheme.h"

@interface NGChatPlaceholderViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation NGChatPlaceholderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = @"Chats";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [NGTheme backgroundColor];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"Select a chat";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [NGTheme primaryTextColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
    [self.view addSubview:self.titleLabel];

    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.subtitleLabel.text = @"Ninegram keeps the first release simple and fast.";
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.textColor = [NGTheme secondaryTextColor];
    self.subtitleLabel.font = [NGTheme dialogPreviewFont];
    [self.view addSubview:self.subtitleLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect bounds = self.view.bounds;
    CGFloat width = MIN(CGRectGetWidth(bounds) - 48.0, 320.0);
    CGFloat originX = floor((CGRectGetWidth(bounds) - width) * 0.5);
    CGFloat centerY = floor(CGRectGetHeight(bounds) * 0.42);

    self.titleLabel.frame = CGRectMake(originX, centerY - 26.0, width, 28.0);
    self.subtitleLabel.frame = CGRectMake(originX, CGRectGetMaxY(self.titleLabel.frame) + 10.0, width, 20.0);
}

@end
