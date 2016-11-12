//
//  TopMenuViewController.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/10.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "TopMenuViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"
#import "MenuItems.h"

@interface TopMenuViewController () <UICollectionViewDelegateFlowLayout>
@property NSArray* menuItems;
@end

@implementation TopMenuViewController

static NSString * const reuseIdentifier = @"Cell";
static CGFloat const frameMargin = 10.0;
static NSInteger const frameImageHorizontalCount = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuItems = [MenuItems allMenu];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //    [self.collectionView registerClass:[MenuCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuItems.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.item;
    [self initAppearanceOfCell:cell];
    
    MenuItem* menu = [self.menuItems objectAtIndex:indexPath.item];
    cell.title.text = menu.title;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Highlight");
    [self highlightToCell:[collectionView cellForItemAtIndexPath:indexPath]];
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did Unhighlight");
    [self unhighlightToCell:[collectionView cellForItemAtIndexPath:indexPath]];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did select");
    MenuItem* menu = [self.menuItems objectAtIndex:indexPath.item];
    UIViewController* vc = menu.viewControllerFactory();
    [self presentViewController:vc animated:YES completion:nil];
}

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

# pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat shortEdge = MIN(size.height, size.width) - frameMargin;
    CGFloat cellSize = shortEdge/frameImageHorizontalCount - frameMargin;
    return CGSizeMake(cellSize, cellSize);
}

# pragma mark - private messages

- (void)initAppearanceOfCell:(UICollectionViewCell*)cell{
    cell.contentView.layer.cornerRadius = 2.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                       cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    [self unhighlightToCell:cell];
}

- (void)unhighlightToCell:(UICollectionViewCell*)cell{
    cell.layer.shadowOffset = CGSizeMake(0, 3.0f);
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)highlightToCell:(UICollectionViewCell*)cell{
    cell.layer.shadowOffset = CGSizeMake(0, 0.1f);
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}


@end
