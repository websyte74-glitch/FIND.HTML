# UPSA Find

UPSA Find is a static site for GitHub Pages. It uses Supabase for the shared listings database, so reports submitted from one device are available to other visitors.

## 1. Create the Supabase database

1. Sign in to [Supabase](https://supabase.com/) and create a project.
2. In the Supabase dashboard, open **SQL Editor** and start a new query.
3. Copy all the SQL from [`supabase/schema.sql`](./supabase/schema.sql), paste it into the query, and run it. This creates the listings table, input constraints, and public read/create policies. Row Level Security remains enabled.
4. In **Project Settings → API Keys**, copy the **Project URL** and the public **publishable key** (starts with `sb_publishable_`). A legacy `anon` key is also supported. These public keys are designed for use in a website; never use a service-role or secret key in this project.

## 2. Connect the website

1. Open [`supabase-config.js`](./supabase-config.js).
2. Replace `YOUR_SUPABASE_PROJECT_URL` with the Project URL and `YOUR_SUPABASE_PUBLISHABLE_OR_LEGACY_ANON_KEY` with the public publishable key or legacy anon key. Keep the quotation marks.
3. Save and push the changes to GitHub. The configuration file contains a public browser key, not a database secret. Database access is restricted by the SQL policies.

## 3. Publish with GitHub Pages

1. In your GitHub repository, make sure `index.html`, `supabase-config.js`, and the `supabase` folder are in the repository's published folder (normally the repository root).
2. Open the repository **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**, select the `main` branch and `/ (root)`, then save.
4. Wait for the Pages deployment and open the URL shown under **Settings → Pages**. You can share that URL with students.
5. Submit a test listing, then open the Pages URL on another device to confirm that it appears there too.

## Run locally

Serve this folder using a local web server (for example, XAMPP) rather than opening `index.html` as a `file://` URL. Configure the Supabase project first; then the site can use the same shared database as the published site.

## Public information

Visitors can read and create listings without signing in. Names and contact emails are visible to everyone, and public submissions can attract spam. Do not post sensitive ID details. Add sign-in, moderation, and abuse protection before using this as an official university service.
