# connectiontomyself

`connectiontomyself` is a small, server-rendered personal website and writing
space. It favors direct links, chronological browsing, readable pages, and
content ownership over feeds, metrics, and unnecessary JavaScript.

## Stack

- Ruby 3.4 and Rails 8.1
- PostgreSQL
- ERB, Propshaft, and plain CSS
- CommonMarker for Markdown and Rails sanitization for rendered HTML
- bcrypt-backed administrator authentication

## Local setup on WSL Ubuntu

Install Ruby 3.4, Bundler, and PostgreSQL, then create a local role and
databases. The role must be able to connect to both databases:

```sh
sudo -u postgres createuser --createdb connectiontomyself
createdb -U connectiontomyself connectiontomyself_development
createdb -U connectiontomyself connectiontomyself_test
```

If the application role does not have `CREATEDB`, run the test database command
as the PostgreSQL administrator instead:

```sh
sudo -u postgres createdb -O connectiontomyself connectiontomyself_test
```

Keep the password in the shell environment rather than in this repository:

```sh
export CONNECTIONTOMYSELF_DATABASE_PASSWORD="your-local-password"
bundle install
bin/rails db:prepare
bin/rails server
```

Visit `/` for the public site and `/admin/login` for administration.

Create the first administrator once, using a password of at least 12
characters:

```sh
ADMIN_EMAIL="you@example.com" \
ADMIN_PASSWORD="use-a-long-local-password" \
bin/rails admin:create
```

There is deliberately no public administrator signup route.

## Tests and security checks

Run the test suite with:

```sh
export CONNECTIONTOMYSELF_DATABASE_PASSWORD="your-local-password"
bin/rails test
bin/brakeman
bin/bundler-audit
```

The test database password is read from the same environment variable as the
development database. Draft posts are never selected by public controllers,
and Markdown is parsed and sanitized in `MarkdownRenderer`.

## Implemented

- Handcrafted responsive public layout and navigation
- Placeholder About, Now, Colophon, Projects, Links, Uses, Guestbook, and Subscribe pages
- PostgreSQL-backed posts with slugs, drafts, publication timestamps, and reading times
- Safe Markdown article rendering and RSS 2.0 feed for published posts
- Private admin login and post create/edit/publish/unpublish/delete workflow
- Editable About, Now, Colophon, and Uses pages, projects, and links
- Chronological archive
- Moderated guestbook with a honeypot and escaped visitor content
- Double-opt-in subscriber records with confirmation and unsubscribe tokens
- GitHub Actions checks for tests, RuboCop, Brakeman, and Bundler Audit

## Remaining work

Resend confirmation delivery is enabled when these environment variables are
configured:

```sh
export RESEND_API_KEY="your-resend-api-key"
export NEWSLETTER_FROM="onboarding@resend.dev"
export APP_HOST="localhost"
export APP_PORT="3000"
export APP_PROTOCOL="http"
```

Use a verified sender domain for production rather than `onboarding@resend.dev`.
Confirmation emails are queued through Solid Queue and sent by `Resend::Emails.send`.
OAuth/passkey providers, automated backups,

### Sending a newsletter

Newsletters are separate records from public writings. After at least one
subscriber confirms their email address:

1. Open **Newsletters** from `/admin`.
2. Create and save a newsletter draft.
3. The app queues one Resend email per active subscriber.
4. Send it from the newsletter dashboard. Sent newsletters cannot be sent again.

In production, run a Solid Queue worker so queued confirmation and newsletter
jobs are processed. A post cannot be sent while it is a draft, and no email is
sent when Resend is not configured.
error monitoring, and full integration coverage should be added before a public
launch. The first administrator must be provisioned manually with
`bin/rails admin:create`.

## Deployment

Use the existing Rails/Kamal deployment configuration with a production
`DATABASE_URL` or Rails database environment variables. Set the Rails master
key, database credentials, and administrator credentials through the hosting
secret manager. Never commit those values.

For production operations:

- Set `FORCE_SSL=true` behind an HTTPS reverse proxy.
- Run `bin/jobs` continuously for Solid Queue confirmation/newsletter jobs.
- Back up PostgreSQL on a schedule and test restoring a backup before launch.
- Monitor `/up` and configure an external error monitor for application failures.
- Run `bin/rails db:migrate` during deployment before serving new code.
