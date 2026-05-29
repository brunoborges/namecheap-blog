# I Usually Dread DNS — So I Made an AI Do It in 14 Minutes

Here's a confession, folks: DNS terrifies me a little. Not in a "can't figure it out" way — more in a "I always typo something and then wait 48 hours wondering if the internet is broken or if I am" way. It's that particular flavor of anxiety where you *know* you're one misplaced record away from a site that resolves to nowhere.

So when I decided my brand-new GitHub Pages site deserved a proper custom domain, I made myself a promise: **I will not manually edit a single DNS record.** Instead, I'd hand the scary part to GitHub Copilot CLI, lean back, and watch what happened.

Spoiler: it worked. In about fourteen minutes. And honestly? Watching the AI confidently set those A records was a small, nerdy thrill I didn't expect.

Let me walk you through the whole arc — from empty repo to live site on a custom domain — without once opening a DNS management panel.

---

## Act 1: Conjuring a Website Out of Thin Air

Every good story needs a beginning, and ours starts in the most mundane place possible: the "Create a new repository" screen on GitHub. I spun up a fresh public repo — nothing fancy, just a blank canvas waiting for something to happen.

![Creating a new public GitHub repository on GitHub](images/media/create-github-repo.png)

And just like that, a repo exists. Feels like planting a flag on the moon, except the moon is free and hosted by Microsoft.

![The newly created empty repository on GitHub](images/media/new-repository.png)

Now here's where things get fun. Instead of hand-crafting HTML like it's 2005, I asked Copilot CLI to build me a landing page *and* enable GitHub Pages in one shot. One prompt, two outcomes. The AI scaffolded the page, pushed it, flipped on Pages — boom, we have a live site on `*.github.io`. 🎉

![Copilot CLI creating a landing page and enabling GitHub Pages in a single flow](images/media/copilot-create-landing-page-enable-pages.png)

Easy peasy. But a `.github.io` URL, while functional, doesn't exactly scream "I have my life together." Time for a real domain.

---

## Act 2: Two Dollars and a .click

I wanted the cheapest possible domain that still looked intentional. After a quick search on Namecheap, I landed on the `.click` TLD — because at **USD $2.00** (about CAD $2.46), it's basically the price of a mediocre coffee. The domain? `ghpagesblog.click`. Short, descriptive, absurdly cheap.

![Searching for an available .click domain on Namecheap](images/media/search-click-domain.png)

One click to confirm (pun intended), and the domain was mine.

![Confirming the purchase of ghpagesblog.click](images/media/confirm-domain-purchase.png)

At this point I glanced at the clock: **11:21:27 AM EDT**. Remember that timestamp — it becomes important later.

---

## Act 3: Wiring It Up — The Part I Didn't Have to Dread

Here's where the old me would have opened the Namecheap DNS panel, squinted at a table of records, Googled "GitHub Pages A records" for the 47th time, and carefully typed four IP addresses while praying I didn't fat-finger one. Instead, I took a different path.

### Flipping on the Namecheap API

First things first: Namecheap's API isn't enabled by default (sensible, honestly). You need to flip it on. Head to **Profile → Tools → Business & Dev Tools**, and find the **Namecheap API Access** option under "Manage."

![Namecheap Business and Dev Tools section highlighting the API Access option](images/media/namecheap-business-dev-tools.png)

