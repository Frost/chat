# Compiling of assets

.PHONY: clean run

run: public/javascript/*.js public/style/*.css
	@node index.js

clean:
	@rm -f public/javascript/*.js
	@rm -f public/style/*.js

highlight.js/build/highlight.pack.js: highlight.js/tools/build.py
	@python3 highlight.js/tools/build.py -tbrowser -n coffeescript

public/javascript/highlight.js: highlight.js/build/highlight.pack.js
	@cp highlight.js/build/highlight.pack.js public/javascript/

public/style/monokai_sublime.css: highlight.js/src/styles/monokai_sublime.css
	@cp highlight.js/src/styles/monokai_sublime.css public/style/

public/javascript/%.js: client/%.coffee
	coffee -o public/javascript -c $<

public/style/%.css: style/%.styl
	stylus -o public/style -u ./node_modules/nib/ $<