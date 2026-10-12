# UPSA Find

UPSA Find is a static site for GitHub Pages. It uses Supabase for the shared listings database, so reports submitted from one device are available to other visitors.

## 1. Create the Supabase database

1. Sign in to [Supabase](https://supabase.com/) and create a project.
2. In the Supabase dashboard, open **SQL Editor** and start a new query.
3. Copy all the SQL from [`supabase/schema.sql`](./supabase/schema.sql), paste it into the query, and run it. This creates the listings table, input constraints, public read access, and signed-in-only reporting. Row Level Security remains enabled.
4. In **Project Settings → API Keys**, copy the **Project URL** and the public **publishable key** (starts with `sb_publishable_`). A legacy `anon` key is also supported. These public keys are designed for use in a website; never use a service-role or secret key in this project.

## 2. Configure authentication

1. For a project that already has the earlier UPSA Find schema, run all SQL from [`supabase/auth-setup.sql`](./supabase/auth-setup.sql) in the Supabase SQL Editor. It adds account ownership to reports, restricts new reports to their signed-in author, and enforces the UPSA email domain on the server.
2. In Supabase **Authentication → URL Configuration**, set the Site URL to the published GitHub Pages URL and add that URL to the allowed redirect URLs. For local development, also allow your local XAMPP address.
3. Keep email confirmation enabled so new accounts must confirm their UPSA inbox before signing in.

## 3. Connect the website

1. Open [`supabase-config.js`](./supabase-config.js).
2. Replace `YOUR_SUPABASE_PROJECT_URL` with the Project URL and `YOUR_SUPABASE_PUBLISHABLE_OR_LEGACY_ANON_KEY` with the public publishable key or legacy anon key. Keep the quotation marks.
3. Save and push the changes to GitHub. The configuration file contains a public browser key, not a database secret. Database access is restricted by the SQL policies.

## 4. Publish with GitHub Pages

1. In your GitHub repository, make sure `index.html`, `supabase-config.js`, and the `supabase` folder are in the repository's published folder (normally the repository root).
2. Open the repository **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**, select the `main` branch and `/ (root)`, then save.
4. Wait for the Pages deployment and open the URL shown under **Settings → Pages**. You can share that URL with students.
5. Submit a test listing, then open the Pages URL on another device to confirm that it appears there too.

## Run locally

Serve this folder using a local web server (for example, XAMPP) rather than opening `index.html` as a `file://` URL. Configure the Supabase project first; then the site can use the same shared database as the published site.

## Public information

Anyone can read listings, but only signed-in accounts using `@upsamail.edu.gh` can create new reports. Reporters' names and UPSA email addresses are visible to everyone. Do not post sensitive ID details. Add moderation and abuse protection before using this as an official university service.

## Returning an item safely

1. Use the email button on the listing to contact the finder or owner. The email is visible to all visitors.
2. Verify ownership privately by asking for a detail that was not included in the listing. Do not share passwords, PINs, full ID numbers, or private serial numbers.
3. Arrange the handover at an official UPSA security or lost-property office, if available. Otherwise, meet in a busy public place on campus.
