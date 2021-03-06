// Copyright (c) 2016, Ben Sheron. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library physics.test;

import 'test_gravity_2d.dart' as test_gravity_2d;
import 'test_integration.dart' as test_integration;

void main() {
  test_gravity_2d.run();
  test_integration.run();
}
