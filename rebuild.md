### rebuild website

Yes, since gh-pages already exists, let's update it properly:
First, let's verify we're on main branch and everything is committed:
```
git checkout main
git status
```
Build the web app:
flutter clean
flutter pub get
flutter build web --release --base-href "/lucky_draw_csv_app/"

Now update gh-pages:
# Switch to gh-pages branch
git checkout gh-pages

# Remove all existing files (but keep .git directory)
git rm -rf *

# Copy the new build files
cp -r build/web/* .

# Verify the essential files are present
ls
# Should see:
# - index.html
# - main.dart.js
# - flutter.js
# - manifest.json
# - assets/
# - icons/

# Add all files
git add .

# Commit
git commit -m "Update gh-pages with latest build"

# Force push to update gh-pages
git push -f origin gh-pages

# Switch back to main
git checkout main

After this, wait a few minutes and check your GitHub Pages site at:
https://tommychinnn.github.io/lucky_draw_csv_app/
Let me know if you need help with any of these steps or if you encounter any issues.