# Editing Microbial Quanta

How to change anything on the site. The golden rule, content lives in `content/`, design lives in `themes/microbialquanta/`. You almost never need to touch the theme. Most edits are markdown files.

After any edit, the workflow is the same.

```
git add .
git commit -m "Describe what changed"
git push
```

The site rebuilds and goes live in about 60 seconds.

---

## Site structure

The navigation has six tabs.

1. **Home**, the page at the root
2. **Research**, your research interests and current work
3. **Publications**, peer reviewed papers
4. **Lab Tools**, open hardware and 3D printed instruments
5. **Outreach**, podcasts, talks, journal clubs, community building
6. **About**, bio, CV, education, contact

---

## I want to change

### The home page hero carousel

Open `content/_index.md`. The carousel is controlled by two frontmatter fields.

`carousel_interval_ms`, how long each slide stays on screen in milliseconds. Default is 7000, which is 7 seconds.

`carousel_slides`, a list of slides. Each slide has a label, title, detail, and optional image. Edit, add, or remove slides freely. Four to six slides works well.

```yaml
carousel_slides:
  - label: "Fig 1, Scanning Electron Microscopy"
    title: "<em>Thiovulum</em>, the world's fastest bacterium"
    detail: "A short caption with more detail about the image."
    image: "/images/thiovulum-sem.jpg"
```

If the `image` field is empty, the site shows a brand color gradient placeholder instead.

### The home page introduction

Same file, `content/_index.md`. Edit these frontmatter fields.

- `intro_eyebrow`, the small label above the headline
- `intro_headline`, the main headline. Use `<em>...</em>` for italics
- `intro_paragraphs`, a list of paragraphs. The first is shown larger as the lede

### The featured work entries on the home page

Same file. The `featured_entries` list has four entries by default. Each has a section name, title, description, meta line, url, and optional image. Add or remove entries to change what is featured.

### The navigation menu

Open `config/_default/menus.en.toml`. Each menu item is a `[[main]]` block with name, pageRef, and weight. Lower weight is farther left. Edit, add, or remove blocks.

The footer links are in the same file as `[[footer]]` blocks.

### The text on a section page

Each section has an `_index.md` file. Open it and edit the markdown body (everything below the second `---`). Standard markdown rules apply.

- `content/research/_index.md`
- `content/publications/_index.md`
- `content/lab-tools/_index.md`
- `content/outreach/_index.md`
- `content/about/_index.md`

### A publication

Open `data/publications.yaml`. Each publication is a YAML block.

```yaml
- title: "Your paper title"
  authors: "Schaible GA, Other AB"
  venue: "Nature Microbiology"
  year: 2025
  doi: "10.xxxx/yyy"     # optional
  url: "https://..."     # optional
  pdf: "/files/foo.pdf"  # optional
```

Add new entries at the top to keep them sorted newest first.

### An outreach activity

Open `content/outreach/_index.md`. The `activities` list in frontmatter holds each item. Each activity has a date, title, institution, and description. HTML is allowed in the description field, so you can add links like `<a href='...'>...</a>`.

### A lab tool / project

Each project is a markdown file in `content/lab-tools/`. To add a new one.

```
hugo new content lab-tools/new-tool-name.md
```

The frontmatter fields that drive how it appears on the landing page.

```yaml
title: "Tool name"
description: "Short one line description that appears on the card."
weight: 10        # lower weight shows first in the grid
status: "complete"          # complete, in-progress, or planned
status_label: "Documented"  # label shown next to the status dot
category: "Microscopy"      # any category label you want
cover_image: "/images/tool-photo.jpg"  # optional, shows on the card
```

The status dot color matches the status value, complete is teal, in-progress is amber, planned is violet.

### My name or affiliation

Open `config/_default/params.toml`. Edit `author_name`, `affiliation_title`, and `affiliation_institution`. These appear in the top dark strip and in the footer.

### Brand colors

Open `themes/microbialquanta/assets/css/main.css`. The first block (`:root`) has all the color variables. Change a hex code and every use of that color updates site wide.

### Fonts

Same file. Two places.

1. The `@import` line at the top fetches fonts from Google Fonts. To use a different font, find it on fonts.google.com and grab its import URL.
2. The `--font-serif` and `--font-sans` variables in `:root`. Change the family name there.

---

## Adding things

### A new image

Drop the image file in `static/images/`. Reference it in markdown as `![Caption](/images/filename.jpg)` or in frontmatter as `image: "/images/filename.jpg"`.

Resize images before committing. Web sized JPEGs, under 2 MB each, ideally 1600 pixels wide max. Quick resize with ImageMagick.

```
magick input.tif -resize '1600x1600>' -quality 82 output.jpg
```

### A new lab tool

```
hugo new content lab-tools/your-tool-name.md
```

Fill in frontmatter, write build notes in markdown, add downloadable files to `static/files/`, push.

### A new section

Three steps.

1. Create the folder and index file, `mkdir content/newsection && touch content/newsection/_index.md`
2. Add a frontmatter title, description, and eyebrow to that file
3. Add a menu entry in `config/_default/menus.en.toml`

Push. The section appears in the nav and has a list page automatically.

---

## Workflow tips

### Preview locally before pushing

```
cd ~/projects/microbialquanta
hugo server -D
```

Open `http://localhost:1313`. `-D` includes drafts. Edits to markdown auto-reload in the browser.

### When something breaks

The Actions tab on GitHub shows every build. Red X means the build failed, click in to see the error. You can always revert your last change with `git revert HEAD && git push`.

---

## Where everything lives

```
microbialquanta/
├── content/                              <- markdown files (what you edit most)
│   ├── _index.md                         <- home page
│   ├── about/_index.md
│   ├── research/_index.md
│   ├── publications/_index.md
│   ├── lab-tools/
│   │   ├── _index.md                     <- lab tools landing page
│   │   └── *.md                          <- individual tool pages
│   └── outreach/_index.md
├── data/
│   └── publications.yaml                 <- publications list
├── static/
│   ├── images/                           <- site images
│   ├── files/                            <- downloadable files
│   └── CNAME                             <- custom domain
├── config/_default/
│   ├── hugo.toml                         <- main config
│   ├── languages.en.toml
│   ├── menus.en.toml                     <- navigation
│   └── params.toml                       <- author info
├── themes/microbialquanta/               <- the custom theme
│   ├── assets/css/main.css               <- all visual styling
│   └── layouts/                          <- HTML templates
└── .github/workflows/hugo.yml            <- CI / CD
```
