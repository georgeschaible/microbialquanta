# Microbial Quanta

Personal academic and research site for George Schaible — [microbialquanta.com](https://microbialquanta.com).

Built with [Hugo](https://gohugo.io) using the [Blowfish](https://blowfish.page) theme, deployed via GitHub Actions to GitHub Pages.

## Local development

```bash
git clone https://github.com/georgeschaible/microbialquanta.git
cd microbialquanta
git submodule update --init --recursive
hugo server -D
# open http://localhost:1313
```

Requires Hugo **extended** (≥ 0.140).

## Adding content

```bash
hugo new content blog/your-post-title.md
hugo new content projects/your-project-name.md
```

Drafts (`draft: true` in frontmatter) are only visible with `hugo server -D`.

## Deployment

Pushes to `main` trigger the workflow at `.github/workflows/hugo.yml`, which builds with the extended Hugo and deploys to GitHub Pages.

## Structure

- `content/` — markdown for every page
- `data/publications.yaml` — publications list
- `assets/css/` — custom CSS overrides (brand colors, typography)
- `layouts/shortcodes/` — custom shortcodes (STL viewer, publications list)
- `static/files/` — downloadable assets (STL, OpenSCAD, PDFs)
- `static/images/` — site images
- `config/_default/` — Hugo config

See [`SETUP.md`](./SETUP.md) for the full setup walkthrough.
