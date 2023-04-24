# Push To-Do

The fastest, simplest way to add to-dos to Notion.

### How to use

Upon opening, Push To-Do will be recording. Tap the button once you are finished talking to create a new to-do.

### How to setup

1. Create a Notion integration: https://developers.notion.com/docs/create-a-notion-integration

2. Download this repo to your PC.

3. Add the app to your device with Xcode.

4. Replace `apiKey` in WhisperNotionManager.swift with your OpenAI API key.

5. Within the app settings within Settings.app, add:

- The internal integration token from the integration above
- The page ID if you want to add a to-do to a page
- The database ID if you want to add a page to a database

Options:

- Enable "Add to database" if you prefer new pages instead of new to-dos.
