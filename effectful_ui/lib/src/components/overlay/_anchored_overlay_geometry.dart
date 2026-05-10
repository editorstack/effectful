import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Describes how an overlay attaches to its anchor.
@immutable
class EffectfulAnchoredOverlayPlacement {
  /// Creates an anchored overlay placement definition.
  const EffectfulAnchoredOverlayPlacement({
    required this.targetAnchor,
    required this.followerAnchor,
    required this.offset,
  });

  /// Anchor on the anchor rect used as the attachment point.
  final Alignment targetAnchor;

  /// Anchor on the overlay used to align with [targetAnchor].
  final Alignment followerAnchor;

  /// Additional offset applied after anchor alignment.
  final Offset offset;
}

/// Resolves the best placement for an anchored overlay inside the viewport.
EffectfulAnchoredOverlayPlacement effectfulResolveAnchoredOverlayPlacement({
  required Size viewportSize,
  required Rect anchorRect,
  required Size overlaySize,
  required EdgeInsets viewportPadding,
  required EffectfulAnchoredOverlayPlacement preferredPlacement,
}) {
  final preferredRect = effectfulResolveAnchoredOverlayRect(
    anchorRect: anchorRect,
    overlaySize: overlaySize,
    placement: preferredPlacement,
  );
  if (_fitsWithinViewport(preferredRect, viewportSize, viewportPadding)) {
    return preferredPlacement;
  }

  final flippedPlacement = _flipPlacement(preferredPlacement);
  final flippedRect = effectfulResolveAnchoredOverlayRect(
    anchorRect: anchorRect,
    overlaySize: overlaySize,
    placement: flippedPlacement,
  );

  if (_overflowDistance(flippedRect, viewportSize, viewportPadding) <
      _overflowDistance(preferredRect, viewportSize, viewportPadding)) {
    return flippedPlacement;
  }

  return preferredPlacement;
}

/// Resolves the overlay rectangle for a specific anchored placement.
Rect effectfulResolveAnchoredOverlayRect({
  required Rect anchorRect,
  required Size overlaySize,
  required EffectfulAnchoredOverlayPlacement placement,
}) {
  final targetPoint = _alignmentPointForRect(
    anchorRect,
    placement.targetAnchor,
  );
  final followerPoint = _alignmentPointForSize(
    overlaySize,
    placement.followerAnchor,
  );

  return Rect.fromLTWH(
    targetPoint.dx + placement.offset.dx - followerPoint.dx,
    targetPoint.dy + placement.offset.dy - followerPoint.dy,
    overlaySize.width,
    overlaySize.height,
  );
}

/// Clamps an overlay rectangle so it stays within the padded viewport.
Rect effectfulClampAnchoredOverlayRect({
  required Rect rect,
  required Size viewportSize,
  required EdgeInsets viewportPadding,
}) {
  final maxLeft = math.max(
    viewportPadding.left,
    viewportSize.width - viewportPadding.right - rect.width,
  );
  final maxTop = math.max(
    viewportPadding.top,
    viewportSize.height - viewportPadding.bottom - rect.height,
  );

  return Rect.fromLTWH(
    rect.left.clamp(viewportPadding.left, maxLeft).toDouble(),
    rect.top.clamp(viewportPadding.top, maxTop).toDouble(),
    rect.width,
    rect.height,
  );
}

EffectfulAnchoredOverlayPlacement _flipPlacement(
  EffectfulAnchoredOverlayPlacement placement,
) {
  final axis = _preferredFlipAxis(placement);
  return switch (axis) {
    Axis.vertical => EffectfulAnchoredOverlayPlacement(
        targetAnchor: Alignment(
          placement.targetAnchor.x,
          -placement.targetAnchor.y,
        ),
        followerAnchor: Alignment(
          placement.followerAnchor.x,
          -placement.followerAnchor.y,
        ),
        offset: Offset(
          placement.offset.dx,
          -placement.offset.dy,
        ),
      ),
    Axis.horizontal => EffectfulAnchoredOverlayPlacement(
        targetAnchor: Alignment(
          -placement.targetAnchor.x,
          placement.targetAnchor.y,
        ),
        followerAnchor: Alignment(
          -placement.followerAnchor.x,
          placement.followerAnchor.y,
        ),
        offset: Offset(
          -placement.offset.dx,
          placement.offset.dy,
        ),
      ),
  };
}

Axis _preferredFlipAxis(EffectfulAnchoredOverlayPlacement placement) {
  final xDistance = (placement.targetAnchor.x - placement.followerAnchor.x).abs();
  final yDistance = (placement.targetAnchor.y - placement.followerAnchor.y).abs();
  final weightedX = xDistance + (placement.offset.dx.abs() / 1000);
  final weightedY = yDistance + (placement.offset.dy.abs() / 1000);

  if (weightedY > weightedX) {
    return Axis.vertical;
  }
  if (weightedX > weightedY) {
    return Axis.horizontal;
  }
  return placement.offset.dy.abs() >= placement.offset.dx.abs() ? Axis.vertical : Axis.horizontal;
}

bool _fitsWithinViewport(
  Rect rect,
  Size viewportSize,
  EdgeInsets viewportPadding,
) {
  return rect.left >= viewportPadding.left &&
      rect.top >= viewportPadding.top &&
      rect.right <= viewportSize.width - viewportPadding.right &&
      rect.bottom <= viewportSize.height - viewportPadding.bottom;
}

double _overflowDistance(
  Rect rect,
  Size viewportSize,
  EdgeInsets viewportPadding,
) {
  final overflowLeft = math.max(0.0, viewportPadding.left - rect.left);
  final overflowTop = math.max(0.0, viewportPadding.top - rect.top);
  final overflowRight = math.max(
    0.0,
    rect.right - (viewportSize.width - viewportPadding.right),
  );
  final overflowBottom = math.max(
    0.0,
    rect.bottom - (viewportSize.height - viewportPadding.bottom),
  );
  return overflowLeft + overflowTop + overflowRight + overflowBottom;
}

Offset _alignmentPointForRect(Rect rect, Alignment alignment) {
  return Offset(
    rect.left + ((alignment.x + 1) * rect.width / 2),
    rect.top + ((alignment.y + 1) * rect.height / 2),
  );
}

Offset _alignmentPointForSize(Size size, Alignment alignment) {
  return Offset(
    (alignment.x + 1) * size.width / 2,
    (alignment.y + 1) * size.height / 2,
  );
}
