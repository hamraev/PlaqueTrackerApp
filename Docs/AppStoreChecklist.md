# PlaqueTracker App Store Checklist

## App Name
PlaqueTracker

## Subtitle Ideas
- Smile missions for better brushing
- Brush smarter with friendly scans
- Plaque spotting for healthy habits

## Short Description
PlaqueTracker helps kids build better brushing habits with guided smile scans, red-spot brushing missions, before-and-after photo comparisons, rewards, and bite-size learning tips.

## Keywords
kids brushing, oral hygiene, plaque, toothbrush, dental habits, smile, rewards, brushing timer, teeth, family health

## Privacy Notes
- Photos and scan data are stored locally on the device for now.
- No backend account or cloud sync is currently required.
- Parents should review saved photos before sharing screenshots or support logs.

## Required Permissions
- Camera: Used to take before and after smile photos for brushing progress.
- Photos: Used as a fallback when camera capture is unavailable, such as in the simulator.
- Notifications: Optional daily brushing reminders.
- Bluetooth: Used to connect to the PlaqueTracker scanner device when hardware is available.

## Suggested Screenshots
- Home mission screen with Smile Score and Start Smile Scan
- Live scan mission flow
- Brush Map with red-spot guidance
- Before/after comparison
- Rewards and achievement badges
- Learn screen with one-tip lessons
- Settings with reminder and privacy note

## Age Rating Considerations
- Designed for children and families.
- No user-generated public sharing in the current implementation.
- No ads, gambling, mature content, or unrestricted web access should be added without a new review.

## Medical Disclaimer
PlaqueTracker is an educational oral hygiene support tool and not a medical diagnosis device. It does not replace guidance from a dentist, doctor, or qualified healthcare professional.

## Release Readiness
- Confirm camera, photo, notification, and Bluetooth permission copy in the generated Info.plist.
- Verify the app works without PlaqueTracker hardware by using mock scan results.
- Test reminder scheduling after granting and denying notification permission.
- Test light mode, dark mode, and Match Device appearance.
- Test Reduce Motion to ensure animations become subtle.
- Review screenshots for kid-friendly labels and clear next actions.
