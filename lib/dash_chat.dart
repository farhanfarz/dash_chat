library dash_chat;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:youtube_explode_dart/src/videos/streams/video_quality.dart';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:dash_chat/src/widgets/bot_typing_indicator.dart';

export 'package:intl/intl.dart' hide TextDirection;
export 'package:flutter_parsed_text/flutter_parsed_text.dart';

part 'src/chat_view.dart';
part 'src/models/reply.dart';
part 'src/models/rate.dart';
part 'src/models/quick_replies.dart';
part 'src/models/chat_user.dart';
part 'src/models/chat_message.dart';
part 'src/models/scroll_to_bottom_style.dart';
part 'src/widgets/custom_scroll_behaviour.dart';
part 'src/chat_input_toolbar.dart';
part 'src/message_listview.dart';
part 'src/widgets/date_builder.dart';
part 'src/widgets/avatar_container.dart';
part 'src/widgets/message_container.dart';
part 'src/widgets/quick_reply.dart';
part 'src/widgets/scroll_to_bottom.dart';
part 'src/widgets/load_earlier.dart';
