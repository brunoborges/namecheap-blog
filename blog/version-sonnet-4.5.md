# How to Deploy a Live Site with a Custom Domain in Under 15 Minutes (No DNS Editing Required!)

Here's a problem I bet you've faced: you build something cool, you want it on the web with a real domain name, but then... DNS. The moment where momentum dies and the Googling begins. "Wait, what's a CNAME again?" "Do I need four A records or just one?" "Why does nothing work yet — oh right, TTL propagation." 😅

Look, I get it. DNS is powerful, but it's also one of those things that feels like homework every single time.

So I tried something different — I built a site, bought a domain for **two bucks**, and let GitHub Copilot CLI handle *all* the DNS wiring for me. No copy-pasting IP addresses into web forms, no second-guessing record types. Just plain English requests, and boom 🚀 — live site with HTTPS.

And folks, it took **14 minutes** start to finish.

Let me show you exactly how I did it.

## What You'll Need

Before we dive in, here's your shopping list:

- **A GitHub account** (free tier is fine)
- **GitHub Copilot CLI** installed and authenticated
- **A Namecheap account** (signing up takes like 2 minutes)
- **Two dollars** — or whatever your favorite cheap TLD costs
- **About 15 minutes** of your time

That's it! No DNS expertise required. Promise.

## Step 1: Build the Site and Get It on GitHub Pages

First things first — we need something to publish. For this tutorial I'm keeping it dead simple: a basic landing page on GitHub Pages.

### Create a public repository

I started by spinning up a new public repo on GitHub. Nothing fancy:

![Creating a new public GitHub repository on GitHub](images/media/create-github-repo.png)

![The newly created empty repository ready for content](images/media/new-repository.png)

### Let Copilot do the heavy lifting

Here's where it gets fun. Instead of manually creating an `index.html`, committing it, pushing, navigating to the Pages settings, enabling the feature, selecting a branch... I just asked Copilot to do all of it:

![Copilot creating a landing page and enabling GitHub Pages in one go](images/media/copilot-create-landing-page-enable-pages.png)

Yay! 🎉 The site is now live at a `github.io` URL. That was easy — but we're not done yet. A `.github.io` subdomain is cool, but a custom domain? That's the dream.

## Step 2: Buy a Domain (The Cheaper, The Better)

Time to grab a domain. I went hunting for the cheapest TLD I could find, and landed on `.click` — which is *perfect* for a quick demo like this:

![Searching for an available .click domain on Namecheap](images/media/search-click-domain.png)

Found one! **ghpagesblog.click** — I love it already. Let's buy it:

![Confirming the purchase of the .click domain](images/media/confirm-domain-purchase.png)

Total cost? **USD $2.00** — about **CAD $2.46**. Two dollars for a real domain name. Honestly, I've paid more for a coffee that I didn't even finish.

Alright — we've got a site, we've got a domain. Now comes the part that usually makes people cry: DNS configuration. But not today!

## Step 3: Wire It All Up (Without Touching DNS)

This is where the magic happens. Instead of manually configuring DNS records, we're going to let an AI assistant do the work. Here's how.

### Enable Namecheap API Access

First, we need to unlock Namecheap's API so Copilot can talk to it on our behalf.

Head to **Profile → Tools** in your Namecheap account, scroll down to **Business & Dev Tools**, and click **Manage** under *Namecheap API Access*:

![Namecheap Business & Dev Tools section showing the API Access option](images/media/namecheap-business-dev-tools.png)

Or if you're impatient like me, just go straight to the settings page: <https://ap.www.namecheap.com/settings/tools/apiaccess/> (note: this URL might change in the future, but it's correct as of this writing).

Once you're there, you need to do three things:

1. **Toggle the API to ON** — this enables programmatic access to your domains.
2. **Add your public IP to the Whitelisted IPs list** — Namecheap uses IP whitelisting for security. Just add the public IP of the machine you'll be running commands from.
3. **Copy the API Key** — you'll need this in a moment, so paste it somewhere safe (but not in your public GitHub repo, obviously 😉).

![Namecheap API access settings page showing the ON toggle, whitelisted IPs section, and API key field](images/media/namecheap-api-access-settings.png)

