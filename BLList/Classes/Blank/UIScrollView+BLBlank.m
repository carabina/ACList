//
//  UIScrollView+BLBlank.m
//  BLList
//  https://github.com/ablettx/BLList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "UIScrollView+BLBlank.h"
#import <objc/runtime.h>
#import "BLBlank.h"

@interface UIView (BLConstraintBasedLayoutExtensions)
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;
@end

@interface BLBlankView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


static char const * const kBlankView = "kBlankView";

@interface UIScrollView ()<UIGestureRecognizerDelegate>
@property (nonatomic, readonly) BLBlankView *blankView;
@property (strong, nonatomic) BLBlank *model;
@end
@implementation UIScrollView (BLBlank)

#pragma mark - Getters (Public)

- (BOOL)isBlankVisible {
    UIView *view = objc_getAssociatedObject(self, kBlankView);
    return view ? !view.hidden : NO;
}

#pragma mark - Getters (Private)

- (BLBlankView *)blankView {
    BLBlankView *view = objc_getAssociatedObject(self, kBlankView);
    if (!view) {
        view = [BLBlankView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bl_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setBlankView:view];
    }
    return view;
}

- (BLBlank *)model {
    BLBlank *model = objc_getAssociatedObject(self, _cmd);
    if (!model) {
        model = [BLBlank new];
        [self setModel:model];
    }
    return model;
}

- (BOOL)bl_canDisplay {
    if (self.model && ([self isKindOfClass:[UITableView class]] || \
                       [self isKindOfClass:[UICollectionView class]] || \
                       [self isKindOfClass:[UIScrollView class]])) {
        return YES;
    }
    return NO;
}

- (NSInteger)bl_itemsCount
{
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return items;
}

#pragma mark - Setters (Public)

- (void)setBlankView:(BLBlankView *)blankView {
    objc_setAssociatedObject(self, kBlankView, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Setters (Private)

- (void)setModel:(BLBlank *)model {
    objc_setAssociatedObject(self, @selector(model), model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private

- (void)bl_didTapContentView:(id)sender {
    
}

- (void)bl_didTapDataButton:(id)sender {
    
}

#pragma mark - Public

- (void)setBlank:(BLBlank *)blank {
    self.model = blank;
}

- (void)reloadBlankData {
    [self bl_reloadBlankData];
}

#pragma mark - Reload APIs (Private)

- (void)bl_reloadBlankData {
    if (![self bl_canDisplay]) return;
    if ([self bl_itemsCount] == 0) {
        BLBlankView *view = self.blankView;
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || \
                 [self isKindOfClass:[UICollectionView class]]) && \
                self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }else {
                [self addSubview:view];
            }
        }
        
        view.verticalSpace = self.model.spaceHeight;
        view.imageView.image = [UIImage imageNamed:self.model.image];
        
        if (self.model.title) view.titleLabel.attributedText = self.model.title;
        if (self.model.desc) view.detailLabel.attributedText = self.model.desc;
        if (self.model.btnImage) {
            [view.button setImage:[UIImage imageNamed:self.model.image] forState:UIControlStateNormal];
        }else if (self.model.btnTitle) {
            [view.button setAttributedTitle:self.model.btnTitle forState:UIControlStateNormal];
            [view.button setBackgroundImage:[UIImage imageNamed:self.model.btnBackgroundImage] forState:UIControlStateNormal];
        }
        
        view.verticalOffset = self.model.verticalOffset;
        view.backgroundColor = self.model.backgroundColor;
        view.hidden = NO;
        view.clipsToBounds = YES;
        
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];
        }];
    }else if (self.isBlankVisible) {
        [self bl_invalidate];
    }
}

- (void)bl_invalidate {
    // Notifies that the empty dataset view will disappear
    
    if (self.blankView) {
        [self.blankView prepareForReuse];
        [self.blankView removeFromSuperview];
        
        [self setBlankView:nil];
    }
    
    self.scrollEnabled = YES;
    
    // Notifies that the empty dataset view did disappear
}

@end


@interface BLBlankView ()
@end
@implementation BLBlankView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self addSubview:self.contentView];
    return self;
}

- (void)didMoveToSuperview {
    self.frame = self.superview.bounds;
    void(^fadeInBlock)(void) = ^{self.contentView.alpha = 1.0;};
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }else {
        fadeInBlock();
    }
}

#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"empty set button";
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage {
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view {
    if (!view) return;
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}

#pragma mark - Action Methods

- (void)didTapButton:(id)sender {
    SEL selector = NSSelectorFromString(@"bl_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

- (void)prepareForReuse {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeAllConstraints];
}

#pragma mark - Auto-Layout Configuration

- (void)setupConstraints {
    // First, configure the content view constaints
    // The content view must alway be centered to its superview
    NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    // When a custom offset is available, we adjust the vertical constraints' constants
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    // If applicable, set the custom view's constraints
    if (_customView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }else {
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        
        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // Assign the image view's horizontal constraints
        if (_imageView.superview) {
            
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;
            
            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }
        
        // Assign the title label's horizontal constraints
        if ([self canShowTitle]) {
            
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // Assign the detail label's horizontal constraints
        if ([self canShowDetail]) {
            
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // Assign the button's horizontal constraints
        if ([self canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

@end

#pragma mark - UIView+BLConstraintBasedLayoutExtensions

@implementation UIView (BLConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}



@end
