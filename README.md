# Icon_Dock

Welcome to **Icon_Dock**, an elegant and customizable dock implementation inspired by macOS, designed specifically for Flutter applications. This project serves as a showcase for developing a visually appealing dock featuring draggable and sortable icons, elevating the user experience through intuitive design and animation.

## Features

- **Drag-and-Drop Functionality**: Seamlessly reorder icons within the dock with simple drag-and-drop interactions, allowing users to personalize their experience.
- **Customizable Appearance**: Tailor the look of dock icons according to individual preferences, enhancing aesthetic appeal and usability.
- **Smooth Animations**: Enjoy fluid transitions and animations when rearranging icons, contributing to a polished and engaging interface.
- **Responsive Layout**: The dock adapts gracefully to various screen sizes and orientations, ensuring a consistent experience across different devices.

## Getting Started

To set up and run **Icon_Dock**, follow these steps:

## Screenshots

| Screenshot 1 | Screenshot 2 | Screenshot 3 |
|--------------|--------------|--------------|
 ![Screenshot1](https://github.com/Adonias-hibeste/dockbuttons/blob/master/photo_2024-11-05_02-42-51%20(2).jpg) | ![Screenshot2](https://github.com/Adonias-hibeste/dockbuttons/blob/master/photo_2024-11-05_02-42-51%20(3).jpg) |  ![Screenshot2](https://github.com/Adonias-hibeste/dockbuttons/blob/master/photo_2024-11-05_02-42-51.jpg)
### Prerequisites

Ensure you have Flutter installed on your machine. You can verify your installation by executing:

```bash
flutter --version
```
### Clone the Repository

Use the following command to clone the project:

```bash
git clone git@github.com:Adonias-hibeste/Icon_dock.git
```
### Navigate to the Project Directory

Change your directory to the project folder:

```bash
cd Icon_dock
```
### Install Dependencies

Fetch the required packages:

```bash
flutter pub get
```
### Run the Application

Start the app with the following command:
```bash
flutter run -d chrome
```
## Usage Example

You can easily customize the main Dock widget by specifying various icons and styles. Here’s an illustrative example:
```bash
Dock<IconData>(
  items: const [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ],
  builder: (IconData icon, bool isDragging) {
    return DockItem(
      icon: icon,
      isDragging: isDragging,
    );
  },
);

```
## Contribution
Contributions to Icon_Dock are welcome! If you have suggestions or improvements, please fork the repository and submit a pull request. You can also open an issue if you encounter any bugs or have feature requests.

#Steps to Contribute
1. Fork the repository.
2. Create a new branch (git checkout -b feature/YourFeature).
3. Make your changes.
4. Commit your changes (git commit -m 'Add some feature').
5. Push to the branch (git push origin feature/YourFeature).
6. Open a pull request.


## Conclusion
Icon_Dock exemplifies how to create a functional and customizable dock using Flutter. With its intuitive drag-and-drop capabilities and engaging animations, it significantly enhances the overall user experience.

For any questions, suggestions, or contributions, feel free to open an issue or submit a pull request on the GitHub repository.
