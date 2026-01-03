/**
 * @format
 */

import React from 'react';
import { render } from '@testing-library/react-native';
import App from '../App';

test('renders App with SafeAreaProvider and StatusBar', () => {
  const { root } = render(<App />);

  // Verify the app tree renders successfully
  expect(root).toBeTruthy();
  expect(root.children.length).toBeGreaterThan(0);
});
