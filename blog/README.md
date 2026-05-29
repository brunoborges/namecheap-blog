# From Zero to a Live Site on a Custom Domain — Without Touching DNS

Let me tell you about my favorite kind of afternoon project: the one that *should*
be a pain, but isn't.

Here's the deal. Namecheap is a popular domain registrar, and publishing a website
almost always means registering a domain and pointing it at wherever your site lives.
Sounds simple. It rarely is — especially if you're not the kind of person who dreams
in `A` records and `CNAME` entries. DNS has a few basic concepts, sure, but it's a
rabbit hole, and once you fall in, you're reading TTL docs at midnight wondering where
your evening went.

So I did the lazy-genius thing: I let an AI assistant do the DNS work for me.

Turns out Namecheap has an [API for managing domains](https://www.namecheap.com/support/api/intro/),
which means we can automate the whole thing — and hand it off to an AI assistant. In
this post I'll buy a dirt-cheap domain, spin up a GitHub Pages site, and wire them
together with GitHub Copilot CLI and a Namecheap skill. The best part? I never touched
a single DNS record by hand. Let's go!

## Step 1: Flip on Namecheap API access

First, we need to let Namecheap's API in. Head to **Profile → Tools**, scroll all the
way down to **Business & Dev Tools**, and click **Manage** under *Namecheap API Access*.

![Namecheap Business & Dev Tools section with the Namecheap API Access option](images/media/image1.png)

Shortcut for the impatient (that's me): log in and go straight to
<https://ap.www.namecheap.com/settings/tools/apiaccess/> (heads up — this URL may change
down the road).

On that page, three quick things:

1. Toggle the API to **ON**.
2. Add the public IP of the machine that'll talk to the API to the **Whitelisted IPs** list.
3. Copy that **API Key** and stash it somewhere safe. You'll want it in a minute.

![Namecheap API access page showing the ON toggle, whitelisted IPs, and API key](images/media/image2.png)

That's it — Namecheap is now scriptable.

## Step 2: Install the Namecheap skill

Now let's give our AI assistant superpowers. Enable the
[Namecheap skill](https://github.com/brunoborges/namecheap-skill).

On a machine running GitHub Copilot CLI, it's a one-liner:

```bash
gh skill install brunoborges/namecheap-skill namecheap-dns --scope user
```

The first time you ask Copilot something like *"list my Namecheap domains"*, it checks
that the skill is wired up. On that first run, it'll ask for your username:

![Copilot CLI prompting for the Namecheap API username](images/media/image3.png)

Type it in. Then it asks for the API key (told you you'd need it):

![Copilot CLI prompting for the Namecheap API key](images/media/image4.png)

And boom — Copilot hands back the list of domains in your account:

![Copilot CLI listing the domains in the Namecheap account](images/media/image5.png)

Easy peasy. 🎉

## Step 3: Buy a (very) cheap domain

For this blog I grabbed one of the cheapest TLDs out there: `.click`.

![Searching for an available .click domain](images/media/image6.png)

![Confirming the .click domain purchase](images/media/image7.png)

Final damage? **USD $2.00** — about CAD $2.46. Two bucks. For a real domain. I'll take it.

## Step 4: Stand up the site on GitHub Pages

Domain in hand, let's get a website live with GitHub Pages.

First, a public repository:

![Creating a new public GitHub repository](images/media/image8.png)

![The newly created repository](images/media/image9.png)

Then I just *asked* Copilot to create a landing page and turn on GitHub Pages. No
clicking through settings menus — I described what I wanted, and it did the work:

![Copilot creating a landing page and enabling GitHub Pages](images/media/image10.png)

## Step 5: Point the domain at GitHub Pages — the fun part

Here's where the Namecheap skill earns its keep:

![Asking Copilot to configure the custom domain via the Namecheap skill](images/media/image11.png)

It'll check in with a question or two before changing anything (good — I like an
assistant that asks before it rewrites my DNS):

![The Namecheap skill asking a confirmation question before changing DNS](images/media/image12.png)

And then it does the heavy lifting — swapping the parking records for GitHub Pages'
`A` records and the `www` `CNAME`. This is the exact part I usually dread, and I just…
watched it happen:

![The skill replacing DNS records with GitHub Pages A records and a CNAME](images/media/image13.png)

It even handled the repo side, adding a `CNAME` file with the custom domain:

![Copilot committing the CNAME file with the custom domain](images/media/image14.png)

## Step 6: Did it actually work? Let's verify

Of course, Copilot doesn't just claim victory — it checks. It confirmed the domain
resolves:

![Copilot verifying DNS resolution for the custom domain](images/media/image15.png)

…and that the site returns a healthy HTTP 200:

![Copilot confirming the custom domain returns HTTP 200](images/media/image16.png)

Want the receipts? The entire Copilot CLI session is right here:
<https://gist.github.com/brunoborges/167c988a0c4c16b8ccffca995ae98ce2>

I bought the domain at **11:21:27 AM EDT**.

![Domain purchase confirmation timestamp](images/media/image17.png)

And the site was live at around **11:35 AM EDT**. Do the math — that's roughly **14
minutes** from "I own nothing" to "it's on the internet with HTTPS." 🚀

![The live website served over the custom domain](images/media/image18.png)

## So, was it worth it?

Honestly? Yeah. Buying a domain, standing up GitHub Pages, and wiring up a custom
domain with HTTPS — start to finish in about 14 minutes, and I didn't touch a single
DNS record myself. The combo of GitHub Copilot CLI and the Namecheap skill turned a
classically fiddly chore into a quick conversation.

Give it a shot, and let me know how it goes! 🇧🇷