Want the full docs? Check out [Namecheap's API intro guide](https://www.namecheap.com/support/api/intro/).

> **Quick aside:** Why do we need API access? Because the [Namecheap skill](https://github.com/brunoborges/namecheap-skill) we're about to install lets Copilot CLI interact with your Namecheap account — reading your domain list, updating DNS records, all that good stuff. It's like giving your AI assistant the keys to your domain registrar (but only for your account, and only from whitelisted IPs).

### Install the Namecheap Skill for Copilot CLI

Now let's give Copilot the ability to manage Namecheap domains. This is a one-line install:

```bash
gh skill install brunoborges/namecheap-skill namecheap-dns --scope user
```

Easy peasy! That command installs the [Namecheap skill](https://github.com/brunoborges/namecheap-skill) so Copilot knows how to talk to Namecheap's API.

Once installed, the first time you ask Copilot to do something like *"list my Namecheap domains"*, it'll prompt you for credentials. First, your Namecheap username:

![Copilot CLI prompting for the Namecheap API username during first-time setup](images/media/copilot-prompt-username.png)

Then it'll ask for that API key you copied earlier:

![Copilot CLI prompting for the Namecheap API key](images/media/copilot-prompt-api-key.png)

And just like that, Copilot shows you all the domains in your account:

![Copilot CLI successfully listing the domains in the Namecheap account](images/media/copilot-list-domains.png)

Neat! Now we're cooking.

### Point the Domain at GitHub Pages

Alright, here's the moment of truth. I'm going to ask Copilot to configure my brand-new domain to point at my GitHub Pages site:

![Asking Copilot to configure the custom domain via the Namecheap skill](images/media/copilot-configure-custom-domain.png)

Before making any changes, the skill asks for confirmation — which I appreciate, because nobody wants accidental DNS changes:

![The Namecheap skill asking for confirmation before modifying DNS records](images/media/skill-dns-confirmation-prompt.png)

I say yes, and... it does everything. It replaces the default parking records with GitHub Pages' A records (which point to GitHub's servers) and sets up a CNAME for the `www` subdomain:

![The skill replacing DNS records with GitHub Pages A records and a CNAME for www](images/media/skill-set-dns-records.png)

> **What just happened?** DNS has different types of records. **A records** map a domain (like `ghpagesblog.click`) to an IP address (in this case, GitHub's servers). **CNAME records** map a subdomain (like `www.ghpagesblog.click`) to another domain. GitHub Pages needs both to work properly. And Copilot just handled all of that for me.

But wait, there's more! Copilot also commits a `CNAME` file to my repo with the custom domain name. This tells GitHub Pages "hey, this site should respond to requests for `ghpagesblog.click`":

![Copilot committing the CNAME file with the custom domain to the repository](images/media/copilot-commit-cname-file.png)

## Step 4: Verify Everything Works

We're done... right? Well, let's make sure. Copilot doesn't just make changes and walk away — it verifies the work.

First, it checks that the DNS is resolving correctly:

![Copilot verifying that DNS resolution is working for the custom domain](images/media/copilot-verify-dns-resolution.png)

Then it confirms the site is actually responding with a healthy HTTP 200 status:

![Copilot confirming the custom domain returns HTTP 200 and the site is live](images/media/copilot-verify-http-200.png)

And that's it! The site is live. 🎉

Want to see the full session? I saved the entire Copilot CLI transcript here: <https://gist.github.com/brunoborges/167c988a0c4c16b8ccffca995ae98ce2>

Let me show you the timeline, because it's kind of wild:

- **Domain purchased:** 11:21:27 AM EDT

![Domain purchase confirmation timestamp showing 11:21:27 AM EDT](images/media/domain-purchase-timestamp.png)

- **Site live with HTTPS:** Around 11:35 AM EDT

![The live website being served over the custom domain with HTTPS](images/media/live-site-custom-domain.png)

That's **roughly 14 minutes** from "I have nothing" to "fully deployed site with a custom domain and HTTPS." And I didn't manually edit a single DNS record.

> **Why HTTPS matters:** GitHub Pages automatically provisions SSL certificates for custom domains via Let's Encrypt. This means your site is served over HTTPS, which is not just good for security — it's also what search engines prefer, what browsers trust, and what users expect. And you get it for free, automatically. Pretty sweet!

## Key Takeaways

Let me break down what made this so fast:

- **GitHub Pages does the hosting** — free, fast, and supports custom domains out of the box.
- **Cheap TLDs exist** — `.click` cost me $2. Other affordable options: `.xyz`, `.online`, `.site`. You don't need to spend $15 on a `.com` for every side project.
- **The Namecheap skill eliminates DNS friction** — no copying IPs, no dropdown menus, no wondering if you got it right. Just natural language requests.
- **GitHub Copilot CLI ties it all together** — it can create the site, configure GitHub Pages, manage DNS, commit files, and verify the deployment. It's basically a DevOps assistant in your terminal.

The hardest part was remembering my Namecheap password. Everything else? Smooth sailing.

## Go Build Something!

So that's the workflow. If you've been putting off launching a side project because DNS feels like a chore... well, now you have no excuse 😄

Grab a cheap domain, spin up a GitHub Pages site, install the skill, and let Copilot handle the plumbing. Then you can get back to building the thing you actually care about.

Give it a shot, and let me know how it goes! I'd love to hear what you deploy. Hit me up — and happy shipping! 🚀
