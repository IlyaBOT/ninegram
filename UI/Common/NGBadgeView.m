#import "NGBadgeView.h"

#import "NGTheme.h"

@interface NGBadgeView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation NGBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NGTheme unreadBadgeColor];
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [NGTheme badgeFont];
        [self addSubview:_textLabel];

        self.hidden = YES;
    }
    return self;
}

- (void)setCount:(NSUInteger)count {
    _count = count;
    self.hidden = count == 0;
    self.textLabel.text = count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)count] : nil;
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.count == 0) {
        return CGSizeZero;
    }

    CGSize textSize = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName: self.textLabel.font}];
    return CGSizeMake(MAX(20.0, ceil(textSize.width) + 12.0), 20.0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = floor(CGRectGetHeight(self.bounds) * 0.5);
    self.textLabel.frame = self.bounds;
}

@end
