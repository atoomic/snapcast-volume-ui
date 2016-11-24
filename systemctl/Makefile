
all: install

install: 
	install snapcast-ui.conf /etc/default/ 
	install snapcast-ui.service /usr/lib/systemd/system/
	systemctl daemon-reload
	@echo Please run systemctl restart snapcast-ui.service 	
