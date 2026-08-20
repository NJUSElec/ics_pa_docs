SRC_PATH = ./
BOOK_PATH = ./_book 
PORT = 8000

web:  
	gitbook build $(SRC_PATH)  
#   Fix links for the offline version. See https://github.com/NJU-ProjectN/ics-pa-gitbook/issues/5
#   sed -i -e 's/if(m)for(n.handler/if(false)for(n.handler/' $(BOOK_PATH)/gitbook/theme.js
# 	ls $(BOOK_PATH)/*.html | xargs sed -i -e 's+"./"+"index.html"+'
	cd $(BOOK_PATH) && python -m http.server $(PORT)

init:
	npm ci
	sed -i -r 's/<h3>/<h5>/' node_modules/gitbook-plugin-callouts/index.js

clean:
	rm -r $(BOOK_PATH)
