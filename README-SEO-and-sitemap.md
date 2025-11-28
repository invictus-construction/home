SEO & sitemap — quick guide

1) Image optimization (local)

I added `optimize-images.ps1` to this project. It will:
- Create `images-backup/` the first time it runs, preserving originals.
- Use ImageMagick (magick) and/or pngquant if available to compress images **in-place** while keeping the same filenames (per your earlier request).

How to run (Windows PowerShell):

1. Open PowerShell in the project folder, for example:
   cd "C:\Users\joshc\Desktop\Josh\Invictus Construction Sarnia\ICS Home Website"
2. Install ImageMagick (recommended) from https://imagemagick.org or pngquant from https://pngquant.org/
3. Execute the script:
   ./optimize-images.ps1

NOTE: The script overwrites images in `images/` but saves originals under `images-backup/` — so it's reversible if you don't like the output. Use the backups to restore originals.

If you'd prefer I produce optimized copies in a separate `images/optimized/` folder (so srcs are unchanged and files are non-destructive), I can add that variant.


2) Sitemap — submit to Google Search Console (step-by-step)

If your site is hosted at `https://invictus-construction.github.io/home/`, here are concise steps to submit the sitemap to Google Search Console:

1. Sign in to Google Search Console: https://search.google.com/search-console
2. Add your property (if not already added):
   - Use the "URL prefix" type and enter `https://invictus-construction.github.io/home/`.
   - Follow the verification options (recommended: verify using Google Analytics, Google Tag Manager, or a verification HTML file in the site). GitHub Pages sites sometimes verify automatically via the GitHub account.
3. In the left menu, go to "Sitemaps".
4. Under "Add a new sitemap", enter the path to your sitemap (example):
   sitemap.xml
   or the full path: `https://invictus-construction.github.io/home/sitemap.xml`
5. Click Submit — Google will schedule the sitemap for crawl and report back any errors.
6. Check the sitemap status in Search Console after a few hours/days. Fix any reported issues (404s, blocked resources) and re-submit.

Extra tips:
- Keep `robots.txt` at the site root with a `Sitemap:` line pointing to the correct URL (I updated it for you already).
- Validate sitemap using an online validator (optional), or view it in a browser to ensure it loads.
- When you add new pages, re-generate the sitemap and re-submit.

If you'd like I can:
- Create an alternate script that writes optimized images into `images/optimized/` instead of overwriting originals.
- Run the optimizer here if the image files are in the repo (I couldn't find actual image files in the workspace, only references in the HTML). If you want me to generate optimized images here, upload the images to the `images/` folder in the workspace and I'll batch-process them.
