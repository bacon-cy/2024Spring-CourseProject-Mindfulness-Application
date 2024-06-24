import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangedEnd;

  const SeekBar(
      {Key? key,
      required this.position,
      required this.duration,
      this.onChanged,
      this.onChangedEnd})
      : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_formatDuration(widget.position),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                )),
        Expanded(
          child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 4,
                  enabledThumbRadius: 4,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 10,
                ),
                activeTrackColor: Colors.white,
                inactiveTickMarkColor: Colors.white,
                thumbColor: Colors.white,
                overlayColor: Colors.white,
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(
                      Duration(
                        milliseconds: value.round(),
                      ),
                    );
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangedEnd != null) {
                    widget.onChangedEnd!(Duration(
                      milliseconds: value.round(),
                    ));
                  }
                  _dragValue = null;
                },
              )),
        ),
        Text(_formatDuration(widget.duration),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                )),
      ],
    );
  }
}