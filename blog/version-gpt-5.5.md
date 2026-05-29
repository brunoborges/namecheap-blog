# I Bought a $2 Domain and Let Copilot Wire the DNS 🚀

**DNS used to be where side projects went to lose momentum.**

Not this time, folks.

I wanted the whole loop: create a tiny site, publish it with GitHub Pages, buy a cheap domain, point it correctly, verify it works, enforce HTTPS — and do it fast.

The result: `ghpagesblog.click` went from domain purchase to live custom-domain website in about **14 minutes**.

Yay!

The trick was simple: GitHub Copilot CLI did the work, and the DNS automation came from the Namecheap skill. No manual DNS edits. No record-by-record clicking. No “wait, was that `@` or `www`?” moment.

Let’s walk it.

## The Mission

The target was intentionally tiny:

1. Build a simple landing page.
2. Publish it on GitHub Pages.
3. Buy the cheapest useful domain I could find.
4. Wire the domain to Pages using automation.
5. Verify the site is actually live.

The domain: `ghpagesblog.click`.

The cheapest TLD used: `.click`.

The price: **USD $2.00 (about CAD $2.46)**.

Not bad for a real domain with a real website behind it.

## Step 1 — Start With GitHub Pages

First move: create a public GitHub repository.

Nothing fancy. Just the place where the landing page will live.

![GitHub screen for creating a new public repository for the Pages site](images/media/create-github-repo.png)

Boom — repo created.

That is already enough surface area for Copilot CLI to start helping.

![Freshly created GitHub repository ready for site files](images/media/new-repository.png)

Then I asked GitHub Copilot CLI to create the landing page and enable GitHub Pages.

This is the fun part: instead of jumping between settings screens, I let the tool drive.

![Copilot CLI creating a landing page and enabling GitHub Pages for the repository](images/media/copilot-create-landing-page-enable-pages.png)

At this point, the site exists.

But a GitHub Pages URL is only half the vibe.

A tiny project deserves a tiny domain.

## Step 2 — Buy the Cheapest Domain That Works

I went hunting for a cheap TLD.

`.click` showed up at the right price, and `ghpagesblog.click` was available.

Neat!

![Namecheap search showing an available .click domain for the project](images/media/search-click-domain.png)

Checkout confirmed the important bit: **USD $2.00 (about CAD $2.46)**.

That is impulse-buy territory for a demo domain.

![Namecheap checkout confirmation for purchasing the .click domain](images/media/confirm-domain-purchase.png)

Now the domain exists.

But domains do nothing by themselves. They need DNS.

And DNS is where I normally want maximum automation and minimum ceremony.

## Step 3 — Turn On Namecheap API Access

To let Copilot CLI update Namecheap DNS, I needed API access enabled.

Namecheap documents the API here: https://www.namecheap.com/support/api/intro/

The direct API access settings page is here: https://ap.www.namecheap.com/settings/tools/apiaccess/

The click path is:

**Profile → Tools → Business & Dev Tools → Manage under Namecheap API Access**.

Easy peasy.

![Namecheap account tools page showing Business and Dev Tools with API Access available](images/media/namecheap-business-dev-tools.png)

Then the important settings:

- toggle API **ON**
- add your public IP to **Whitelisted IPs**
- copy the **API Key**

That’s the whole unlock.

![Namecheap API access settings showing the ON toggle, whitelisted IP addresses, and API key area](images/media/namecheap-api-access-settings.png)

Small setup. Big payoff.

## Step 4 — Install the Namecheap Skill

The DNS automation came from the Namecheap skill for GitHub Copilot CLI.

Repo: https://github.com/brunoborges/namecheap-skill

Install it like this:

```bash
gh skill install brunoborges/namecheap-skill namecheap-dns --scope user
```

That command is the bridge between “I own a domain” and “please configure it for me.”

Once installed, Copilot CLI asked for the Namecheap API username.

![Copilot CLI asking for the Namecheap API username during skill setup](images/media/copilot-prompt-username.png)

Then it asked for the API key.

![Copilot CLI asking for the Namecheap API key during skill setup](images/media/copilot-prompt-api-key.png)

After that, I had Copilot list the domains in the account.

That’s a nice confidence check before changing anything.

![Copilot CLI listing domains available in the connected Namecheap account](images/media/copilot-list-domains.png)

So far: site exists, domain exists, API works.

Now we connect the dots.

## Step 5 — Point the Domain at GitHub Pages

This is where the Namecheap skill earns its keep.

I asked Copilot CLI to configure the custom domain through the skill — not by hand, not by copying records from docs, not by opening the DNS editor.

![Copilot CLI request to configure the custom domain using the Namecheap skill](images/media/copilot-configure-custom-domain.png)

The skill paused and asked for confirmation before changing DNS.

Good. Automation should still have a seatbelt.

![Namecheap skill confirmation prompt before applying DNS changes](images/media/skill-dns-confirmation-prompt.png)

After confirmation, the skill replaced the DNS records with the GitHub Pages `A` records and a `CNAME` for `www`.

Boom.

![Namecheap skill setting GitHub Pages A records and a www CNAME for the custom domain](images/media/skill-set-dns-records.png)

Copilot also committed the `CNAME` file needed by GitHub Pages.

That matters: GitHub Pages needs to know the custom domain too.

![Copilot committing the CNAME file that tells GitHub Pages about the custom domain](images/media/copilot-commit-cname-file.png)

DNS side configured.

Repository side configured.

No manual DNS edits.

That’s the whole point.

## Step 6 — Verify Like You Mean It

I don’t trust “done” until the wire says done.

So Copilot CLI verified DNS resolution for `ghpagesblog.click`.

![Copilot CLI verifying DNS resolution for the custom domain](images/media/copilot-verify-dns-resolution.png)

Then it checked the website and confirmed HTTP 200.

![Copilot CLI confirming the custom domain responds successfully with HTTP 200](images/media/copilot-verify-http-200.png)

The full Copilot CLI session is here if you want the raw play-by-play: https://gist.github.com/brunoborges/167c988a0c4c16b8ccffca995ae98ce2

Now for the stopwatch.

The domain was purchased at **11:21:27 AM EDT**.

![Namecheap purchase confirmation showing the domain purchase timestamp](images/media/domain-purchase-timestamp.png)

The site was live at around **11:35 AM EDT**.

That’s roughly **14 minutes total** from buying the domain to a working custom-domain website.

And yes — **HTTPS enforced**.

![Live website successfully served over the custom domain](images/media/live-site-custom-domain.png)

## Why This Is Cool

Because the boring part disappeared.

I still made the decisions:

- which repo
- which domain
- which DNS target
- when to approve changes

But GitHub Copilot CLI plus the Namecheap skill handled the repetitive stuff.

That is exactly where automation should live.

Not replacing judgment.

Removing friction.

## The Takeaway

If you can publish a GitHub Pages site, you can put it on a real domain without babysitting DNS.

Install the skill, enable the API, confirm the change, verify the result — boom.

A custom domain in minutes.

A cleaner workflow.

A tiny project that suddenly feels real.

Yay! 🎉
