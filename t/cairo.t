use HarfBuzz;
use Cairo;
use Font::FreeType;
use Font::FreeType::Face;
use Test;
plan 42;

if HarfBuzz.version < v1.6.0 {
    skip-rest "HarfBuzz version ({HarfBuzz.version}) is too old";
    exit;
}

my $file = 't/fonts/NimbusRoman-Regular.otf';
my $ft-face = Font::FreeType.new.face($file);
my $text = 'Hell€!';
my HarfBuzz $hb .= new: :$file, :$text, :language<epo>;
my HarfBuzz $hb-ft .= new: :text<blah>, :language<epo>, :$ft-face;
$hb-ft.set-text: $text;

for $hb, $hb-ft {
    my Cairo::Glyphs $glyphs = .cairo-glyphs;
    is $glyphs.elems, $text.chars;
    enum <index x y>;
    my Array @expected = [41, 0, 0 ], [70, 11.28, 0], [77, 17.88, 0], [77, 22.22, 0], [347, 26.56, 0], [2, 34.38, 0];

    for 0 ..^ @expected {
        my Cairo::cairo_glyph_t:D $glyph = $glyphs[$_];

        is $glyph.index, @expected[$_][index], "glyph $_ index";
        is $glyph.x.round(.01), @expected[$_][x],  "glyph $_ x";
        is $glyph.y.round(.01), @expected[$_][y],  "glyph $_ y";
    }

    is $glyphs.x-advance.round(0.01), 39.58;
    is $glyphs.y-advance.round(0.01), 0;
}

