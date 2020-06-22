// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.6
part of engine;

class SurfaceCanvas implements ui.Canvas {
  RecordingCanvas/*!*/ _canvas;

  SurfaceCanvas(EnginePictureRecorder recorder, [ui.Rect cullRect])
      : assert(recorder != null) {
    if (recorder.isRecording) {
      throw ArgumentError(
          '"recorder" must not already be associated with another Canvas.');
    }
    cullRect ??= ui.Rect.largest;
    _canvas = recorder.beginRecording(cullRect);
  }

  @override
  void save() {
    _canvas.save();
  }

  @override
  void saveLayer(ui.Rect/*?*/ bounds, ui.Paint/*!*/ paint) {
    assert(paint != null);
    if (bounds == null) {
      _saveLayerWithoutBounds(paint);
    } else {
      assert(rectIsValid(bounds));
      _saveLayer(bounds, paint);
    }
  }

  void _saveLayerWithoutBounds(ui.Paint paint) {
    _canvas.saveLayerWithoutBounds(paint);
  }

  void _saveLayer(ui.Rect bounds, ui.Paint paint) {
    _canvas.saveLayer(bounds, paint);
  }

  @override
  void restore() {
    _canvas.restore();
  }

  @override
  int/*!*/ getSaveCount() => _canvas.saveCount;

  @override
  void translate(double/*!*/ dx, double/*!*/ dy) {
    _canvas.translate(dx, dy);
  }

  @override
  void scale(double/*!*/ sx, [double/*?*/ sy]) => _scale(sx, sy ?? sx);

  void _scale(double sx, double sy) {
    _canvas.scale(sx, sy);
  }

  @override
  void rotate(double/*!*/ radians) {
    _canvas.rotate(radians);
  }

  @override
  void skew(double/*!*/ sx, double/*!*/ sy) {
    _canvas.skew(sx, sy);
  }

  @override
  void transform(Float64List/*!*/ matrix4) {
    assert(matrix4 != null);
    if (matrix4.length != 16) {
      throw ArgumentError('"matrix4" must have 16 entries.');
    }
    _transform(toMatrix32(matrix4));
  }

  void _transform(Float32List matrix4) {
    _canvas.transform(matrix4);
  }

  @override
  void clipRect(ui.Rect/*!*/ rect,
      {ui.ClipOp/*!*/ clipOp = ui.ClipOp.intersect, bool/*!*/ doAntiAlias = true}) {
    assert(rectIsValid(rect));
    assert(clipOp != null);
    assert(doAntiAlias != null);
    _clipRect(rect, clipOp, doAntiAlias);
  }

  void _clipRect(ui.Rect rect, ui.ClipOp clipOp, bool doAntiAlias) {
    _canvas.clipRect(rect);
  }

  @override
  void clipRRect(ui.RRect/*!*/ rrect, {bool/*!*/ doAntiAlias = true}) {
    assert(rrectIsValid(rrect));
    assert(doAntiAlias != null);
    _clipRRect(rrect, doAntiAlias);
  }

  void _clipRRect(ui.RRect rrect, bool doAntiAlias) {
    _canvas.clipRRect(rrect);
  }

  @override
  void clipPath(ui.Path/*!*/ path, {bool/*!*/ doAntiAlias = true}) {
    assert(path != null); // path is checked on the engine side
    assert(doAntiAlias != null);
    _clipPath(path, doAntiAlias);
  }

  void _clipPath(ui.Path path, bool doAntiAlias) {
    _canvas.clipPath(path, doAntiAlias: doAntiAlias);
  }

  @override
  void drawColor(ui.Color/*!*/ color, ui.BlendMode/*!*/ blendMode) {
    assert(color != null);
    assert(blendMode != null);
    _drawColor(color, blendMode);
  }

  void _drawColor(ui.Color color, ui.BlendMode blendMode) {
    _canvas.drawColor(color, blendMode);
  }

  @override
  void drawLine(ui.Offset/*!*/ p1, ui.Offset/*!*/ p2, ui.Paint/*!*/ paint) {
    assert(offsetIsValid(p1));
    assert(offsetIsValid(p2));
    assert(paint != null);
    _drawLine(p1, p2, paint);
  }

