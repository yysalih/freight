import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';

import '../constants/languages.dart';
import '../constants/providers.dart';

class NoLoadsFoundWidget extends ConsumerWidget {
  const NoLoadsFoundWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Text(languages[language]!["no_loads_found"]!, style: kCustomTextStyle,);
  }
}
