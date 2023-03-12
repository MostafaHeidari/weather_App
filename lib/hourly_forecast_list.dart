import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import 'models.dart';
import 'server.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecast = Server.getHourlyForecast();
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(child: TemperatureChart(forecast)),
        Card(child: PrecipitationChart(forecast)),
        Card(child: wind(forecast)),
        //Card(child: PrecipitationChart(forecast)),
      ]),
    );
  }
}

class TemperatureChart extends StatelessWidget {
  final List<HourlyForecast> forecast;
  const TemperatureChart(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Temperature'),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(title: AxisTitle(text: '°C')),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: [
        SplineSeries(
            dataSource: forecast,
            xValueMapper: (element, index) => element.time,
            yValueMapper: (element, index) => element.temperature_2m,
            legendItemText: 'Air temp'),
        SplineSeries(
            dataSource: forecast,
            xValueMapper: (element, index) => element.time,
            yValueMapper: (element, index) => element.apparent_temperature,
            legendItemText: 'Feels-like'),
      ],
    );
  }
}


class PrecipitationChart extends StatelessWidget {
  final List<HourlyForecast> forecast;
  const PrecipitationChart(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Precipitation'),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'mm')),
      series: [
        ColumnSeries(
          dataSource: forecast.take(12).toList(),
          xValueMapper: (datum, index) => datum.time,
          yValueMapper: (datum, index) => datum.precipitation,
          pointColorMapper: (datum, index) => Color.alphaBlend(
            Colors.white.withOpacity(datum.precipitation_probability / 100),
            Colors.blueGrey,
          ),
        )
      ],
    );
  }
}

class wind extends StatelessWidget {
  final List<HourlyForecast> forecast;
  const wind(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Wind'),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'm/s')),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: [
        SplineSeries(
            dataSource: forecast,
            xValueMapper: (element, index) => element.time,
            yValueMapper: (element, index) => element.wind,
            legendItemText: 'Wind Speed'),
      ],
    );
  }
}