From the [API access settings page](https://ap.www.namecheap.com/settings/tools/apiaccess/), you toggle the API **ON**, add your public IP to the **Whitelisted IPs** list, and copy your **API Key**. Three steps, takes about a minute. If you want the full backstory on Namecheap's API, their [intro docs](https://www.namecheap.com/support/api/intro/) are solid.

![Namecheap API access page showing the ON toggle, whitelisted IP addresses, and the API key field](images/media/namecheap-api-access-settings.png)

### Installing the Namecheap Skill

This is where it all comes together. The [Namecheap skill](https://github.com/brunoborges/namecheap-skill) is a Copilot CLI skill that knows how to talk to Namecheap's API — listing domains, reading DNS records, writing them. Think of it as giving the AI a set of hands that can reach into your registrar account.

Install it with one command:

```bash
gh skill install brunoborges/namecheap-skill namecheap-dns --scope user
```

On first use, Copilot will ask for your credentials. It prompted me for my Namecheap username…

![Copilot CLI prompting for the Namecheap API username](images/media/copilot-prompt-username.png)

…and then the API key I'd just copied:

![Copilot CLI prompting for the Namecheap API key](images/media/copilot-prompt-api-key.png)

To confirm everything was wired up, I asked it to list my domains. There it was — `ghpagesblog.click`, ready and waiting.

![Copilot CLI listing the domains associated with the Namecheap account](images/media/copilot-list-domains.png)

### Pointing the Domain at GitHub Pages

Now the moment of truth — the part that usually makes me nervous. I asked Copilot to configure `ghpagesblog.click` to point at my GitHub Pages site, using the skill.

![Asking Copilot CLI to configure the custom domain for GitHub Pages via the Namecheap skill](images/media/copilot-configure-custom-domain.png)

The skill didn't just blindly fire off API calls (good AI!). It paused, showed me exactly what it planned to do, and asked for confirmation. This is the moment I felt a tiny rush — like watching someone parallel-park your car while you hold your breath.

![The Namecheap skill asking for confirmation before modifying DNS records](images/media/skill-dns-confirmation-prompt.png)

I said yes. And then it did *the thing*: replaced the existing DNS records with the four GitHub Pages A records plus a `www` CNAME. No typos. No guessing. No anxiety. Just… done. 🚀

![The skill setting GitHub Pages A records and a www CNAME for the custom domain](images/media/skill-set-dns-records.png)

As a bonus, Copilot also committed a `CNAME` file to the repo — that little file that tells GitHub Pages "hey, this site answers to a custom domain now." One less thing for me to remember.

![Copilot committing the CNAME file containing the custom domain to the repository](images/media/copilot-commit-cname-file.png)

---

## Act 4: The Payoff — Is It Actually Live?

DNS propagation is famously unpredictable, but I was optimistic. Copilot verified that the domain was resolving correctly…

![Copilot CLI verifying DNS resolution for ghpagesblog.click](images/media/copilot-verify-dns-resolution.png)

…and then confirmed the site was returning a beautiful HTTP 200:

![Copilot CLI confirming that the custom domain returns HTTP 200](images/media/copilot-verify-http-200.png)

I pulled up the purchase confirmation to double-check my timeline. Domain bought at **11:21:27 AM EDT**:

![Domain purchase confirmation showing the 11:21:27 AM EDT timestamp](images/media/domain-purchase-timestamp.png)

And the site? Live on the custom domain by roughly **11:35 AM EDT** — with HTTPS enforced, no less:

![The live website served over the custom domain ghpagesblog.click](images/media/live-site-custom-domain.png)

**~14 minutes from purchase to live site.** That includes API setup, skill installation, DNS configuration, propagation, and verification. Not bad for something that used to ruin my afternoon.

---

## The Whole Session, If You're Curious

I captured the full Copilot CLI session in a gist if you want to see every prompt and response: [check it out here](https://gist.github.com/brunoborges/167c988a0c4c16b8ccffca995ae98ce2).

---

## So — Was It Worth It?

Look, I'm not going to pretend DNS is *hard*. It's not rocket science. But it is fiddly, it's easy to mess up, and the feedback loop is slow enough that mistakes feel expensive. What I loved about this workflow wasn't just speed — it was *confidence*. The AI showed me its plan, I approved it, and it executed flawlessly. No Googling IP addresses, no second-guessing TTL values, no refreshing `dig` output for ten minutes.

Two dollars for the domain. Fourteen minutes of my time. Zero DNS records touched by human hands. And one quietly satisfying afternoon where the thing that usually annoys me… just didn't.

If you've got a Namecheap account and a few minutes, give it a spin. Your future self — the one who won't be debugging a DNS misconfiguration at midnight — will thank you. 🇧🇷
