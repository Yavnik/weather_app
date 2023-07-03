import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/core/colors.dart';

class ForecastChartWidget extends StatefulWidget {
  final List<Weather> forecaseList;
  bool tomorrowForecast = false;
  ForecastChartWidget({super.key, required this.forecaseList, required this.tomorrowForecast});

  @override
  State<ForecastChartWidget> createState() => _ForecastChartWidgetState();
}

class _ForecastChartWidgetState extends State<ForecastChartWidget> {
  late double _min, _max;
  late List<double> _Y;
  late List<String> _X;

  int valueIndex = 0;
  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() {
    double min = double.maxFinite;
    double max = -double.maxFinite;
    for (var weather in widget.forecaseList) {
      switch (valueIndex) {
        case 0:
          min = min > weather.temperature ? weather.temperature : min;
          max = max < weather.temperature ? weather.temperature : max;
          break;
        case 1:
          min = min > weather.humidity ? weather.humidity : min;
          max = max < weather.humidity ? weather.humidity : max;
          break;
        case 2:
          min = min > weather.precipitationProbability * 100 ? weather.precipitationProbability * 100 : min;
          max = max < weather.precipitationProbability * 100 ? weather.precipitationProbability * 100 : max;
          break;
        default:
          min = min > weather.temperature ? weather.temperature : min;
          max = max < weather.temperature ? weather.temperature : max;
          break;
      }
    }

    setState(() {
      _min = min;
      _max = max;
      switch (valueIndex) {
        case 0:
          _Y = widget.forecaseList.map((weather) => weather.temperature).toList();
          break;
        case 1:
          _Y = widget.forecaseList.map((weather) => weather.humidity).toList();
          break;
        case 2:
          _Y = widget.forecaseList.map((weather) => (weather.precipitationProbability * 100).toDouble()).toList();
          break;
        default:
          _Y = widget.forecaseList.map((weather) => weather.temperature).toList();
          break;
      }
      _X = widget.forecaseList.map((weather) => intl.DateFormat(widget.tomorrowForecast ? 'h\na' : 'h a').format(weather.timeOfData)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 6),
              decoration: BoxDecoration(color: ColorPallete.primaryContainer),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    radius: 16,
                    child: Icon(Icons.timer_outlined, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.tomorrowForecast ? 'Tomorrow\'s Forecast' : 'Today\'s Forecast',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: ColorPallete.primaryContainer),
              child: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          valueIndex = 0;
                          setValues();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 42,
                        decoration: BoxDecoration(
                          color: valueIndex == 0 ? ColorPallete.primary80 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Temperature',
                            style: TextStyle(
                              color: ColorPallete.onPrimary80,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          valueIndex = 1;
                          setValues();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 42,
                        decoration: BoxDecoration(
                          color: valueIndex == 1 ? ColorPallete.primary80 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Humidity',
                            style: TextStyle(
                              color: ColorPallete.onPrimary80,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          valueIndex = 2;
                          setValues();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 42,
                        decoration: BoxDecoration(
                          color: valueIndex == 2 ? ColorPallete.primary80 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Rain',
                            style: TextStyle(
                              color: ColorPallete.onPrimary80,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: CustomPaint(
                painter: LineChartPainter(min: _min, max: _max, x: _X, y: _Y, valueIndex: valueIndex),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> x;
  final List<double> y;
  final double min;
  final double max;
  final int valueIndex;

  LineChartPainter({required this.valueIndex, required this.x, required this.y, required this.min, required this.max});

  final Color backgroundColor = ColorPallete.primaryContainer;
  final linePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final labelStyle = const TextStyle(color: Colors.black, fontSize: 16);
  final xLabelStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  static double border = 10;
  static double radius = 5;
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaintFill = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final clipRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(clipRect);
    canvas.drawPaint(Paint()..color = backgroundColor);
    final drawableHeight = size.height - 2.0 * border;
    final drawableWidth = size.width - 2.0 * border;
    final hd = drawableHeight / 5.0;
    final wd = drawableWidth / x.length.toDouble();
    final height = hd * 3.0;
    final width = drawableWidth;

    if (height < 0 || width < 0) return;
    if (max - min < 1.0e-6) return;

    final hr = height / (max - min);
    final left = border;
    final top = border;
    var c = Offset(left + wd / 2, top + height / 2);
    // _drawOutline(canvas, c, wd, height);

    final points = _computePoints(c, wd, height, hr);
    final path = _computePath(points);
    final labels = _computeLabels();
    canvas.drawPath(path, linePaint);

    _drawDataPoints(points, canvas, dotPaintFill);
    _drawLabels(canvas, labels, points, wd, top);
    final c1 = Offset(c.dx, top + 4.5 * hd);
    _drawXLabels(canvas, c1, wd);
  }

  void _drawXLabels(Canvas canvas, Offset c, double wd) {
    for (var xp in x) {
      drawTextCentered(canvas, c, xp, xLabelStyle, wd);
      c += Offset(wd, 0);
    }
  }

  void _drawLabels(Canvas canvas, List<String> labels, List<Offset> points, double wd, double top) {
    var i = 0;
    for (var label in labels) {
      final dp = points[i];
      final dy = (dp.dy - 15) < top ? 15.0 : -15.0;
      final ly = dp + Offset(0, dy);
      drawTextCentered(canvas, ly, label, labelStyle, wd);
      i++;
    }
  }

  void _drawDataPoints(List<Offset> points, Canvas canvas, Paint dotPaintFill) {
    for (int i = 0; i < points.length; i++) {
      final dp = points[i];
      canvas.drawCircle(dp, radius, dotPaintFill);
      canvas.drawCircle(dp, radius, linePaint);
    }
  }

  TextPainter measureText(String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(text: span, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset c, String text, TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final offset = c + Offset(-tp.width / 2.0, -tp.height / 2.0);
    tp.paint(canvas, offset);
    return tp.size;
  }

  List<String> _computeLabels() {
    return y.map((yp) => valueIndex == 0 ? '${yp.round()}°' : '${yp.round()}%').toList();
  }

  List<Offset> _computePoints(Offset c, double width, double height, double hr) {
    List<Offset> points = [];
    for (var yp in y) {
      final yy = height - (yp - min) * hr;
      final dp = Offset(c.dx, c.dy - height / 2 + yy);
      points.add(dp);
      c += Offset(width, 0);
    }
    return points;
  }

  Path _computePath(List<Offset> points) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
