# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Git Community Book 中文翻译项目 - A Chinese translation of the Git Community Book. This is a static site generator built with Ruby/Rake that converts Markdown content into HTML chapters and PDF books.

**Online**: https://gitbook.lkiuhui998.com
**Original**: https://github.com/schacon/gitbook

## Build System Architecture

### Content Pipeline

The build system follows a multi-stage pipeline:

1. **Merge Phase** (`rake merge`): Collects all `text_zh/**/*.markdown` files (sorted) and concatenates them into `output/full_book.markdown`
2. **HTML Phase** (`rake html`):
   - Converts merged Markdown to HTML using RDiscount
   - Splits content by `<h1>` (sections) and `<h2>` (chapters)
   - Generates individual chapter files in `output/book/`
   - Creates navigation links and table of contents
   - Applies syntax highlighting (Ultraviolet for Ruby code)
   - Processes special markers: `linkgit:`, `[fig:]`, `[gitcast:]`
3. **PDF Phase** (`rake pdf` or `rake pdf1`):
   - `rake pdf`: Uses Prince XML (legacy, requires commercial license)
   - `rake pdf1`: Uses PDFKit/wkhtmltopdf (current method)
   - Generates `output/book.pdf` from `output/index.html`

### Key Build Commands

```bash
# Setup
bundle install

# Generate HTML book (includes merge step)
rake html

# Generate PDF book (includes HTML step)
rake pdf1          # Current method using PDFKit
rake pdf           # Legacy method using Prince XML

# Individual steps
rake merge         # Only merge markdown files
```

## Content Structure

### Source Content

