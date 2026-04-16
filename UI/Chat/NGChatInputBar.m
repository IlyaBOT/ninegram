#import "NGChatInputBar.h"

#import "NGTheme.h"

@interface NGChatInputBar ()

@property (nonatomic, strong) UIView *topBorderView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation NGChatInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NGTheme surfaceColor];

        _topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _topBorderView.backgroundColor = [NGTheme separatorColor];
        [self addSubview:_topBorderView];

        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [NGTheme inputFieldBackgroundColor];
        _textField.textColor = [NGTheme primaryTextColor];
        _textField.font = [NGTheme inputFont];
        _textField.placeholder = @"Message";
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        _textField.layer.cornerRadius = 17.0;
        _textField.layer.masksToBounds = YES;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 34.0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:_textField];

        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [NGTheme dialogTitleFont];
        [_sendButton setTitleColor:[NGTheme accentColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat fieldHeight = 34.0;
    CGFloat buttonWidth = 54.0;

    self.topBorderView.frame = CGRectMake(0.0, 0.0, width, 1.0);
    self.sendButton.frame = CGRectMake(width - buttonWidth - 10.0, floor((height - 34.0) * 0.5), buttonWidth, 34.0);
    self.textField.frame = CGRectMake(10.0, floor((height - fieldHeight) * 0.5), width - buttonWidth - 30.0, fieldHeight);
}

- (void)sendButtonPressed {
    [self sendCurrentTextIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendCurrentTextIfNeeded];
    return NO;
}

- (void)sendCurrentTextIfNeeded {
    NSString *trimmedText = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmedText.length == 0) {
        return;
    }

    self.textField.text = @"";
    [self.delegate chatInputBar:self didSendText:trimmedText];
}

@end
