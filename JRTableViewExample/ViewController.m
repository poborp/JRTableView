//
//  ViewController.m
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import "ViewController.h"
#import "JRTableView.h"

static NSString * kCellReuseIdentifierSection0 = @"CellReuseIdentifierSection0";
static NSString * kCellReuseIdentifierSection1 = @"CellReuseIdentifierSection1";
static NSString * kCellReuseIdentifierSection2 = @"CellReuseIdentifierSection2";
static NSString * kCellReuseIdentifierSection3 = @"CellReuseIdentifierSection3";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JRTableHeaderView *tableHeaderView;
@property (nonatomic, strong) JRTableFooterView *tableFooterView;

@property (nonatomic, strong) JRTableView *tableView;
@property (nonatomic, assign) NSInteger numCells;

@property (nonatomic, strong) UIStepper *numCellsStepper;

@property (nonatomic, strong) UISegmentedControl *headerSegmentedControl;
@property (nonatomic, strong) UIStepper *headerMinHeightStepper;
@property (nonatomic, strong) UIStepper *headerMaxHeightStepper;

@property (nonatomic, strong) UISegmentedControl *footerSegmentedControl;
@property (nonatomic, strong) UIStepper *footerHeightStepper;

@end

@implementation ViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _numCells = 6;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"TableView Example";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Values" style:UIBarButtonItemStylePlain target:self action:@selector(didPressValuesButton:)];
    
    _tableHeaderView = [JRTableHeaderView new];
    _tableHeaderView.backgroundColor = [UIColor darkGrayColor];
    
    _tableFooterView = [JRTableFooterView new];
    _tableFooterView.backgroundColor = [UIColor darkGrayColor];
    
    _tableView = [JRTableView new];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.stickyHeader = NO;
    _tableView.stickyFooter = NO;
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.tableHeaderViewMinHeight = 30;
    _tableView.tableHeaderViewMaxHeight = 120;
    _tableView.tableFooterView = _tableFooterView;
    _tableView.tableFooterViewMaxHeight = 30;
    _tableView.scrollBarColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.4 alpha:1.0];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifierSection0];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifierSection1];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifierSection2];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifierSection3];
    [self.view addSubview:_tableView];
    
    _numCellsStepper = [UIStepper new];
    _numCellsStepper.frame = CGRectMake(0, 0, 100, 40);
    _numCellsStepper.minimumValue = 0;
    _numCellsStepper.maximumValue = 100;
    _numCellsStepper.value = self.numCells;
    [_numCellsStepper addTarget:self action:@selector(didChangeCellsSteeper:) forControlEvents:UIControlEventValueChanged];
    
    _headerSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"None", @"Fill", @"Top", @"Bottom", @"Center"]];
    _headerSegmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 15*2, 26);
    _headerSegmentedControl.selectedSegmentIndex = self.tableView.tableHeaderView.contentMode+1;
    [_headerSegmentedControl addTarget:self action:@selector(didChangeHeaderSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    _headerMinHeightStepper = [UIStepper new];
    _headerMinHeightStepper.frame = CGRectMake(0, 0, 100, 40);
    _headerMinHeightStepper.minimumValue = 0;
    _headerMinHeightStepper.maximumValue = 300;
    _headerMinHeightStepper.value = self.tableView.tableHeaderViewMinHeight;
    _headerMinHeightStepper.stepValue = 10;
    [_headerMinHeightStepper addTarget:self action:@selector(didChangeHeaderMinHeightSteeper:) forControlEvents:UIControlEventValueChanged];
    
    _headerMaxHeightStepper = [UIStepper new];
    _headerMaxHeightStepper.frame = CGRectMake(0, 0, 100, 40);
    _headerMaxHeightStepper.minimumValue = 0;
    _headerMaxHeightStepper.maximumValue = 300;
    _headerMaxHeightStepper.value = self.tableView.tableHeaderViewMaxHeight;
    _headerMaxHeightStepper.stepValue = 10;
    [_headerMaxHeightStepper addTarget:self action:@selector(didChangeHeaderMaxHeightSteeper:) forControlEvents:UIControlEventValueChanged];
    
    _footerSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"None", @"Fill", @"Top", @"Bottom", @"Center"]];
    _footerSegmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 15*2, 26);
    _footerSegmentedControl.selectedSegmentIndex = self.tableView.tableFooterView.contentMode+1;
    [_footerSegmentedControl addTarget:self action:@selector(didChangeFooterSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    _footerHeightStepper = [UIStepper new];
    _footerHeightStepper.frame = CGRectMake(0, 0, 100, 40);
    _footerHeightStepper.minimumValue = 0;
    _footerHeightStepper.maximumValue = 300;
    _footerHeightStepper.value = self.tableView.tableFooterViewMaxHeight;
    _footerHeightStepper.stepValue = 10;
    [_footerHeightStepper addTarget:self action:@selector(didChangeFooterHeightSteeper:) forControlEvents:UIControlEventValueChanged];
    
    [self addCustomConstraints];
}

- (void)addCustomConstraints {
    
    NSDictionary *dictionaryView = NSDictionaryOfVariableBindings(_tableView);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:dictionaryView]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:dictionaryView]];
}

#pragma mark - Button Actions

