# Burn It Up
This is a Mobile App that records exercises and calculate burned calories for users on a daily basis. Users can also access their exercise data each day by clicking on a day in the calendar. The App requests calories value from an API according to user inputs (exercise type and time duration). 

## What it looks like?
<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_1.png" width="250">
</p>

At the HomePage, to start select a date and click the top-right add button. It will proceed to the record page.

<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_2.png" width="250">
</p>

At this page, you will need to select your exercise type from a list, and enter exercise time. Then click calculate to show the burned calories.

<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_3.png" width="250">
</p>
<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_4.png" width="250">
</p>
<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_5.png" width="250">
</p>

After returning to HomePage, select the date you just recorded, it will pop up the exercise record.

<p align="center">
<img
src="https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/Screenshot_7.png" width="250">
</p>

Watch the demo video here:
- https://github.com/ucfnnbx/casa0015-mobile-assessment/blob/main/screenshots/video.mp4

## Packages and API
- table_calendar 3.0.9 https://pub.dev/packages/table_calendar 
  Highly customizable, feature-packed calendar widget for Flutter.
- http 0.12.0+1 https://pub.dev/packages/http
  A composable, multi-platform, Future-based API for HTTP requests.
- path_provider 2.0.14 https://pub.dev/packages/path_provider
  A Flutter plugin for finding commonly used locations on the filesystem. Supports Android, iOS, Linux, macOS and Windows.
  
- Access API link here:
  https://api-ninjas.com/api/caloriesburned
- Request activities URL: 
  https://api-ninjas.com/api/caloriesburned
- Request caloriesburned URL example:
  https://api.api-ninjas.com/v1/caloriesburned?activity=skiing&duration=60

## How To Install The App
1. Download folder 'my_app'.
2. Open folder with Android Studio or Visual Studio Code IDE.
3. Get packages: From the terminal: Run flutter pub get . From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml indicated by the Download icon. From Android Studio/IntelliJ: Click Pub get in the action ribbon at the top of pubspec.yaml.
4. For connection to API please generate an API key on https://api-ninjas.com/

##  Contact Details
Email: 915652009@qq.com
