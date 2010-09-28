
tut1:
	mkdir _img || true
	bundle exec ./liquify.rb ~/rabbitmq-tutorials/python/tutorial-one.mdx > \
		 ~/rabbitmq-tutorials/python/tutorial-one.md
	bundle exec ./github-markup ~/rabbitmq-tutorials/python/tutorial-one.md > \
		/tmp/a.html


install:
	dpkg -L graphviz python-pygments > /dev/null
	bundle install

