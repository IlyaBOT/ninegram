#import "NGMessage.h"

@implementation NGMessage

- (instancetype)initWithIdentifier:(NSString *)identifier
                  dialogIdentifier:(NSString *)dialogIdentifier
                              text:(NSString *)text
                              date:(NSDate *)date
                          outgoing:(BOOL)outgoing {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _dialogIdentifier = [dialogIdentifier copy];
        _text = [text copy];
        _date = date;
        _outgoing = outgoing;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