  void _drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) {
    _canvas.drawLine(p1, p2, paint);
  }

  @override
  void drawPaint(ui.Paint/*!*/ paint) {
    assert(paint != null);
    _drawPaint(paint);
  }

  void _drawPaint(ui.Paint paint) {
    _canvas.drawPaint(paint);
  }

  @override
  void drawRect(ui.Rect/*!*/ rect, ui.Paint/*!*/ paint) {
    assert(rectIsValid(rect));
    assert(paint != null);
    _drawRect(rect, paint);
  }

  void _drawRect(ui.Rect rect, ui.Paint paint) {
    _canvas.drawRect(rect, paint);
  }

  @override
  void drawRRect(ui.RRect/*!*/ rrect, ui.Paint/*!*/ paint) {
    assert(rrectIsValid(rrect));
    assert(paint != null);
    _drawRRect(rrect, paint);
  }

  void _drawRRect(ui.RRect rrect, ui.Paint paint) {
    _canvas.drawRRect(rrect, paint);
  }

  @override
  void drawDRRect(ui.RRect/*!*/ outer, ui.RRect/*!*/ inner, ui.Paint/*!*/ paint) {
    assert(rrectIsValid(outer));
    assert(rrectIsValid(inner));
    assert(paint != null);
    _drawDRRect(outer, inner, paint);
  }

  void _drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) {
    _canvas.drawDRRect(outer, inner, paint);
  }

  @override
  void drawOval(ui.Rect/*!*/ rect, ui.Paint/*!*/ paint) {
    assert(rectIsValid(rect));
    assert(paint != null);
    _drawOval(rect, paint);
  }

  void _drawOval(ui.Rect rect, ui.Paint paint) {
    _canvas.drawOval(rect, paint);
  }

  @override
  void drawCircle(ui.Offset/*!*/ c, double/*!*/ radius, ui.Paint/*!*/ paint) {
    assert(offsetIsValid(c));
    assert(paint != null);
    _drawCircle(c, radius, paint);
  }

  void _drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    _canvas.drawCircle(c, radius, paint);
  }

  @override
  void drawArc(ui.Rect/*!*/ rect, double/*!*/ startAngle, double/*!*/ sweepAngle, bool/*!*/ useCenter,
      ui.Paint/*!*/ paint) {
    assert(rectIsValid(rect));
    assert(paint != null);
    const double pi = math.pi;
    const double pi2 = 2.0 * pi;

    final ui.Path path = ui.Path();
    if (useCenter) {
      path.moveTo(
          (rect.left + rect.right) / 2.0, (rect.top + rect.bottom) / 2.0);
    }
    bool forceMoveTo = !useCenter;
    if (sweepAngle <= -pi2) {
      path.arcTo(rect, startAngle, -pi, forceMoveTo);
      startAngle -= pi;
      path.arcTo(rect, startAngle, -pi, false);
      startAngle -= pi;
      forceMoveTo = false;
      sweepAngle += pi2;
    }
    while (sweepAngle >= pi2) {
      path.arcTo(rect, startAngle, pi, forceMoveTo);
      startAngle += pi;
      path.arcTo(rect, startAngle, pi, false);
      startAngle += pi;
      forceMoveTo = false;
      sweepAngle -= pi2;
    }
    path.arcTo(rect, startAngle, sweepAngle, forceMoveTo);
    if (useCenter) {
      path.close();
    }
    _canvas.drawPath(path, paint);
  }

  @override
  void drawPath(ui.Path/*!*/ path, ui.Paint/*!*/ paint) {
    assert(path != null); // path is checked on the engine side
    assert(paint != null);
    _drawPath(path, paint);
  }

  void _drawPath(ui.Path path, ui.Paint paint) {
    _canvas.drawPath(path, paint);
  }

  @override
  void drawImage(ui.Image/*!*/ image, ui.Offset/*!*/ offset, ui.Paint/*!*/ paint) {
    assert(image != null); // image is checked on the engine side
    assert(offsetIsValid(offset));
    assert(paint != null);
    _drawImage(image, offset, paint);
  }

  void _drawImage(ui.Image image, ui.Offset p, ui.Paint paint) {
    _canvas.drawImage(image, p, paint);
  }

  @override
  void drawImageRect(ui.Image/*!*/ image, ui.Rect/*!*/ src, ui.Rect/*!*/ dst, ui.Paint/*!*/ paint) {
    assert(image != null); // image is checked on the engine side
    assert(rectIsValid(src));
    assert(rectIsValid(dst));
    assert(paint != null);
    _drawImageRect(image, src, dst, paint);
  }

  void _drawImageRect(ui.Image image, ui.Rect src, ui.Rect dst, ui.Paint paint) {
    _canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  void drawImageNine(ui.Image/*!*/ image, ui.Rect/*!*/ center, ui.Rect/*!*/ dst, ui.Paint/*!*/ paint) {
    assert(image != null); // image is checked on the engine side
    assert(rectIsValid(center));
    assert(rectIsValid(dst));
    assert(paint != null);

    // Assert you can fit the scaled part of the image (exluding the
    // center source).
    assert(image.width - center.width < dst.width);
    assert(image.height - center.height < dst.height);

    // The four unscaled corner rectangles in the from the src.
    final ui.Rect srcTopLeft = ui.Rect.fromLTWH(
      0,
      0,
      center.left,
      center.top,
    );
    final ui.Rect srcTopRight = ui.Rect.fromLTWH(
      center.right,
      0,
      image.width - center.right,
      center.top,
    );
    final ui.Rect srcBottomLeft = ui.Rect.fromLTWH(
      0,
      center.bottom,
      center.left,
      image.height - center.bottom,
    );
    final ui.Rect srcBottomRight = ui.Rect.fromLTWH(
      center.right,
      center.bottom,
      image.width - center.right,
      image.height - center.bottom,
    );

    final ui.Rect dstTopLeft = srcTopLeft.shift(dst.topLeft);

    // The center rectangle in the dst region
    final ui.Rect dstCenter = ui.Rect.fromLTWH(
      dstTopLeft.right,
      dstTopLeft.bottom,
      dst.width - (srcTopLeft.width + srcTopRight.width),
      dst.height - (srcTopLeft.height + srcBottomLeft.height),
    );

    drawImageRect(image, srcTopLeft, dstTopLeft, paint);

    final ui.Rect dstTopRight = ui.Rect.fromLTWH(
      dstCenter.right,
      dst.top,
      srcTopRight.width,
      srcTopRight.height,
    );
    drawImageRect(image, srcTopRight, dstTopRight, paint);

    final ui.Rect dstBottomLeft = ui.Rect.fromLTWH(
      dst.left,
      dstCenter.bottom,
      srcBottomLeft.width,
      srcBottomLeft.height,
    );
    drawImageRect(image, srcBottomLeft, dstBottomLeft, paint);

    final ui.Rect dstBottomRight = ui.Rect.fromLTWH(
      dstCenter.right,
      dstCenter.bottom,
      srcBottomRight.width,
      srcBottomRight.height,
    );
    drawImageRect(image, srcBottomRight, dstBottomRight, paint);

    // Draw the top center rectangle.
    drawImageRect(
      image,
      ui.Rect.fromLTRB(
        srcTopLeft.right,
        srcTopLeft.top,
        srcTopRight.left,
        srcTopRight.bottom,
      ),
      ui.Rect.fromLTRB(
        dstTopLeft.right,
        dstTopLeft.top,
        dstTopRight.left,
        dstTopRight.bottom,
      ),
      paint,
    );

    // Draw the middle left rectangle.
    drawImageRect(
      image,
      ui.Rect.fromLTRB(
        srcTopLeft.left,
        srcTopLeft.bottom,
        srcBottomLeft.right,
        srcBottomLeft.top,
      ),
      ui.Rect.fromLTRB(
        dstTopLeft.left,
        dstTopLeft.bottom,
        dstBottomLeft.right,
        dstBottomLeft.top,
      ),
      paint,
    );

    // Draw the center rectangle.
    drawImageRect(image, center, dstCenter, paint);

    // Draw the middle right rectangle.
    drawImageRect(
      image,
      ui.Rect.fromLTRB(
        srcTopRight.left,
        srcTopRight.bottom,
        srcBottomRight.right,
        srcBottomRight.top,
      ),
      ui.Rect.fromLTRB(
        dstTopRight.left,
        dstTopRight.bottom,
        dstBottomRight.right,
        dstBottomRight.top,
      ),
      paint,
    );

    // Draw the bottom center rectangle.
    drawImageRect(
      image,
      ui.Rect.fromLTRB(
        srcBottomLeft.right,
        srcBottomLeft.top,
        srcBottomRight.left,
        srcBottomRight.bottom,
      ),
      ui.Rect.fromLTRB(
        dstBottomLeft.right,
        dstBottomLeft.top,
        dstBottomRight.left,
        dstBottomRight.bottom,
      ),
      paint,
    );
  }

  @override
  void drawPicture(ui.Picture/*!*/ picture) {
    assert(picture != null); // picture is checked on the engine side
    // TODO(het): Support this
    throw UnimplementedError();
  }

  @override
  void drawParagraph(ui.Paragraph/*!*/ paragraph, ui.Offset/*!*/ offset) {
    assert(paragraph != null);
    assert(offsetIsValid(offset));
    _drawParagraph(paragraph, offset);
  }

  void _drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    _canvas.drawParagraph(paragraph, offset);
  }

  @override
  void drawPoints(ui.PointMode/*!*/ pointMode, List<ui.Offset/*!*/>/*!*/ points, ui.Paint/*!*/ paint) {
    assert(pointMode != null);
    assert(points != null);
    assert(paint != null);
    final Float32List pointList =  offsetListToFloat32List(points);
    drawRawPoints(pointMode, pointList, paint);
  }

  @override
  void drawRawPoints(ui.PointMode/*!*/ pointMode, Float32List/*!*/ points, ui.Paint/*!*/ paint) {
    assert(pointMode != null);
    assert(points != null);
    assert(paint != null);
    if (points.length % 2 != 0) {
      throw ArgumentError('"points" must have an even number of values.');
    }
    _canvas.drawRawPoints(pointMode, points, paint);
  }

  @override
  void drawVertices(ui.Vertices/*!*/ vertices, ui.BlendMode/*!*/ blendMode, ui.Paint/*!*/ paint) {
    if (vertices == null) {
      return;
    }
    //assert(vertices != null); // vertices is checked on the engine side
    assert(paint != null);
    assert(blendMode != null);
    _canvas.drawVertices(vertices, blendMode, paint);
  }

  @override
  void drawAtlas(
    ui.Image/*!*/ atlas,
    List<ui.RSTransform/*!*/>/*!*/ transforms,
    List<ui.Rect/*!*/>/*!*/ rects,
    List<ui.Color/*!*/>/*!*/ colors,
    ui.BlendMode/*!*/ blendMode,
    ui.Rect/*?*/ cullRect,
    ui.Paint/*!*/ paint,
  ) {
    assert(atlas != null); // atlas is checked on the engine side
    assert(transforms != null);
    assert(rects != null);
    assert(colors != null);
    assert(blendMode != null);
    assert(paint != null);

    final int rectCount = rects.length;
    if (transforms.length != rectCount) {
      throw ArgumentError('"transforms" and "rects" lengths must match.');
    }
    if (colors.isNotEmpty && colors.length != rectCount) {
      throw ArgumentError(
          'If non-null, "colors" length must match that of "transforms" and "rects".');
    }

    // TODO(het): Do we need to support this?
    throw UnimplementedError();
  }

  @override
  void drawRawAtlas(
    ui.Image/*!*/ atlas,
    Float32List/*!*/ rstTransforms,
    Float32List/*!*/ rects,
    Int32List/*!*/ colors,
    ui.BlendMode/*!*/ blendMode,
    ui.Rect/*?*/ cullRect,
    ui.Paint/*!*/ paint,
  ) {
    assert(atlas != null); // atlas is checked on the engine side
    assert(rstTransforms != null);
    assert(rects != null);
    assert(colors != null);
    assert(blendMode != null);
    assert(paint != null);

    final int rectCount = rects.length;
    if (rstTransforms.length != rectCount) {
      throw ArgumentError('"rstTransforms" and "rects" lengths must match.');
    }
    if (rectCount % 4 != 0) {
      throw ArgumentError(
          '"rstTransforms" and "rects" lengths must be a multiple of four.');
    }
    if (colors != null && colors.length * 4 != rectCount) {
      throw ArgumentError(
          'If non-null, "colors" length must be one fourth the length of "rstTransforms" and "rects".');
    }

    // TODO(het): Do we need to support this?
    throw UnimplementedError();
  }

  @override
  void drawShadow(
    ui.Path/*!*/ path,
    ui.Color/*!*/ color,
    double/*!*/ elevation,
    bool/*!*/ transparentOccluder,
  ) {
    assert(path != null); // path is checked on the engine side
    assert(color != null);
    assert(transparentOccluder != null);
    _canvas.drawShadow(path, color, elevation, transparentOccluder);
  }
}
