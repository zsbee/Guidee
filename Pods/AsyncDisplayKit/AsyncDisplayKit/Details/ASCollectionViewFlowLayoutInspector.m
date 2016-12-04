//
//  ASCollectionViewFlowLayoutInspector.m
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "ASCollectionViewFlowLayoutInspector.h"
#import "ASCollectionView.h"
#import "ASAssert.h"
#import "ASEqualityHelpers.h"
#import "ASCollectionView+Undeprecated.h"

#define kDefaultItemSize CGSizeMake(50, 50)

#pragma mark - ASCollectionViewFlowLayoutInspector

@interface ASCollectionViewFlowLayoutInspector ()
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;
@end
 
@implementation ASCollectionViewFlowLayoutInspector {
  struct {
    unsigned int implementsReferenceSizeForHeader:1;
    unsigned int implementsReferenceSizeForFooter:1;
    unsigned int implementsConstrainedSizeForNodeAtIndexPathDeprecated:1;
    unsigned int implementsConstrainedSizeForItemAtIndexPath:1;
  } _delegateFlags;
  
  struct {
    unsigned int implementsNumberOfSectionsInCollectionView:1;
  } _dataSourceFlags;
}

#pragma mark Lifecycle

- (instancetype)initWithCollectionView:(ASCollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout;
{
  NSParameterAssert(collectionView);
  NSParameterAssert(flowLayout);
  
  self = [super init];
  if (self != nil) {
    [self didChangeCollectionViewDataSource:collectionView.asyncDataSource];
    [self didChangeCollectionViewDelegate:collectionView.asyncDelegate];
    _layout = flowLayout;
  }
  return self;
}

#pragma mark ASCollectionViewLayoutInspecting

- (void)didChangeCollectionViewDelegate:(id<ASCollectionDelegate>)delegate;
{
  if (delegate == nil) {
    memset(&_delegateFlags, 0, sizeof(_delegateFlags));
  } else {
    _delegateFlags.implementsReferenceSizeForHeader = [delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)];
    _delegateFlags.implementsReferenceSizeForFooter = [delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)];
    _delegateFlags.implementsConstrainedSizeForNodeAtIndexPathDeprecated = [delegate respondsToSelector:@selector(collectionView:constrainedSizeForNodeAtIndexPath:)];
    _delegateFlags.implementsConstrainedSizeForItemAtIndexPath = [delegate respondsToSelector:@selector(collectionNode:constrainedSizeForItemAtIndexPath:)];
  }
}

- (void)didChangeCollectionViewDataSource:(id<ASCollectionDataSource>)dataSource
{
  if (dataSource == nil) {
    memset(&_dataSourceFlags, 0, sizeof(_dataSourceFlags));
  } else {
    _dataSourceFlags.implementsNumberOfSectionsInCollectionView = [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)];
  }
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
  if (_delegateFlags.implementsConstrainedSizeForItemAtIndexPath) {
    return [collectionView.asyncDelegate collectionNode:collectionView.collectionNode constrainedSizeForItemAtIndexPath:indexPath];
  } else if (_delegateFlags.implementsConstrainedSizeForNodeAtIndexPathDeprecated) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [collectionView.asyncDelegate collectionView:collectionView constrainedSizeForNodeAtIndexPath:indexPath];
#pragma clang diagnostic pop
  } else {
    // With 2.0 `collectionView:constrainedSizeForNodeAtIndexPath:` was moved to the delegate. Assert if not implemented on the delegate but on the data source
    ASDisplayNodeAssert([collectionView.asyncDataSource respondsToSelector:@selector(collectionView:constrainedSizeForNodeAtIndexPath:)] == NO, @"collectionView:constrainedSizeForNodeAtIndexPath: was moved from the ASCollectionDataSource to the ASCollectionDelegate.");
  }
  
  CGSize itemSize = _layout.itemSize;
  if (CGSizeEqualToSize(itemSize, kDefaultItemSize) == NO) {
    return ASSizeRangeMake(itemSize, itemSize);
  }
  
  return NodeConstrainedSizeForScrollDirection(collectionView);
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  CGSize constrainedSize;
  CGSize supplementarySize = [self sizeForSupplementaryViewOfKind:kind inSection:indexPath.section collectionView:collectionView];
  if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
    constrainedSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), supplementarySize.height);
  } else {
    constrainedSize = CGSizeMake(supplementarySize.width, CGRectGetHeight(collectionView.bounds));
  }
  return ASSizeRangeMake(CGSizeZero, constrainedSize);
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section
{
  return [self layoutHasSupplementaryViewOfKind:kind inSection:section collectionView:collectionView] ? 1 : 0;
}

- (ASScrollDirection)scrollableDirections
{
  return (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? ASScrollDirectionHorizontalDirections : ASScrollDirectionVerticalDirections;
}

#pragma mark - Private helpers

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)kind inSection:(NSUInteger)section collectionView:(ASCollectionView *)collectionView
{
  if (ASObjectIsEqual(kind, UICollectionElementKindSectionHeader)) {
    if (_delegateFlags.implementsReferenceSizeForHeader) {
      return [[self delegateForCollectionView:collectionView] collectionView:collectionView layout:_layout referenceSizeForHeaderInSection:section];
    } else {
      return [self.layout headerReferenceSize];
    }
  } else if (ASObjectIsEqual(kind, UICollectionElementKindSectionFooter)) {
    if (_delegateFlags.implementsReferenceSizeForFooter) {
      return [[self delegateForCollectionView:collectionView] collectionView:collectionView layout:_layout referenceSizeForFooterInSection:section];
    } else {
      return [self.layout footerReferenceSize];
    }
  } else {
    return CGSizeZero;
  }
}

- (BOOL)layoutHasSupplementaryViewOfKind:(NSString *)kind inSection:(NSUInteger)section collectionView:(ASCollectionView *)collectionView
{
  CGSize size = [self sizeForSupplementaryViewOfKind:kind inSection:section collectionView:collectionView];
  return [self usedLayoutValueForSize:size] > 0;
}

- (CGFloat)usedLayoutValueForSize:(CGSize)size
{
  if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
    return size.height;
  } else {
    return size.width;
  }
}

- (id<ASCollectionViewDelegateFlowLayout>)delegateForCollectionView:(ASCollectionView *)collectionView
{
  return (id<ASCollectionViewDelegateFlowLayout>)collectionView.asyncDelegate;
}

@end
