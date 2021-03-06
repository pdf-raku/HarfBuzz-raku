SRC=src
DocProj=harfbuzz-raku.github.io
DocRepo=https://github.com/harfbuzz-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

all :

docs/index.md : README.md
	cp $< $@

docs/%.md : lib/%.rakumod
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n  $(DocLinker) \
        > $@

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

doc : $(DocLinker) docs/index.md docs/HarfBuzz.md docs/HarfBuzz/Blob.md docs/HarfBuzz/Buffer.md docs/HarfBuzz/Feature.md docs/HarfBuzz/Face.md docs/HarfBuzz/Font.md docs/HarfBuzz/Glyph.md docs/HarfBuzz/Raw.md docs/HarfBuzz/Raw/Defs.md docs/HarfBuzz/Shaper.md

docs/HarfBuzz.md : lib/HarfBuzz.rakumod

docs/HarfBuzz/Shaper.md : lib/HarfBuzz/Shaper.rakumod

docs/HarfBuzz/Blob.md : lib/HarfBuzz/Blob.rakumod

docs/HarfBuzz/Buffer.md : lib/HarfBuzz/Buffer.rakumod

docs/HarfBuzz/Feature.md : lib/HarfBuzz/Feature.rakumod

docs/HarfBuzz/Face.md : lib/HarfBuzz/Face.rakumod

docs/HarfBuzz/Font.md : lib/HarfBuzz/Font.rakumod

docs/HarfBuzz/Glyph.md : lib/HarfBuzz/Glyph.rakumod

docs/HarfBuzz/Raw.md : lib/HarfBuzz/Raw.rakumod

docs/HarfBuzz/Raw/Defs.md : lib/HarfBuzz/Raw/Defs.rakumod

docs/HarfBuzz/Shaper.md : lib/HarfBuzz/Shaper.rakumod

test : all
	@prove6 -I .

loudtest : all
	@prove6 -I . -v

clean :
	@rm -f README.md docs/*.md docs/HarfBuzz/*.md docs/HarfBuzz/*/*.md


