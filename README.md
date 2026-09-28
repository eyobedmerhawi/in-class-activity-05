# Activity 05 Counter App

A Flutter counter application created for CSC 4360 Mobile App Development – In-Class Activity 05.

## Features

- Counter range from 10 to 150
- Starts at 40
- Increase and decrease buttons
- Custom positive whole-number increment
- Reset counter to 10
- Undo previous counter changes
- Slider for changing the counter
- History tracking for valid counter changes
- Prevents values below 10 or above 150
- SnackBar feedback for invalid actions and inputs
- Invalid increment input keeps the previous valid increment
- Counter changes color based on its value:
  - Red at 10
  - Green above 90
  - Black otherwise

## State Management

The app uses a `StatefulWidget` to manage:

- Current counter value
- Current increment
- Counter history
- Slider changes

`setState()` is used whenever a valid action changes what is displayed on the screen.

## Validation

The app rejects:

- Empty increment input
- Decimal increments
- Negative increments
- Non-numeric increments
- Counter values below 10
- Counter values above 150

Rejected counter actions do not change the counter or add an entry to history.

## Testing

The app was tested for:

1. Lower boundary
2. Upper boundary
3. Overshooting the allowed range
4. Invalid increment input
5. Multiple undo operations
6. Slider and undo consistency

The release APK was also tested on a physical Android device.

## Built With

- Flutter
- Dart

## Author

Eyobed Gebregziabher
CSC 4360 – Mobile App Development