- (void)didPressValuesButton:(UIBarButtonItem *)barButtonItem {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JRTableView" message:@"Select values" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Custom" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.headerSegmentedControl.selectedSegmentIndex = 4;
        [self didChangeHeaderSegmentedControl:self.headerSegmentedControl];
        self.headerMinHeightStepper.value = 80;
        [self didChangeHeaderMinHeightSteeper:self.headerMinHeightStepper];
        self.headerMaxHeightStepper.value = 180;
        [self didChangeHeaderMaxHeightSteeper:self.headerMaxHeightStepper];
        self.footerSegmentedControl.selectedSegmentIndex = 3;
        [self didChangeFooterSegmentedControl:self.footerSegmentedControl];
        self.footerHeightStepper.value = 20;
        [self didChangeFooterHeightSteeper:self.footerHeightStepper];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Native" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.headerSegmentedControl.selectedSegmentIndex = 3;
        [self didChangeHeaderSegmentedControl:self.headerSegmentedControl];
        self.headerMinHeightStepper.value = 0;
        [self didChangeHeaderMinHeightSteeper:self.headerMinHeightStepper];
        self.headerMaxHeightStepper.value = 150;
        [self didChangeHeaderMaxHeightSteeper:self.headerMaxHeightStepper];
        self.footerSegmentedControl.selectedSegmentIndex = 2;
        [self didChangeFooterSegmentedControl:self.footerSegmentedControl];
        self.footerHeightStepper.value = 30;
        [self didChangeFooterHeightSteeper:self.footerHeightStepper];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)didChangeCellsSteeper:(UIStepper *)stepper {
    
    self.numCells = stepper.value;
    [self.tableView reloadData];
}

- (void)didChangeHeaderMinHeightSteeper:(UIStepper *)stepper {
    
    self.tableView.tableHeaderViewMinHeight = stepper.value;
    [self.tableView reloadData];
}

- (void)didChangeHeaderMaxHeightSteeper:(UIStepper *)stepper {
    
    self.tableView.tableHeaderViewMaxHeight = stepper.value;
    [self.tableView reloadData];
}

- (void)didChangeFooterHeightSteeper:(UIStepper *)stepper {
    
    self.tableView.tableFooterViewMaxHeight = stepper.value;
    [self.tableView reloadData];
}

- (void)didChangeHeaderSegmentedControl:(UISegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex == 0) {
    
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    
    } else {
        
        if (!self.tableView.tableHeaderView) {
            self.tableView.tableHeaderView = self.tableHeaderView;
        }
        
        if (segmentedControl.selectedSegmentIndex == 1) {
            self.tableView.tableHeaderView.contentMode = JRTableHeaderViewContentModeFill;
        } else if (segmentedControl.selectedSegmentIndex == 2) {
            self.tableView.tableHeaderView.contentMode = JRTableHeaderViewContentModeTop;
        } else if (segmentedControl.selectedSegmentIndex == 3) {
            self.tableView.tableHeaderView.contentMode = JRTableHeaderViewContentModeBottom;
        } else if (segmentedControl.selectedSegmentIndex == 4) {
            self.tableView.tableHeaderView.contentMode = JRTableHeaderViewContentModeCenter;
        }
    }
}

- (void)didChangeFooterSegmentedControl:(UISegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        self.tableView.tableFooterView = nil;
        [self.tableView reloadData];
        
    } else {
        
        if (!self.tableView.tableFooterView) {
            self.tableView.tableFooterView = self.tableFooterView;
        }
        
        if (segmentedControl.selectedSegmentIndex == 1) {
            self.tableView.tableFooterView.contentMode = JRTableFooterViewContentModeFill;
        } else if (segmentedControl.selectedSegmentIndex == 2) {
            self.tableView.tableFooterView.contentMode = JRTableFooterViewContentModeTop;
        } else if (segmentedControl.selectedSegmentIndex == 3) {
            self.tableView.tableFooterView.contentMode = JRTableFooterViewContentModeBottom;
        } else if (segmentedControl.selectedSegmentIndex == 4) {
            self.tableView.tableFooterView.contentMode = JRTableFooterViewContentModeCenter;
        }
    }
}

#pragma mark - TableViewCell DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    } else {
        return self.numCells;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Config";
    } else if (section == 1) {
        return @"Header";
    } else if (section == 2) {
        return @"Footer";
    } else {
        return self.numCells > 0 ? @"Cells" : nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifierSection0 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Num cells: %li", self.numCells];
            cell.accessoryView = self.numCellsStepper;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Show Navigation Bar";
            cell.accessoryType = (self.navigationController.navigationBarHidden) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Show Tool Bar";
            cell.accessoryType = (self.navigationController.toolbarHidden) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifierSection1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryView = self.headerSegmentedControl;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"Min Height: %.0f", self.tableView.tableHeaderViewMinHeight];
            cell.accessoryView = self.headerMinHeightStepper;
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Max Height: %.0f", self.tableView.tableHeaderViewMaxHeight];
            cell.accessoryView = self.headerMaxHeightStepper;
        }
        return cell;
        
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifierSection2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryView = self.footerSegmentedControl;
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Height: %.0f", self.tableView.tableFooterViewMaxHeight];
            cell.accessoryView = self.footerHeightStepper;
        }
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifierSection3 forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%li", indexPath.row+1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - TableViewCell Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
            [self.tableView reloadData];
        } else if (indexPath.row == 2) {
            self.navigationController.toolbarHidden = !self.navigationController.toolbarHidden;
            [self.tableView reloadData];
        }
    }
}

@end
