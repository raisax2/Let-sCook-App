# Let's_Cook App

Welcome to **Let'sCook**, a simple and user-friendly iOS app that helps you explore recipes based on the ingredients you have. This app is the **first version** of a larger project that later evolved into **What's Cooking**.

---

## Overview

### Initial Purpose
Let'sCook was designed to allow users to input desired ingredients into a search box and receive a list of recipes featuring those ingredients. Additionally, the homepage fetches random recipes to inspire users to try something new.

### Current Functionality
- **Search Recipes**: Enter ingredients to find recipes.
- **Saved Recipes**: Save your favorite recipes for future reference.
- **Random Recipes**: Discover new dishes through randomly fetched recipes on the homepage.

### Known Limitations
- The app's database lacks actual recipe instructions. Clicking on a recipe provides ingredient lists but not step-by-step cooking directions.

### Future Development
The app has evolved into **What's_Cookin**, a collaborative project that builds upon the foundation of Let'sCook. Check it out [here](https://github.com/JQuanMoodie/Whats_Cookin).

---

## Features

### 1. **Random Recipes on Homepage**
- Fetches random recipes using the Edamam API.
- Displays a recipe's image, name, and basic details.

### 2. **Search Recipes**
- Search by including or excluding specific ingredients.
- Displays results in a scrollable list with recipe names and images.
- Save your favorite recipes for later.

### 3. **Saved Recipes**
- Access recipes you’ve saved earlier.
- View recipe details including ingredients and additional metadata.

---

## Technical Details

### Tech Stack
- **Language**: Swift
- **Framework**: UIKit
- **API**: Edamam Recipe Search API

### Key Files
1. `Homepage.swift`:
   - Fetches and displays random recipes on the homepage.
   - Provides navigation to the search and saved recipes screens.

2. `SearchIngredients.swift`:
   - Handles ingredient-based recipe search.
   - Utilizes the Edamam API to fetch recipes based on user input.

3. `Saved.swift`:
   - Displays saved recipes in a table view.
   - Allows navigation to detailed recipe views.

4. `RecipeDetail.swift`:
   - Shows details of selected recipes including ingredients and optional metadata like health labels.

5. `Random.swift`:
   - Displays additional details for random recipes fetched on the homepage.

---

## How It Works
1. **Homepage**:
   - A random recipe is fetched using the Edamam API when the app starts.
   - Users can navigate to the search or saved recipes features.

2. **Search Recipes**:
   - Users input desired and excluded ingredients.
   - The app sends a query to the Edamam API and processes results.
   - Search results are displayed as clickable views with an option to save the recipe.

3. **Save Recipes**:
   - Recipes can be saved using UserDefaults for later reference.
   - Saved recipes are displayed in a table view and can be opened for more details.

---

## Installation and Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/YourUsername/LetsCook.git
   ```

2. Open the project in Xcode:
   ```bash
   open LetsCook.xcodeproj
   ```

3. Configure API Keys:
   - Add your Edamam App ID and App Key in the `Homepage.swift` file:
     ```swift
     private let edamamAppId = "YOUR_APP_ID"
     private let edamamAppKey = "YOUR_APP_KEY"
     ```

4. Run the project:
   - Select a simulator or connected device and build/run the project in Xcode.

---

## Future Improvements
- **Recipe Instructions**: Add step-by-step cooking instructions for each recipe.
- **Enhanced UI/UX**: Improve visual elements and user interactions.
- **Data Persistence**: Explore CoreData or Realm for saving recipes.
- **Improved Search**: Refine the search feature to include advanced filtering.

---

## Acknowledgments
- **API**: [Edamam Recipe Search API](https://developer.edamam.com/)
- Developed solely by **Raisa Methila** as part of an independent project.

---
