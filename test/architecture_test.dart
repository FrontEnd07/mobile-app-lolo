import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FSD imports follow layers, isolate slices, and use public APIs', () {
    const rank = {
      'shared': 0,
      'entities': 1,
      'features': 2,
      'widgets': 3,
      'pages': 4,
      'app': 5,
    };
    final directives = RegExp(
      r"""(?:import|export) ['"]package:ecommerce_new/([^'"]+)['"]""",
    );
    final violations = <String>[];
    var sources = 0, dependencies = 0;
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final source = file.path.replaceAll(r'\', '/').replaceFirst('lib/', '');
      final from = source.split('/');
      if (!rank.containsKey(from.first)) continue;
      sources++;
      for (final match in directives.allMatches(file.readAsStringSync())) {
        final target = match.group(1)!;
        final to = target.split('/');
        if (!rank.containsKey(to.first)) continue;
        dependencies++;
        if (rank[to.first]! > rank[from.first]!) {
          violations.add('$source imports higher layer $target');
        }
        final sameSlice =
            from.first == to.first &&
            from.length > 1 &&
            to.length > 1 &&
            from[1] == to[1];
        final sliced = !['app', 'shared'].contains(from.first);
        if (from.first == to.first && sliced && !sameSlice) {
          violations.add('$source imports sibling slice $target');
        }
        if (!sameSlice &&
            ['entities', 'features', 'widgets', 'pages'].contains(to.first) &&
            (to.length != 3 || to.last != 'index.dart')) {
          violations.add('$source bypasses public API $target');
        }
      }
    }
    expect(sources, greaterThan(50));
    expect(dependencies, greaterThan(50));
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
