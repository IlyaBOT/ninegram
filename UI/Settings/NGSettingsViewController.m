#import "NGSettingsViewController.h"

#import "NGServiceContainer.h"
#import "NGTheme.h"

@interface NGSettingsViewController ()

@property (nonatomic, strong) NGServiceContainer *serviceContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *sections;

@end

@implementation NGSettingsViewController

- (instancetype)initWithServiceContainer:(NGServiceContainer *)serviceContainer {
    self = [super init];
    if (self) {
        _serviceContainer = serviceContainer;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = @"Settings";
        _sections = [self buildSections];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [NGTheme backgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [NGTheme backgroundColor];
    self.tableView.separatorColor = [NGTheme separatorColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSArray *)buildSections {
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *version = bundleVersion != nil ? [bundleVersion copy] : @"0.1.0";

    return @[
        @{
            @"title": @"Account",
            @"rows": @[
                @{@"title": @"Session", @"value": @"Mock account"},
                @{@"title": @"Phone", @"value": @"+000 000 0000"}
            ]
        },
        @{
            @"title": @"Appearance",
            @"rows": @[
                @{@"title": @"Theme", @"value": @"Classic Light"},
                @{@"title": @"Density", @"value": @"Compact"}
            ]
        },
        @{
            @"title": @"Cache",
            @"rows": @[
                @{@"title": @"Avatar Cache", @"value": @"Memory only"},
                @{@"title": @"Clear Avatar Cache", @"value": @"", @"action": @"clear-cache"}
            ]
        },
        @{
            @"title": @"About",
            @"rows": @[
                @{@"title": @"Version", @"value": version},
                @{@"title": @"Backend", @"value": @"MockBackend"}
            ]
        }
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section][@"rows"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"NGSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSDictionary *row = self.sections[indexPath.section][@"rows"][indexPath.row];
    cell.textLabel.text = row[@"title"];
    cell.textLabel.font = [NGTheme settingsTitleFont];
    cell.textLabel.textColor = [NGTheme primaryTextColor];
    cell.detailTextLabel.text = row[@"value"];
    cell.detailTextLabel.textColor = [NGTheme secondaryTextColor];
    cell.selectionStyle = row[@"action"] != nil ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;

    if ([row[@"action"] isEqualToString:@"clear-cache"]) {
        cell.textLabel.textColor = [NGTheme accentColor];
        cell.detailTextLabel.text = nil;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *row = self.sections[indexPath.section][@"rows"][indexPath.row];
    if (![row[@"action"] isEqualToString:@"clear-cache"]) {
        return;
    }

    [self.serviceContainer clearTransientCaches];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cache Cleared"
                                                                             message:@"Avatar images were removed from memory."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
