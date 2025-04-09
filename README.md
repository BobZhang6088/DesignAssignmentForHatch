## How to build and run the project

### 1.	Make sure your Mac has the latest version of Xcode installed
- Xcode 16 or later is required.
### 2.	Clone or Download the Repository
- Clone with Git:
  ```
  git clone https://github.com/BobZhang6088/DesignAssignmentForHatch.git
  ```


- Or clike  [Code] > Download ZIP and extract it.

### 3.	Open the Project in Xcode
- Navigate to the project folder and double-click DesignAssignmentForHatch.xcodeproj.
 This will open the project in Xcode.
	
### 4.	Select a Simulator or Device
- In the toolbar near the top of Xcode, choose an available simulator or device.
![Simulator](./How%20to%20run/select_a_simulator.png)
### 5. Run the App
- Click the ▶️ (Play) button in the top-left corner of Xcode to build and run the app on the selected simulator.
![play](./How%20to%20run/play.png)


---

Note:
If you want to run the app on a real device:
- Make sure you’re signed in with your Apple Developer account in Xcode.
- Update the Bundle Identifier in the project settings to something unique.

![change_bundleID](./How%20to%20run/change_bundleID.png)

--- 

## Vide Demo

[Click to play the video](VideoDemo.mov)

If the video doesn't play in your browser, you can find "VideoDemo.mov" in the root directory of this project. Please download it to your computer and play it locally.

## Response to the Assignment Feedback

### 1. Sheet Gesture Behavior

In iOS, the keyboard’s presentation and dismissal are controlled by the system and can’t be interactively driven with the gesture itself. However, I added a drag gesture to the sheet that tracks the user’s finger. When the sheet is dragged upwards beyond half the keyboard height, it triggers the keyboard to appear. Similarly, dragging downward dismisses the keyboard. This creates a responsive interaction while working within iOS system constraints.

### 2. Text Resizing Animation

I’ve removed the fade effect as suggested. I did try implementing a resizing transition, but it looked slightly off and less natural in this context. I believe having no animation here results in a cleaner experience.

### 3. Layout Glitch on Expansion

I’ve fixed the layout issue that occurred when the sheet expanded to full screen with an attached image.

Please feel free to download and run the updated version. I’ve also included an updated video demo (VideoDemo.mov) in the root directory of the project.