- **text_zh/**: Chinese translation content (primary)
- **text/**: Original English content (reference)

Each chapter directory follows naming convention:
```
XX_Chapter_Name/
  0_ Chapter_Title.markdown      # Main chapter content
  00_Section_Title.markdown      # Section intro (optional)
```

Files are sorted alphabetically during merge, so numbering prefixes control order.

### Generated Output

- **output/full_book.markdown**: Merged content (intermediate)
- **output/index.html**: Single-page HTML version (for PDF conversion)
- **output/book/**: Multi-page HTML book
  - `index.html`: Table of contents
  - `1_1.html`, `1_2.html`, etc.: Individual chapters
  - `images/`: Copied assets
- **output/book.pdf**: Final PDF

## Special Markdown Extensions

The build system processes custom markers in Markdown:

- `linkgit:command[1]` → Links to kernel.org Git documentation
- `[fig:filename]` → Inserts figure from `assets/images/figure/`
- `[gitcast:name](description)` → Embeds GitCast video (HTML only, removed in PDF)
- Ruby code blocks (`` ```ruby ``) → Syntax highlighted via Ultraviolet

## Template System

Templates in `layout/` use placeholder replacement:

- **book_index_template.html**: TOC page, replaces `#body`
- **chapter_template.html**: Chapter pages, replaces `#title`, `#body`, `#nav`
- **pdf_template.html**: Single-page version, replaces `#body`
- **second.css**: Main stylesheet
- **mac_classic.css**: Syntax highlighting theme

## Development Notes

### Ruby Compatibility

Project uses Ruby 3.2.0+ with compatibility fix for deprecated `File.exists?` (see `script/html.rb:12-16`)

### Chapter Status Tracking

The HTML generator marks chapters as "done" or "todo" based on content size:
- `MIN_SIZE = 800` bytes (defined in `script/html.rb:9`)
- Chapters below threshold get CSS class `todo`
- Used for tracking translation progress

### Content Size Threshold

If editing chapter detection logic, note that chapter size is calculated AFTER:
- Markdown-to-HTML conversion
- Code syntax highlighting
- Special marker replacement

This means raw Markdown size ≠ processed HTML size.

## Common Workflows

### Adding New Chapter

1. Create directory: `text_zh/NN_Chapter_Name/`
2. Add content: `0_ Chapter_Title.markdown`
3. Use numerical prefix to control ordering
4. Run `rake html` to verify rendering

### Modifying Build Pipeline

Build scripts are modular:
- `script/merge.rb`: Chapter collection logic
- `script/html.rb`: HTML generation + syntax highlighting + replacements
- `script/pdf1.rb`: PDF generation via PDFKit
- Templates: `layout/*.html`

Changes to content processing should go in `do_replacements()` function in `script/html.rb`.

### Testing Changes

```bash
# Quick HTML test
rake html && open output/book/index.html

# Full PDF test
rake pdf1 && open output/book.pdf
```

## Dependencies

- **kramdown**: Markdown parser (replaced rdiscount for Ruby 3.2+ compatibility)
- **ultraviolet**: Syntax highlighting (uses TextMate themes)
- **builder**: XML/HTML generation for TOC
- **pdfkit + wkhtmltopdf-binary**: PDF generation

## Recent Fixes

### Build System Improvements (2025-12-11)

**Fixed Cloudflare Pages deployment failures**:

1. **PDF Generation Error Handling**: Added try-catch block in `script/pdf1.rb` to gracefully handle PDF generation failures in build environments where wkhtmltopdf may not be available
   - PDF generation now continues even if it fails
   - Build process completes successfully with HTML-only output
   - Error messages clearly indicate PDF generation status

2. **Output Directory Creation**: Fixed `script/merge.rb` to ensure `output/` directory exists before writing files
   - Added `FileUtils.mkdir_p('output')` check
   - Prevents "No such file or directory" errors on clean builds

3. **PDF Copy Safety**: Modified `script/html.rb` to only copy PDF if it exists
   - Changed `cp output/book.pdf output/book/` to conditional execution
   - Prevents build failures when PDF generation is unavailable

4. **Removed `open` Command**: Commented out `open output/book.pdf` in `script/pdf1.rb`
   - The `open` command is not available in CI/CD environments
   - Prevents unnecessary build failures

These changes ensure the build succeeds even when PDF generation tools are unavailable, which is common in containerized or restricted build environments like Cloudflare Pages.

## Troubleshooting

### rdiscount Compilation Failure (Ruby 3.2+)

**Issue**: The `rdiscount` gem (v2.2.7) has C99 compatibility issues with modern Ruby versions. Compilation fails with: `parameter 'val' was not declared, defaults to 'int'` in `gethopt.c`.

**Solution Implemented**: This project has been updated to use `kramdown` with GFM support instead of `rdiscount`:

- **Gemfile**:
  - Changed `gem 'rdiscount'` → `gem 'kramdown'`
  - Added `gem 'kramdown-parser-gfm'` for GitHub Flavored Markdown support
- **script/html.rb**:
  - Changed `require 'rdiscount'` → `require 'kramdown'`
  - Changed `RDiscount.new(output).to_html` → `Kramdown::Document.new(output, input: 'GFM').to_html`
  - Updated regex to match HTML headers with attributes: `split(/<h1[^>]*>/)` instead of `split('<h1>')`
  - Added nil-safety `(links[0,4] || [])` to handle varying section counts
  - Fixed Builder syntax: `toc.a(...) { toc << text }` instead of `toc.a(...) << text`
- **script/merge.rb**: Changed separator from `\r\n` to `\n\n` for proper markdown block separation
- **Section files**: Fixed 4 files missing space after `#`: `介绍`, `第一步`, `中级技能`, `Git生态体系`
- **text_zh/31_Git_Hooks**: Converted tab-indented code blocks to triple-backtick format (```language)

**Key Changes**:
1. **GFM Support**: kramdown alone doesn't support triple-backtick code blocks - GFM parser is required
2. **Code Block Format**: Tab-indented code blocks cause parsing issues; triple-backtick format required
3. **Header Format**: kramdown generates headers with IDs like `<h1 id="section">Title</h1>`

**Alternative Options** (if you need original rdiscount):

1. **Use Docker**:
   ```bash
   docker build -t gitbook .
   docker run -v $(pwd):/app gitbook rake html
   ```

2. **Patch rdiscount** (advanced):
   Edit `~/.rbenv/versions/3.2.0/lib/ruby/gems/3.2.0/gems/rdiscount-2.2.7/ext/gethopt.c:48` to add explicit type declarations.

### Other Issues

- **Syntax highlighting warnings**: Ultraviolet gem shows regex warnings on Ruby 3.x. These are harmless and don't affect output.
- **UTF-8 regex errors**: "invalid multibyte escape" warnings from textpow are ignorable.
